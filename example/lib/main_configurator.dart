import 'dart:async';

import 'package:example/available_effect.dart';
import 'package:example/color_selection.dart';
import 'package:example/range_selection.dart';
import 'package:example/single_value_selection.dart';
import 'package:example/theme.dart';
import 'package:flutter/material.dart';
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
  final _configuredEffects = <_ConfiguredEffect>[];
  AvailableEffect _selectedAnimation = AvailableEffect.scratch;

  bool _usePhysics = true;
  bool _randomnessOptionsOpened = false;
  bool _randomnessOptionsHovered = false;

  bool _emissionOptionsOpened = false;
  bool _emissionOptionsHovered = false;

  bool _particleOptionsOpened = false;
  bool _particleOptionsHovered = false;

  String _currentEffectName = '';

  _ConfiguredEffect? _currentConfiguredEffect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
                              errorText:
                                  _configuredEffects.map((effect) => effect.effectName).contains(_currentEffectName)
                                      ? 'Can’t have same effect name'
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
                              value: AvailableEffect.scratch.label,
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 16,
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setDialogState(() {
                                  _selectedAnimation = AvailableEffect.of(value!);
                                });
                              },
                              items: AvailableEffect.values.map<DropdownMenuItem<String>>((AvailableEffect value) {
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
                                          effectConfiguration:
                                              defaultEffectConfigurationsPerAnimation[_selectedAnimation]!,
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
      body: GestureDetector(
        onTap: () {
          setState(() {
            _emissionOptionsOpened = false;
            _particleOptionsOpened = false;
            _randomnessOptionsOpened = false;
          });
        },
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Newton(
                effectConfigurations: _configuredEffects.map((effect) => effect.effectConfiguration).toList(),
                onEffectStateChanged: (effect, state) => {},
              ),
              Positioned(
                left: 0,
                top: 0,
                child: _configurationSection(),
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
          const Gap(8),
          ..._emissionOptions(currentConfiguredEffect),
          ..._particleOptions(currentConfiguredEffect),
          ..._randomnessOptions(currentConfiguredEffect),
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
              border: Border.all(color: Colors.white.withOpacity(.4)),
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
              border: Border.all(color: Colors.white.withOpacity(.4)),
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
              border: Border.all(color: Colors.white.withOpacity(.4)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _randomnessOptionsOpened
                  ? Column(
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
                      ],
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

  Widget _particlesPerEmitSection(_ConfiguredEffect configuredEffect) {
    return SingleValueSelection(
      value: configuredEffect.effectConfiguration.particlesPerEmit.toDouble(),
      title: 'Particles per emit',
      onChanged: (value) {
        setState(() {
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            particlesPerEmit: value.round(),
          );
        });
      },
      min: 1,
      max: 100,
    );
  }

  Widget _particleCount(_ConfiguredEffect configuredEffect) {
    return SingleValueSelection(
      value: configuredEffect.effectConfiguration.particleCount.toDouble(),
      title: 'Particle count',
      onChanged: (value) {
        setState(() {
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            particleCount: value.round(),
          );
        });
      },
      min: 0,
      max: 1000,
    );
  }

  Widget _emitDurationSection(_ConfiguredEffect configuredEffect) {
    return SingleValueSelection(
      value: configuredEffect.effectConfiguration.emitDuration.inMilliseconds.toDouble(),
      title: 'Emit duration',
      onChanged: (value) {
        setState(() {
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            emitDuration: Duration(milliseconds: value.round()),
          );
        });
      },
      precision: 4,
      min: 100,
      max: 5000,
    );
  }

  Widget _animationDurationSection(_ConfiguredEffect configuredEffect) {
    return RangeSelection(
      initialMin: configuredEffect.effectConfiguration.minDuration.inMilliseconds.toDouble(),
      initialMax: configuredEffect.effectConfiguration.maxDuration.inMilliseconds.toDouble(),
      min: 100,
      max: 10000,
      divisions: 990,
      title: 'Particle effect duration',
      onChanged: (values) {
        setState(() {
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            minDuration: Duration(milliseconds: values.start.round()),
            maxDuration: Duration(milliseconds: values.end.round()),
          );
        });
      },
    );
  }

  Widget _particleDistanceSection(_ConfiguredEffect configuredEffect) {
    return RangeSelection(
      initialMin: (configuredEffect.effectConfiguration as DeterministicEffectConfiguration).minDistance,
      initialMax: (configuredEffect.effectConfiguration as DeterministicEffectConfiguration).maxDistance,
      min: 100,
      max: 2000,
      title: 'Particle distance',
      onChanged: (values) {
        setState(() {
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            minDistance: values.start,
            maxDistance: values.end,
          );
        });
      },
    );
  }

  Widget _particleFadeinProgressSection(_ConfiguredEffect configuredEffect) {
    return RangeSelection(
      initialMin: configuredEffect.effectConfiguration.minFadeInThreshold,
      initialMax: configuredEffect.effectConfiguration.maxFadeInThreshold,
      min: 0,
      max: 1,
      title: 'Particle fadein threshold',
      onChanged: (values) {
        setState(() {
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            minFadeInThreshold: values.start,
            maxFadeInThreshold: values.end,
          );
        });
      },
    );
  }

  Widget _particleFadeoutProgressSection(_ConfiguredEffect configuredEffect) {
    return RangeSelection(
      initialMin: configuredEffect.effectConfiguration.minFadeOutThreshold,
      initialMax: configuredEffect.effectConfiguration.maxFadeOutThreshold,
      min: 0,
      max: 1,
      title: 'Particle fadeout threshold',
      onChanged: (values) {
        setState(() {
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            minFadeOutThreshold: values.start,
            maxFadeOutThreshold: values.end,
          );
        });
      },
    );
  }

  Widget _particleBeginScaleSection(_ConfiguredEffect configuredEffect) {
    return RangeSelection(
      initialMin: configuredEffect.effectConfiguration.minBeginScale,
      initialMax: configuredEffect.effectConfiguration.maxBeginScale,
      min: 0,
      max: 10,
      title: 'Particle begin scale',
      onChanged: (values) {
        setState(() {
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            minBeginScale: values.start,
            maxBeginScale: values.end,
          );
        });
      },
    );
  }

  Widget _particleEndScaleSection(_ConfiguredEffect configuredEffect) {
    return RangeSelection(
      initialMin: configuredEffect.effectConfiguration.minEndScale,
      initialMax: configuredEffect.effectConfiguration.maxEndScale,
      min: -1,
      max: 10,
      title: 'Particle end scale',
      onChanged: (values) {
        setState(() {
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            minEndScale: values.start,
            maxEndScale: values.end,
          );
        });
      },
    );
  }

  Widget _originDxSection(_ConfiguredEffect configuredEffect) {
    return SingleValueSelection(
      value: configuredEffect.effectConfiguration.origin.dx,
      min: 0,
      max: 1,
      title: 'Origin dx',
      onChanged: (value) {
        setState(() {
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            origin: Offset(value, configuredEffect.effectConfiguration.origin.dy),
          );
        });
      },
    );
  }

  Widget _originDySection(_ConfiguredEffect configuredEffect) {
    return SingleValueSelection(
      value: configuredEffect.effectConfiguration.origin.dy,
      min: 0,
      max: 1,
      title: 'Origin dy',
      onChanged: (value) {
        setState(() {
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            origin: Offset(configuredEffect.effectConfiguration.origin.dx, value),
          );
        });
      },
    );
  }

  Widget _offsetOriginDxSection(_ConfiguredEffect configuredEffect) {
    return RangeSelection(
      initialMin: configuredEffect.effectConfiguration.minOriginOffset.dx,
      initialMax: configuredEffect.effectConfiguration.maxOriginOffset.dx,
      min: 0,
      max: 1,
      title: 'Offset origin dx',
      onChanged: (values) {
        setState(() {
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            minOriginOffset: Offset(values.start, configuredEffect.effectConfiguration.minOriginOffset.dy),
            maxOriginOffset: Offset(values.end, configuredEffect.effectConfiguration.maxOriginOffset.dy),
          );
        });
      },
    );
  }

  Widget _offsetOriginDySection(_ConfiguredEffect configuredEffect) {
    return RangeSelection(
      initialMin: configuredEffect.effectConfiguration.minOriginOffset.dy,
      initialMax: configuredEffect.effectConfiguration.maxOriginOffset.dy,
      min: 0,
      max: 1,
      title: 'Offset origin dy',
      onChanged: (values) {
        setState(() {
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            minOriginOffset: Offset(configuredEffect.effectConfiguration.minOriginOffset.dx, values.start),
            maxOriginOffset: Offset(configuredEffect.effectConfiguration.maxOriginOffset.dx, values.end),
          );
        });
      },
    );
  }

  Widget _particleAngleSection(_ConfiguredEffect configuredEffect) {
    return RangeSelection(
      initialMin: configuredEffect.effectConfiguration.minAngle,
      initialMax: configuredEffect.effectConfiguration.maxAngle,
      min: -180,
      max: 180,
      divisions: 360,
      title: 'Particle angle',
      onChanged: (values) {
        setState(() {
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            minAngle: values.start,
            maxAngle: values.end,
          );
        });
      },
      precision: 3,
    );
  }

  Widget _trailProgressSection(_ConfiguredEffect configuredEffect) {
    return SingleValueSelection(
      value: configuredEffect.effectConfiguration.trail.trailProgress,
      title: 'Trail Progress',
      onChanged: (value) {
        setState(() {
          final trailWidth = configuredEffect.effectConfiguration.trail is NoTrail
              ? 0.0
              : (configuredEffect.effectConfiguration.trail as StraightTrail).trailWidth;
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            trail: StraightTrail(trailProgress: value, trailWidth: trailWidth),
          );
        });
      },
      precision: 3,
      min: 0,
      max: 1,
    );
  }

  Widget _trailWidthSection(_ConfiguredEffect configuredEffect) {
    final trailWidth = configuredEffect.effectConfiguration.trail is NoTrail
        ? 0.0
        : (configuredEffect.effectConfiguration.trail as StraightTrail).trailWidth;
    return SingleValueSelection(
      value: trailWidth,
      title: 'Trail Width',
      onChanged: (value) {
        setState(() {
          configuredEffect.effectConfiguration = configuredEffect.effectConfiguration.copyWith(
            trail: StraightTrail(
              trailProgress: configuredEffect.effectConfiguration.trail.trailProgress,
              trailWidth: value,
            ),
          );
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
}

class _ConfiguredEffect {
  _ConfiguredEffect({required this.effectName, required this.effectConfiguration});

  final String effectName;
  EffectConfiguration effectConfiguration;
}
