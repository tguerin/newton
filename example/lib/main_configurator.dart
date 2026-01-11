import 'dart:async';

import 'package:example/available_effect.dart';
import 'package:example/code_generator.dart';
import 'package:example/color_selection.dart';
import 'package:example/range_selection.dart';
import 'package:example/single_value_selection.dart';
import 'package:example/theme.dart';
import 'package:flutter/material.dart' hide Velocity;
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:newton_particles/newton_particles.dart';

void main() {
  runApp(const NewtonExampleApp());
}

class NewtonExampleApp extends StatelessWidget {
  const NewtonExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(colorScheme: MaterialTheme.lightMediumContrastScheme()),
      darkTheme: ThemeData(colorScheme: MaterialTheme.darkMediumContrastScheme()),
      home: const NewtonConfigurationPage(),
    );
  }
}

class NewtonConfigurationPage extends StatefulWidget {
  const NewtonConfigurationPage({super.key});

  @override
  State<NewtonConfigurationPage> createState() => _NewtonConfigurationPageState();
}

class _NewtonConfigurationPageState extends State<NewtonConfigurationPage> {
  static const int maxParticlesPhysics = 3000;
  static const int maxParticlesDeterministic = 3000;

  final _configuredEffects = <_ConfiguredEffect>[
    _ConfiguredEffect(
      effectName: 'Rain',
      effectConfiguration: defaultRelativisticEffectConfigurationsPerAnimation[AvailableEffect.rain]!,
    ),
  ];
  AvailableEffect _selectedAnimation = AvailableEffect.scratch;

  bool _usePhysics = true;
  bool _randomnessOptionsOpened = false;
  bool _randomnessOptionsHovered = false;

  bool _emissionOptionsOpened = false;
  bool _emissionOptionsHovered = false;

  bool _particleOptionsOpened = false;
  bool _particleOptionsHovered = false;

  bool _physicsOptionsOpened = false;
  bool _physicsOptionsHovered = false;

  String _currentEffectName = '';

  final _randomnessScrollController = ScrollController();

  _ConfiguredEffect? _currentConfiguredEffect;

  // Track active particle counts per effect configuration from debug stream
  final _activeParticleCounts = <EffectConfiguration, int>{};

  // Track total emitted particle counts per effect configuration from debug stream
  final _totalEmittedCounts = <EffectConfiguration, int>{};

  StreamSubscription<NewtonDebugData>? _debugDataSubscription;

  // Global key to access NewtonState
  final _newtonKey = GlobalKey();

  /// Copies text to clipboard using Flutter's Clipboard API (works on web and native).
  Future<bool> _copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _currentConfiguredEffect = _configuredEffects.first;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _subscribeToDebugData();
    });
  }

  void _subscribeToDebugData() {
    // Wait for the widget tree to be built, then subscribe to debug stream
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newtonState = _newtonKey.currentState as NewtonState?;
      if (newtonState != null && _debugDataSubscription == null) {
        _debugDataSubscription = newtonState.debugDataStream.listen((debugData) {
          if (mounted) {
            setState(() {
              _activeParticleCounts.clear();
              _totalEmittedCounts.clear();
              for (final effectData in debugData.effectData) {
                _activeParticleCounts[effectData.configuration] = effectData.activeParticleCount;
                _totalEmittedCounts[effectData.configuration] = effectData.totalEmittedCount;
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_configuredEffects.isNotEmpty) ...[
            Tooltip(
              message: 'Copy complete runnable app code (with main, imports, and widget)',
              child: FloatingActionButton(
                heroTag: 'copy_all',
                onPressed: () async {
                  final code = generateRunnableApp(
                    _configuredEffects.map((e) => e.effectConfiguration).toList(),
                  );
                  final success = await _copyToClipboard(code);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Complete runnable app code copied to clipboard!'
                              : 'Failed to copy to clipboard. Please try again.',
                        ),
                      ),
                    );
                  }
                },
                child: const Icon(Icons.code),
              ),
            ),
            const Gap(8),
          ],
          Tooltip(
            message: 'Add new effect',
            child: FloatingActionButton(
              heroTag: 'add',
              child: const Icon(Icons.add),
              onPressed: () {
                unawaited(
                  showDialog(
                    context: context,
                    builder: (context) => StatefulBuilder(
                      builder: (context, setDialogState) {
                        return AlertDialog(
                          content: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Effect name',
                                    errorText: _configuredEffects
                                            .map((effect) => effect.effectName)
                                            .contains(_currentEffectName)
                                        ? "Can't have same effect name"
                                        : null,
                                  ),
                                  onChanged: (name) {
                                    setDialogState(() {
                                      _currentEffectName = name;
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 200,
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: _selectedAnimation.label,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    elevation: 16,
                                    onChanged: (String? value) {
                                      // This is called when the user selects an item.
                                      setDialogState(() {
                                        _selectedAnimation = AvailableEffect.of(value!);
                                      });
                                    },
                                    // Filter out smoke in relativistic effect as it's not supported
                                    items: AvailableEffect.values
                                        .where((effect) => !_usePhysics || effect != AvailableEffect.smoke)
                                        .map<DropdownMenuItem<String>>((AvailableEffect value) {
                                      return DropdownMenuItem<String>(
                                        value: value.label,
                                        child: Text(value.label),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: _usePhysics,
                                      onChanged: (value) {
                                        setDialogState(() {
                                          _usePhysics = value ?? false;
                                        });
                                      },
                                    ),
                                    const Gap(4),
                                    Text('Use physics', style: Theme.of(context).textTheme.labelMedium),
                                  ],
                                ),
                                const Gap(24),
                                ElevatedButton(
                                  onPressed: _currentEffectName.isEmpty
                                      ? null
                                      : () {
                                          Navigator.pop(context);
                                          setState(() {
                                            _configuredEffects.add(
                                              _currentConfiguredEffect = _ConfiguredEffect(
                                                effectName: _currentEffectName,
                                                effectConfiguration: _usePhysics
                                                    ? defaultRelativisticEffectConfigurationsPerAnimation[
                                                        _selectedAnimation]!
                                                    : defaultDeterministicEffectConfigurationsPerAnimation(
                                                        MediaQuery.sizeOf(context),
                                                      )[_selectedAnimation]!,
                                              ),
                                            );
                                            _selectedAnimation = AvailableEffect.scratch;
                                            _currentEffectName = '';
                                          });
                                        },
                                  child: const Text('Add new effect'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _emissionOptionsOpened = false;
            _particleOptionsOpened = false;
            _physicsOptionsOpened = false;
            _randomnessOptionsOpened = false;
          });
        },
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Newton(
                key: _newtonKey,
                effectConfigurations: _configuredEffects.map((effect) => effect.effectConfiguration).toList(),
                onEffectStateChanged: (effect, state) {},
                child: _hasRainEffect()
                    ? Center(
                        child: NewtonCollider(
                          borderRadius: BorderRadius.circular(20),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Collider',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
              Positioned(
                left: 0,
                top: 0,
                child: _configurationSection(),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: _particleCountStatus(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _configurationSection() {
    final currentConfiguredEffect = _currentConfiguredEffect;
    if (currentConfiguredEffect == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: currentConfiguredEffect.effectName,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  onChanged: (String? value) {
                    setState(() {
                      _currentConfiguredEffect = _configuredEffects.firstWhere((effect) => effect.effectName == value);
                    });
                  },
                  items: _configuredEffects.map<DropdownMenuItem<String>>((effect) {
                    return DropdownMenuItem<String>(
                      value: effect.effectName,
                      child: Text(effect.effectName),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Tooltip(
                  message: 'Copy Dart code for this effect to clipboard',
                  child: FilledButton.tonal(
                    onPressed: () async {
                      final code = generateEffectCode(
                        currentConfiguredEffect.effectConfiguration,
                        effectName: currentConfiguredEffect.effectName,
                      );
                      final success = await _copyToClipboard(code);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'Effect code copied to clipboard!'
                                  : 'Failed to copy to clipboard. Please try again.',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Copy Code'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Tooltip(
                  message: 'Delete this effect',
                  child: FilledButton.tonal(
                    onPressed: () {
                      setState(() {
                        if (_currentConfiguredEffect != null) {
                          _configuredEffects.remove(_currentConfiguredEffect);
                          if (_configuredEffects.isNotEmpty) {
                            _currentConfiguredEffect = _configuredEffects.last;
                          } else {
                            _currentConfiguredEffect = null;
                          }
                        }
                      });
                    },
                    child: const Text('Delete effect'),
                  ),
                ),
              ),
            ],
          ),
          const Gap(8),
          ..._emissionOptions(currentConfiguredEffect),
          ..._particleOptions(currentConfiguredEffect),
          ..._randomnessOptions(currentConfiguredEffect),
          if (_currentConfiguredEffect?.effectConfiguration is PhysicsEffectConfiguration)
            ..._physicsOptions(currentConfiguredEffect),
        ],
      ),
    );
  }

  List<Widget> _emissionOptions(_ConfiguredEffect configuredEffect) {
    return [
      MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _emissionOptionsHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _emissionOptionsHovered = false;
          });
        },
        child: GestureDetector(
          onTap: () {
            setState(() {
              _emissionOptionsOpened = !_emissionOptionsOpened;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: .4)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _emissionOptionsOpened
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _particlesPerEmitSection(configuredEffect),
                        _emitDurationSection(configuredEffect),
                        _particleCount(configuredEffect),
                        _originDxSection(configuredEffect),
                        _originDySection(configuredEffect),
                        _particleAngleSection(configuredEffect),
                      ],
                    )
                  : Text(
                      'Emission',
                      style: TextStyle(
                        decoration: _emissionOptionsHovered ? TextDecoration.underline : TextDecoration.none,
                      ),
                    ),
            ),
          ),
        ),
      ),
      const Gap(8),
    ];
  }

  List<Widget> _particleOptions(_ConfiguredEffect configuredEffect) {
    return [
      MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _particleOptionsHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _particleOptionsHovered = false;
          });
        },
        child: GestureDetector(
          onTap: () {
            setState(() {
              _particleOptionsOpened = !_particleOptionsOpened;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: .4)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _particleOptionsOpened
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _colorSelection(configuredEffect),
                        const Gap(4),
                        _sizeSelection(configuredEffect),
                      ],
                    )
                  : Text(
                      'Particle Shape',
                      style: TextStyle(
                        decoration: _particleOptionsHovered ? TextDecoration.underline : TextDecoration.none,
                      ),
                    ),
            ),
          ),
        ),
      ),
      const Gap(8),
    ];
  }

  List<Widget> _randomnessOptions(_ConfiguredEffect configuredEffect) {
    return [
      MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _randomnessOptionsHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _randomnessOptionsHovered = false;
          });
        },
        child: GestureDetector(
          onTap: () {
            setState(() {
              _randomnessOptionsOpened = !_randomnessOptionsOpened;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: .4)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _randomnessOptionsOpened
                  ? ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 400),
                      child: Scrollbar(
                        controller: _randomnessScrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _randomnessScrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _animationDurationSection(configuredEffect),
                              if (configuredEffect.effectConfiguration is DeterministicEffectConfiguration)
                                _particleDistanceSection(configuredEffect),
                              _offsetOriginDxSection(configuredEffect),
                              _offsetOriginDySection(configuredEffect),
                              _particleBeginScaleSection(configuredEffect),
                              _particleEndScaleSection(configuredEffect),
                              _particleFadeoutProgressSection(configuredEffect),
                              _particleFadeinProgressSection(configuredEffect),
                              if (configuredEffect.effectConfiguration is DeterministicEffectConfiguration) ...[
                                _trailProgressSection(configuredEffect),
                                _trailWidthSection(configuredEffect),
                              ],
                            ],
                          ),
                        ),
                      ),
                    )
                  : Text(
                      'Randomness',
                      style: TextStyle(
                        decoration: _randomnessOptionsHovered ? TextDecoration.underline : TextDecoration.none,
                      ),
                    ),
            ),
          ),
        ),
      ),
      const Gap(8),
    ];
  }

  List<Widget> _physicsOptions(_ConfiguredEffect configuredEffect) {
    return [
      MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _physicsOptionsHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _physicsOptionsHovered = false;
          });
        },
        child: GestureDetector(
          onTap: () {
            setState(() {
              _physicsOptionsOpened = !_physicsOptionsOpened;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: .4)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _physicsOptionsOpened
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _gravityDxSection(configuredEffect),
                        _gravityDySection(configuredEffect),
                        _density(configuredEffect),
                        _friction(configuredEffect),
                        _restitution(configuredEffect),
                        _velocity(configuredEffect),
                        _onlyInteractWithEdges(configuredEffect),
                      ],
                    )
                  : Text(
                      'Physics',
                      style: TextStyle(
                        decoration: _physicsOptionsHovered ? TextDecoration.underline : TextDecoration.none,
                      ),
                    ),
            ),
          ),
        ),
      ),
      const Gap(8),
    ];
  }

  Widget _particlesPerEmitSection(_ConfiguredEffect configuredEffect) {
    final config = configuredEffect.effectConfiguration;
    final emissionProps = config.emissionProperties;
    return SingleValueSelection(
      value: emissionProps.particlesPerEmit.toDouble(),
      title: 'Particles per emit',
      onChanged: (value) {
        setState(() {
          if (config is PhysicsEffectConfiguration) {
            configuredEffect.effectConfiguration = config.copyWith(
              emissionProperties: emissionProps.copyWith(
                particlesPerEmit: value.round(),
              ),
            );
          } else {
            final detConfig = config as DeterministicEffectConfiguration;
            configuredEffect.effectConfiguration = detConfig.copyWith(
              emissionProperties: emissionProps.copyWith(
                particlesPerEmit: value.round(),
              ),
            );
          }
        });
      },
      min: 1,
      max: 100,
    );
  }

  Widget _particleCount(_ConfiguredEffect configuredEffect) {
    final config = configuredEffect.effectConfiguration;
    final emissionProps = config.emissionProperties;

    return SingleValueSelection(
      value: emissionProps.particleCount.toDouble(),
      title: 'Particle count',
      onChanged: (value) {
        setState(() {
          if (config is PhysicsEffectConfiguration) {
            configuredEffect.effectConfiguration = config.copyWith(
              emissionProperties: emissionProps.copyWith(
                particleCount: value.round(),
              ),
            );
          } else {
            final detConfig = config as DeterministicEffectConfiguration;
            configuredEffect.effectConfiguration = detConfig.copyWith(
              emissionProperties: emissionProps.copyWith(
                particleCount: value.round(),
              ),
            );
          }
        });
      },
      min: 0,
      max: 1000,
    );
  }

  Widget _particleCountStatus() {
    final currentConfiguredEffect = _currentConfiguredEffect;
    if (currentConfiguredEffect == null) return const SizedBox.shrink();

    final config = currentConfiguredEffect.effectConfiguration;
    final validation = _validateParticleCount(config);
    final maxLimit = config is PhysicsEffectConfiguration ? maxParticlesPhysics : maxParticlesDeterministic;
    final activeCount = _activeParticleCounts[config] ?? 0;
    final totalEmitted = _totalEmittedCounts[config] ?? 0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: validation != null ? Border.all(color: Theme.of(context).colorScheme.error) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (activeCount > 0 || totalEmitted > 0) ...[
              Text(
                'Active: $activeCount / $maxLimit',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (totalEmitted > 0) ...[
                const Gap(4),
                Text(
                  'Emitted: $totalEmitted',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ],
            ] else ...[
              Text(
                'Max: $maxLimit (${config is PhysicsEffectConfiguration ? "physics" : "deterministic"})',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ],
            if (validation != null) ...[
              const Gap(8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const Gap(6),
                    Flexible(
                      child: Text(
                        validation,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String? _validateParticleCount(EffectConfiguration config) {
    final maxLimit = config is PhysicsEffectConfiguration ? maxParticlesPhysics : maxParticlesDeterministic;

    // Only validate based on actual active particle count from debug data
    final activeCount = _activeParticleCounts[config] ?? 0;

    // Only show warning if we have actual data and it exceeds the limit
    if (activeCount > 0 && activeCount > maxLimit) {
      return 'Warning: $activeCount active particles (current frame) exceeds recommended limit of $maxLimit';
    }

    return null;
  }

  Widget _emitDurationSection(_ConfiguredEffect configuredEffect) {
    final config = configuredEffect.effectConfiguration;
    final emissionProps = config.emissionProperties;
    return SingleValueSelection(
      value: emissionProps.emitDuration.inMilliseconds.toDouble(),
      title: 'Emit duration',
      onChanged: (value) {
        setState(() {
          if (config is PhysicsEffectConfiguration) {
            configuredEffect.effectConfiguration = config.copyWith(
              emissionProperties: emissionProps.copyWith(
                emitDuration: Duration(milliseconds: value.round()),
              ),
            );
          } else {
            final detConfig = config as DeterministicEffectConfiguration;
            configuredEffect.effectConfiguration = detConfig.copyWith(
              emissionProperties: emissionProps.copyWith(
                emitDuration: Duration(milliseconds: value.round()),
              ),
            );
          }
        });
      },
      precision: 4,
      min: 100,
      max: 5000,
    );
  }

  Widget _animationDurationSection(_ConfiguredEffect configuredEffect) {
    final config = configuredEffect.effectConfiguration;
    final emissionProps = config.emissionProperties;
    return RangeSelection(
      initialMin: emissionProps.particleLifespan.min.inMilliseconds.toDouble(),
      initialMax: emissionProps.particleLifespan.max.inMilliseconds.toDouble(),
      min: 100,
      max: 10000,
      divisions: 990,
      title: 'Particle effect duration',
      onChanged: (values) {
        setState(() {
          final particleLifespan = DurationRange.between(
            Duration(milliseconds: values.start.round()),
            Duration(milliseconds: values.end.round()),
          );
          if (config is PhysicsEffectConfiguration) {
            configuredEffect.effectConfiguration = config.copyWith(
              emissionProperties: emissionProps.copyWith(
                particleLifespan: particleLifespan,
              ),
            );
          } else {
            final detConfig = config as DeterministicEffectConfiguration;
            configuredEffect.effectConfiguration = detConfig.copyWith(
              emissionProperties: emissionProps.copyWith(
                particleLifespan: particleLifespan,
              ),
            );
          }
        });
      },
    );
  }

  Widget _gravityDxSection(_ConfiguredEffect configuredEffect) {
    final relativisticEffectConfiguration = configuredEffect.effectConfiguration as PhysicsEffectConfiguration;
    return SingleValueSelection(
      value: relativisticEffectConfiguration.gravity.dx,
      min: -20,
      max: 20,
      title: 'Gravity dx',
      onChanged: (value) {
        setState(() {
          configuredEffect.effectConfiguration = relativisticEffectConfiguration.copyWith(
            physicsProperties: relativisticEffectConfiguration.physicsProperties.copyWith(
              gravity: Gravity(value, relativisticEffectConfiguration.gravity.dy),
            ),
          );
        });
      },
    );
  }

  Widget _gravityDySection(_ConfiguredEffect configuredEffect) {
    final relativisticEffectConfiguration = configuredEffect.effectConfiguration as PhysicsEffectConfiguration;
    return SingleValueSelection(
      value: relativisticEffectConfiguration.gravity.dy,
      min: -20,
      max: 20,
      title: 'Gravity dy',
      onChanged: (value) {
        setState(() {
          configuredEffect.effectConfiguration = relativisticEffectConfiguration.copyWith(
            physicsProperties: relativisticEffectConfiguration.physicsProperties.copyWith(
              gravity: Gravity(relativisticEffectConfiguration.gravity.dx, value),
            ),
          );
        });
      },
    );
  }

  Widget _friction(_ConfiguredEffect configuredEffect) {
    final relativisticEffectConfiguration = configuredEffect.effectConfiguration as PhysicsEffectConfiguration;
    return RangeSelection(
      initialMin: relativisticEffectConfiguration.minFriction,
      initialMax: relativisticEffectConfiguration.maxFriction,
      min: Friction.ice,
      max: Friction.ductTape,
      title: 'Friction',
      onChanged: (values) {
        setState(() {
          configuredEffect.effectConfiguration = relativisticEffectConfiguration.copyWith(
            physicsProperties: relativisticEffectConfiguration.physicsProperties.copyWith(
              friction: NumRange.between(Friction(values.start), Friction(values.end)),
            ),
          );
        });
      },
    );
  }

  Widget _density(_ConfiguredEffect configuredEffect) {
    final relativisticEffectConfiguration = configuredEffect.effectConfiguration as PhysicsEffectConfiguration;
    return RangeSelection(
      initialMin: relativisticEffectConfiguration.minDensity,
      initialMax: relativisticEffectConfiguration.maxDensity,
      min: 0.05,
      max: 100,
      title: 'Density',
      onChanged: (values) {
        setState(() {
          configuredEffect.effectConfiguration = relativisticEffectConfiguration.copyWith(
            physicsProperties: relativisticEffectConfiguration.physicsProperties.copyWith(
              density: NumRange.between(Density(values.start), Density(values.end)),
            ),
          );
        });
      },
    );
  }

  Widget _restitution(_ConfiguredEffect configuredEffect) {
    final relativisticEffectConfiguration = configuredEffect.effectConfiguration as PhysicsEffectConfiguration;
    return RangeSelection(
      initialMin: relativisticEffectConfiguration.minRestitution,
      initialMax: relativisticEffectConfiguration.maxRestitution,
      min: Restitution.noBounce,
      max: Restitution.flubber,
      title: 'Restitution',
      onChanged: (values) {
        setState(() {
          configuredEffect.effectConfiguration = relativisticEffectConfiguration.copyWith(
            physicsProperties: relativisticEffectConfiguration.physicsProperties.copyWith(
              restitution: NumRange.between(Restitution(values.start), Restitution(values.end)),
            ),
          );
        });
      },
    );
  }

  Widget _velocity(_ConfiguredEffect configuredEffect) {
    final relativisticEffectConfiguration = configuredEffect.effectConfiguration as PhysicsEffectConfiguration;
    return RangeSelection(
      initialMin: relativisticEffectConfiguration.minVelocity,
      initialMax: relativisticEffectConfiguration.maxVelocity,
      min: Velocity.stationary,
      max: Velocity.car,
      title: 'Velocity',
      onChanged: (values) {
        setState(() {
          configuredEffect.effectConfiguration = relativisticEffectConfiguration.copyWith(
            physicsProperties: relativisticEffectConfiguration.physicsProperties.copyWith(
              velocity: NumRange.between(Velocity(values.start), Velocity(values.end)),
            ),
          );
        });
      },
      divisions: 1000,
      precision: 3,
    );
  }

  Widget _particleDistanceSection(_ConfiguredEffect configuredEffect) {
    final deterministicEffectConfiguration = configuredEffect.effectConfiguration as DeterministicEffectConfiguration;
    final detProps = deterministicEffectConfiguration.deterministicProperties;
    return RangeSelection(
      initialMin: detProps.distance.min,
      initialMax: detProps.distance.max,
      min: 100,
      max: 2000,
      title: 'Particle distance',
      onChanged: (values) {
        setState(() {
          configuredEffect.effectConfiguration = deterministicEffectConfiguration.copyWith(
            deterministicProperties: detProps.copyWith(
              distance: NumRange.between(values.start, values.end),
            ),
          );
        });
      },
    );
  }

  Widget _particleFadeinProgressSection(_ConfiguredEffect configuredEffect) {
    final config = configuredEffect.effectConfiguration;
    final visualProps = config is PhysicsEffectConfiguration
        ? config.visualProperties
        : (config as DeterministicEffectConfiguration).visualProperties;
    return RangeSelection(
      initialMin: visualProps.fadeInThreshold.min,
      initialMax: visualProps.fadeInThreshold.max,
      min: 0,
      max: 1,
      title: 'Particle fadein threshold',
      onChanged: (values) {
        setState(() {
          if (config is PhysicsEffectConfiguration) {
            configuredEffect.effectConfiguration = config.copyWith(
              visualProperties: visualProps.copyWith(
                fadeInThreshold: NumRange.between(values.start, values.end),
              ),
            );
          } else {
            final detConfig = config as DeterministicEffectConfiguration;
            configuredEffect.effectConfiguration = detConfig.copyWith(
              visualProperties: visualProps.copyWith(
                fadeInThreshold: NumRange.between(values.start, values.end),
              ),
            );
          }
        });
      },
    );
  }

  Widget _particleFadeoutProgressSection(_ConfiguredEffect configuredEffect) {
    final config = configuredEffect.effectConfiguration;
    final visualProps = config is PhysicsEffectConfiguration
        ? config.visualProperties
        : (config as DeterministicEffectConfiguration).visualProperties;
    return RangeSelection(
      initialMin: visualProps.fadeOutThreshold.min,
      initialMax: visualProps.fadeOutThreshold.max,
      min: 0,
      max: 1,
      title: 'Particle fadeout threshold',
      onChanged: (values) {
        setState(() {
          if (config is PhysicsEffectConfiguration) {
            configuredEffect.effectConfiguration = config.copyWith(
              visualProperties: visualProps.copyWith(
                fadeOutThreshold: NumRange.between(values.start, values.end),
              ),
            );
          } else {
            final detConfig = config as DeterministicEffectConfiguration;
            configuredEffect.effectConfiguration = detConfig.copyWith(
              visualProperties: visualProps.copyWith(
                fadeOutThreshold: NumRange.between(values.start, values.end),
              ),
            );
          }
        });
      },
    );
  }

  Widget _particleBeginScaleSection(_ConfiguredEffect configuredEffect) {
    final config = configuredEffect.effectConfiguration;
    final visualProps = config is PhysicsEffectConfiguration
        ? config.visualProperties
        : (config as DeterministicEffectConfiguration).visualProperties;
    return RangeSelection(
      initialMin: visualProps.beginScale.min,
      initialMax: visualProps.beginScale.max,
      min: 0,
      max: 10,
      title: 'Particle begin scale',
      onChanged: (values) {
        setState(() {
          if (config is PhysicsEffectConfiguration) {
            configuredEffect.effectConfiguration = config.copyWith(
              visualProperties: visualProps.copyWith(
                beginScale: NumRange.between(values.start, values.end),
              ),
            );
          } else {
            final detConfig = config as DeterministicEffectConfiguration;
            configuredEffect.effectConfiguration = detConfig.copyWith(
              visualProperties: visualProps.copyWith(
                beginScale: NumRange.between(values.start, values.end),
              ),
            );
          }
        });
      },
    );
  }

  Widget _particleEndScaleSection(_ConfiguredEffect configuredEffect) {
    final config = configuredEffect.effectConfiguration;
    final visualProps = config is PhysicsEffectConfiguration
        ? config.visualProperties
        : (config as DeterministicEffectConfiguration).visualProperties;
    return RangeSelection(
      initialMin: visualProps.endScale.min,
      initialMax: visualProps.endScale.max,
      min: -1,
      max: 10,
      title: 'Particle end scale',
      onChanged: (values) {
        setState(() {
          if (config is PhysicsEffectConfiguration) {
            configuredEffect.effectConfiguration = config.copyWith(
              visualProperties: visualProps.copyWith(
                endScale: NumRange.between(values.start, values.end),
              ),
            );
          } else {
            final detConfig = config as DeterministicEffectConfiguration;
            configuredEffect.effectConfiguration = detConfig.copyWith(
              visualProperties: visualProps.copyWith(
                endScale: NumRange.between(values.start, values.end),
              ),
            );
          }
        });
      },
    );
  }

  Widget _originDxSection(_ConfiguredEffect configuredEffect) {
    final config = configuredEffect.effectConfiguration;
    final emissionProps = config.emissionProperties;
    return SingleValueSelection(
      value: emissionProps.origin.dx,
      min: 0,
      max: 1,
      title: 'Origin dx',
      onChanged: (value) {
        setState(() {
          if (config is PhysicsEffectConfiguration) {
            configuredEffect.effectConfiguration = config.copyWith(
              emissionProperties: emissionProps.copyWith(
                origin: Offset(value, emissionProps.origin.dy),
              ),
            );
          } else {
            final detConfig = config as DeterministicEffectConfiguration;
            configuredEffect.effectConfiguration = detConfig.copyWith(
              emissionProperties: emissionProps.copyWith(
                origin: Offset(value, emissionProps.origin.dy),
              ),
            );
          }
        });
      },
    );
  }

  Widget _originDySection(_ConfiguredEffect configuredEffect) {
    final config = configuredEffect.effectConfiguration;
    final emissionProps = config.emissionProperties;
    return SingleValueSelection(
      value: emissionProps.origin.dy,
      min: 0,
      max: 1,
      title: 'Origin dy',
      onChanged: (value) {
        setState(() {
          if (config is PhysicsEffectConfiguration) {
            configuredEffect.effectConfiguration = config.copyWith(
              emissionProperties: emissionProps.copyWith(
                origin: Offset(emissionProps.origin.dx, value),
              ),
            );
          } else {
            final detConfig = config as DeterministicEffectConfiguration;
            configuredEffect.effectConfiguration = detConfig.copyWith(
              emissionProperties: emissionProps.copyWith(
                origin: Offset(emissionProps.origin.dx, value),
              ),
            );
          }
        });
      },
    );
  }

  Widget _offsetOriginDxSection(_ConfiguredEffect configuredEffect) {
    final config = configuredEffect.effectConfiguration;
    final emissionProps = config.emissionProperties;
    return RangeSelection(
      initialMin: emissionProps.minOriginOffset.dx,
      initialMax: emissionProps.maxOriginOffset.dx,
      min: 0,
      max: 1,
      title: 'Offset origin dx',
      onChanged: (values) {
        setState(() {
          if (config is PhysicsEffectConfiguration) {
            configuredEffect.effectConfiguration = config.copyWith(
              emissionProperties: emissionProps.copyWith(
                minOriginOffset: Offset(values.start, emissionProps.minOriginOffset.dy),
                maxOriginOffset: Offset(values.end, emissionProps.maxOriginOffset.dy),
              ),
            );
          } else {
            final detConfig = config as DeterministicEffectConfiguration;
            configuredEffect.effectConfiguration = detConfig.copyWith(
              emissionProperties: emissionProps.copyWith(
                minOriginOffset: Offset(values.start, emissionProps.minOriginOffset.dy),
                maxOriginOffset: Offset(values.end, emissionProps.maxOriginOffset.dy),
              ),
            );
          }
        });
      },
    );
  }

  Widget _offsetOriginDySection(_ConfiguredEffect configuredEffect) {
    final config = configuredEffect.effectConfiguration;
    final emissionProps = config.emissionProperties;
    return RangeSelection(
      initialMin: emissionProps.minOriginOffset.dy,
      initialMax: emissionProps.maxOriginOffset.dy,
      min: 0,
      max: 1,
      title: 'Offset origin dy',
      onChanged: (values) {
        setState(() {
          if (config is PhysicsEffectConfiguration) {
            configuredEffect.effectConfiguration = config.copyWith(
              emissionProperties: emissionProps.copyWith(
                minOriginOffset: Offset(emissionProps.minOriginOffset.dx, values.start),
                maxOriginOffset: Offset(emissionProps.maxOriginOffset.dx, values.end),
              ),
            );
          } else {
            final detConfig = config as DeterministicEffectConfiguration;
            configuredEffect.effectConfiguration = detConfig.copyWith(
              emissionProperties: emissionProps.copyWith(
                minOriginOffset: Offset(emissionProps.minOriginOffset.dx, values.start),
                maxOriginOffset: Offset(emissionProps.maxOriginOffset.dx, values.end),
              ),
            );
          }
        });
      },
    );
  }

  Widget _particleAngleSection(_ConfiguredEffect configuredEffect) {
    final config = configuredEffect.effectConfiguration;
    if (config is PhysicsEffectConfiguration) {
      final physicsProps = config.physicsProperties;
      return RangeSelection(
        initialMin: physicsProps.angle.min,
        initialMax: physicsProps.angle.max,
        min: -180,
        max: 180,
        divisions: 360,
        title: 'Particle angle',
        onChanged: (values) {
          setState(() {
            configuredEffect.effectConfiguration = config.copyWith(
              physicsProperties: physicsProps.copyWith(
                angle: NumRange.between(values.start, values.end),
              ),
            );
          });
        },
        precision: 3,
      );
    } else {
      final detConfig = config as DeterministicEffectConfiguration;
      final detProps = detConfig.deterministicProperties;
      return RangeSelection(
        initialMin: detProps.angle.min,
        initialMax: detProps.angle.max,
        min: -180,
        max: 180,
        divisions: 360,
        title: 'Particle angle',
        onChanged: (values) {
          setState(() {
            configuredEffect.effectConfiguration = detConfig.copyWith(
              deterministicProperties: detProps.copyWith(
                angle: NumRange.between(values.start, values.end),
              ),
            );
          });
        },
        precision: 3,
      );
    }
  }

  Widget _trailProgressSection(_ConfiguredEffect configuredEffect) {
    final config = configuredEffect.effectConfiguration;
    final layerProps = config is PhysicsEffectConfiguration
        ? config.layerProperties
        : (config as DeterministicEffectConfiguration).layerProperties;
    return SingleValueSelection(
      value: layerProps.trail.trailProgress,
      title: 'Trail Progress',
      onChanged: (value) {
        setState(() {
          final trailWidth = layerProps.trail is NoTrail ? 0.0 : (layerProps.trail as StraightTrail).trailWidth;
          if (config is PhysicsEffectConfiguration) {
            configuredEffect.effectConfiguration = config.copyWith(
              layerProperties: layerProps.copyWith(
                trail: StraightTrail(trailProgress: value, trailWidth: trailWidth),
              ),
            );
          } else {
            final detConfig = config as DeterministicEffectConfiguration;
            configuredEffect.effectConfiguration = detConfig.copyWith(
              layerProperties: layerProps.copyWith(
                trail: StraightTrail(trailProgress: value, trailWidth: trailWidth),
              ),
            );
          }
        });
      },
      precision: 3,
      min: 0,
      max: 1,
    );
  }

  Widget _trailWidthSection(_ConfiguredEffect configuredEffect) {
    final config = configuredEffect.effectConfiguration;
    final layerProps = config is PhysicsEffectConfiguration
        ? config.layerProperties
        : (config as DeterministicEffectConfiguration).layerProperties;
    final trailWidth = layerProps.trail is NoTrail ? 0.0 : (layerProps.trail as StraightTrail).trailWidth;
    return SingleValueSelection(
      value: trailWidth,
      title: 'Trail Width',
      onChanged: (value) {
        setState(() {
          if (config is PhysicsEffectConfiguration) {
            configuredEffect.effectConfiguration = config.copyWith(
              layerProperties: layerProps.copyWith(
                trail: StraightTrail(
                  trailProgress: layerProps.trail.trailProgress,
                  trailWidth: value,
                ),
              ),
            );
          } else {
            final detConfig = config as DeterministicEffectConfiguration;
            configuredEffect.effectConfiguration = detConfig.copyWith(
              layerProperties: layerProps.copyWith(
                trail: StraightTrail(
                  trailProgress: layerProps.trail.trailProgress,
                  trailWidth: value,
                ),
              ),
            );
          }
        });
      },
      precision: 3,
      min: 0,
      max: 10,
    );
  }

  Widget _colorSelection(_ConfiguredEffect configuredEffect) {
    final particleColor = _currentConfiguredEffect?.effectConfiguration.particleConfiguration.color;
    return ColorSelection(
      existingColors: switch (particleColor) {
        null => [],
        SingleParticleColor(color: final color) => [color],
        LinearInterpolationParticleColor(colors: final colors) => colors,
      },
      onChanged: (color) {
        setState(() {
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            particleConfiguration: configuredEffect.effectConfiguration.particleConfiguration.copyWith(color: color),
          );
        });
      },
    );
  }

  Widget _sizeSelection(_ConfiguredEffect configuredEffect) {
    return SingleValueSelection(
      value: configuredEffect.effectConfiguration.particleConfiguration.size.width,
      title: 'Size',
      onChanged: (value) {
        setState(() {
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            particleConfiguration:
                configuredEffect.effectConfiguration.particleConfiguration.copyWith(size: Size.square(value)),
          );
        });
      },
      precision: 0,
      min: 1,
      max: 100,
    );
  }

  @override
  void dispose() {
    _debugDataSubscription?.cancel();
    _activeParticleCounts.clear();
    _totalEmittedCounts.clear();
    _randomnessScrollController.dispose();
    super.dispose();
  }

  Widget _onlyInteractWithEdges(_ConfiguredEffect configuredEffect) {
    final effectConfiguration = configuredEffect.effectConfiguration as PhysicsEffectConfiguration;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: effectConfiguration.onlyInteractWithEdges,
          onChanged: (value) {
            setState(() {
              final physicsProps = effectConfiguration.physicsProperties;
              configuredEffect.effectConfiguration = effectConfiguration.copyWith(
                physicsProperties: physicsProps.copyWith(
                  onlyInteractWithEdges: value ?? false,
                ),
              );
            });
          },
        ),
        const Gap(4),
        Text('Only interact with edges', style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }

  /// Checks if any of the configured effects is a rain effect.
  bool _hasRainEffect() {
    return _configuredEffects.any(
      (effect) => effect.effectName == 'Rain' && effect.effectConfiguration is PhysicsEffectConfiguration,
    );
  }
}

class _ConfiguredEffect {
  _ConfiguredEffect({required this.effectName, required this.effectConfiguration});

  final String effectName;
  EffectConfiguration effectConfiguration;
}
