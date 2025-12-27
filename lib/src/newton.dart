import 'dart:async';
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/effects/relativistic/forge/forge_newton_world.dart';
import 'package:newton_particles/src/newton_painter.dart';
import 'package:newton_particles/src/utils/bundle_extensions.dart';

/// The `Newton` widget serves as the primary interface for creating particle animations in your Flutter app.
///
/// Use the `Newton` widget to add and manage particle effects such as rain, smoke, or explosions.
/// Provide a list of `EffectConfiguration` instances through the `effectConfigurations` parameter to define
/// the desired particle effects. The `Newton` widget manages the lifecycle, animation, and rendering of these effects
/// on a custom canvas.
class Newton extends StatefulWidget {
  /// Constructs a [Newton] widget with the specified list of effect configurations.
  ///
  /// - [effectConfigurations]: A list of `EffectConfiguration` instances representing the particle effects
  ///   to be rendered.
  /// - [child]: An optional widget to be displayed behind or in front of the particle effects.
  /// - [onEffectStateChanged]: A callback invoked when an effect's state changes.
  const Newton({
    this.effectConfigurations = const [],
    this.child,
    this.onEffectStateChanged,
    super.key,
  });

  /// A list of effect configurations that define the particle effects to be rendered.
  final List<EffectConfiguration> effectConfigurations;

  /// An optional child widget that can be displayed alongside the particle effects.
  final Widget? child;

  /// A callback that is triggered when the state of an effect changes. See [EffectState] for possible states.
  final void Function(Effect, EffectState)? onEffectStateChanged;

  @override
  State<Newton> createState() => NewtonState();

  /// Provides access to the [NewtonState] within the current context.
  static NewtonState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_NewtonScope>()!;
    return scope._newtonState;
  }

  /// Attempts to retrieve the [NewtonState] from the current context, returning `null` if unavailable.
  static NewtonState? maybeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_NewtonScope>();
    return scope?._newtonState;
  }
}

/// The `NewtonState` is managing active effects and let you add/remove effects at runtime.
class NewtonState extends State<Newton> with SingleTickerProviderStateMixin {
  static const _shapeSpriteSheetPath = 'packages/newton_particles/assets/images/newton.png';
  late Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  final _pendingActiveEffects = List<Effect>.empty(growable: true);
  late Future<ui.Image> _shapeSpriteSheet;

  final _effects = <Effect>[];
  final _effectsElapsedTimeNotifier = _ElapsedTimeNotifier();
  final _debugDataController = StreamController<NewtonDebugData>.broadcast();
  final _colliders = <String, RRect>{};
  final GlobalKey _customPaintKey = GlobalKey();
  Size? _previousSize;

  /// Stream of debug data providing real-time information about particle effects.
  ///
  /// This stream emits [NewtonDebugData] objects periodically (typically every frame)
  /// containing information about active particles, effect states, and performance metrics.
  ///
  /// Example usage:
  /// ```dart
  /// final newtonState = Newton.of(context);
  /// newtonState.debugDataStream.listen((debugData) {
  ///   print('Total active particles: ${debugData.totalActiveParticles}');
  ///   for (final effectData in debugData.effectData) {
  ///     print('Effect: ${effectData.activeParticleCount} particles');
  ///   }
  /// });
  /// ```
  Stream<NewtonDebugData> get debugDataStream => _debugDataController.stream;

  @override
  void initState() {
    super.initState();
    _shapeSpriteSheet = rootBundle.loadImage(_shapeSpriteSheetPath);
    _setupEffectsFromWidget();
    _ticker = createTicker(_onFrameUpdate);
    _ticker.start().ignore();
  }

  void _onFrameUpdate(Duration elapsed) {
    _cleanDeadEffects();
    _updateActiveEffects(elapsed);
  }

  void _cleanDeadEffects() {
    _effects.removeWhere((effect) => effect.state == EffectState.killed);
  }

  void _updateActiveEffects(Duration elapsed) {
    if (_pendingActiveEffects.isNotEmpty) {
      _effects.addAll(_pendingActiveEffects);
      _pendingActiveEffects.clear();
    }
    if (_effects.isNotEmpty) {
      _effectsElapsedTimeNotifier.value = elapsed - _lastElapsed;
      _emitDebugData();
    }
    _lastElapsed = elapsed;
  }

  void _emitDebugData() {
    if (!_debugDataController.isClosed && _debugDataController.hasListener) {
      final effectData = _effects.map((effect) {
        return EffectDebugData(
          configuration: effect.effectConfiguration,
          activeParticleCount: effect.activeParticles.length,
          totalEmittedCount: effect.totalEmittedCount,
          state: effect.state,
        );
      }).toList();

      final totalActiveParticles = effectData.fold<int>(
        0,
        (sum, data) => sum + data.activeParticleCount,
      );

      final debugData = NewtonDebugData(
        effectData: effectData,
        totalActiveParticles: totalActiveParticles,
        totalEffects: _effects.length,
      );

      _debugDataController.add(debugData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _NewtonScope(
      newtonState: this,
      child: NotificationListener<NewtonCollisionNotification>(
        onNotification: (notification) {
          setState(() {
            if (notification.isRemoving) {
              _colliders.remove(notification.id);
            } else {
              // Always remove the old collider first to ensure cleanup
              _colliders.remove(notification.id);

              // Convert from global screen coordinates to canvas coordinates
              final canvasRect = _convertRectToCanvas(notification.rect);
              // Only add if the rect is valid (has positive size and reasonable coordinates)
              if (canvasRect.width > 0 && canvasRect.height > 0) {
                _colliders[notification.id] = notification.borderRadius.toRRect(canvasRect);
              }
              // If conversion failed or rect is invalid, the collider is already removed above
            }
          });
          // Sync colliders to physics effects - this replaces ALL colliders with the current map
          _syncCollidersToEffects();
          return true;
        },
        child: FutureBuilder(
          future: _shapeSpriteSheet,
          builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
            if (snapshot.hasData) {
              return RepaintBoundary(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final currentSize = constraints.biggest;
                    // Update colliders and effects when size changes (e.g., screen resize)
                    if (_previousSize != null && _previousSize != currentSize) {
                      // Update surface size for all effects
                      for (final effect in _effects) {
                        effect.surfaceSize = currentSize;
                      }
                      // Update colliders after layout is complete
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _updateCollidersOnLayoutChange();
                      });
                    } else if (_previousSize == null) {
                      // First time - set initial surface size
                      for (final effect in _effects) {
                        effect.surfaceSize = currentSize;
                      }
                    }
                    _previousSize = currentSize;
                    return CustomPaint(
                      key: _customPaintKey,
                      willChange: _effects.isNotEmpty,
                      size: currentSize,
                      painter: NewtonPainter(
                        elapsedTimeNotifier: _effectsElapsedTimeNotifier,
                        effects: _effects,
                        shapesSpriteSheet: snapshot.data!,
                      ),
                      foregroundPainter: NewtonPainter(
                        elapsedTimeNotifier: _effectsElapsedTimeNotifier,
                        effects: _effects,
                        shapesSpriteSheet: snapshot.data!,
                        foreground: true,
                      ),
                      child: widget.child,
                    );
                  },
                ),
              );
            } else {
              return widget.child ?? Container();
            }
          },
        ),
      ),
    );
  }

  /// Adds a new particle effect to the list of active effects.
  ///
  /// This method allows you to dynamically add a new particle effect by providing an
  /// `EffectConfiguration` instance. The effect will be automatically rendered on the canvas.
  Effect<AnimatedParticle, EffectConfiguration> addEffect(EffectConfiguration effectConfiguration) {
    final effect = effectConfiguration.effect()
      ..addedAtRuntime = true
      ..postEffectCallback = _onPostEffect
      ..stateChangeCallback = _onEffectStateChanged;
    _effects.add(
      effect,
    );
    return effect;
  }

  /// Removes a specific effect from the list of active effects.
  ///
  /// The `removeEffect` method removes a particle effect identified by its instance from the active list.
  void removeEffect<T extends AnimatedParticle, R extends EffectConfiguration>(Effect<T, R> effect) {
    _effects.removeWhere((e) => e.rootEffect == effect);
  }

  /// Removes all effects that match a given effect configuration.
  ///
  /// This method removes all active particle effects that are configured with the specified `EffectConfiguration`.
  void removeEffectConfiguration<T extends EffectConfiguration>(T effectConfiguration) {
    return _effects.removeWhere(
      (e) => e.effectConfiguration == effectConfiguration || e.rootEffect?.effectConfiguration == effectConfiguration,
    );
  }

  @override
  void dispose() {
    _ticker
      ..stop(canceled: true)
      ..dispose();
    _debugDataController.close().ignore();
    super.dispose();
  }

  /// Clears all active particle effects from the widget.
  ///
  /// This method removes all currently active particle effects, effectively resetting the animation state of the `Newton` widget.
  void clearEffects() {
    _effects.removeWhere((effect) {
      effect.postEffectCallback = null;
      return true;
    });
  }

  @override
  void didUpdateWidget(Newton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if configurations have changed by comparing list contents deeply
    // This handles cases where copyWith creates new configuration objects
    // EffectConfiguration implements == operator, so ListEquality works correctly
    final configsChanged = !const ListEquality<EffectConfiguration>().equals(
      widget.effectConfigurations,
      oldWidget.effectConfigurations,
    );

    if (configsChanged) {
      _pendingActiveEffects.removeWhere(_isEffectRemoved);
      _effects.removeWhere(_isEffectRemoved);
      _setupEffectsFromWidget();
    }
  }

  bool _isEffectRemoved<T extends AnimatedParticle, R extends EffectConfiguration>(Effect<T, R> effect) {
    // Keep only pending effects that are still active, even if it's a post effect
    return !widget.effectConfigurations.contains(effect.effectConfiguration) && !effect.addedAtRuntime;
  }

  void _setupEffectsFromWidget() {
    for (final configuration in widget.effectConfigurations) {
      if (_effects.any((effect) => effect.effectConfiguration == configuration)) continue;
      final effect = configuration.effect()
        ..postEffectCallback = _onPostEffect
        ..stateChangeCallback = _onEffectStateChanged;
      _effects.add(effect);
    }
  }

  void _onPostEffect<T extends AnimatedParticle, R extends EffectConfiguration>(Effect<T, R> effect) {
    _pendingActiveEffects.add(
      effect
        ..postEffectCallback = _onPostEffect
        ..stateChangeCallback = _onEffectStateChanged,
    );
  }

  void _onEffectStateChanged<T extends AnimatedParticle, R extends EffectConfiguration>(
    Effect<T, R> effect,
    EffectState state,
  ) {
    widget.onEffectStateChanged?.call(effect, state);
  }

  /// Converts a rectangle from global screen coordinates to canvas coordinates.
  Rect _convertRectToCanvas(Rect globalRect) {
    final customPaintContext = _customPaintKey.currentContext;
    if (customPaintContext != null) {
      final renderObject = customPaintContext.findRenderObject();
      if (renderObject is RenderBox && renderObject.hasSize) {
        // Convert top-left and bottom-right corners
        final topLeft = renderObject.globalToLocal(globalRect.topLeft);
        final bottomRight = renderObject.globalToLocal(globalRect.bottomRight);
        final convertedRect = Rect.fromPoints(topLeft, bottomRight);
        // Validate the converted rect is reasonable (within bounds of the canvas)
        // If conversion produces invalid coordinates, return an empty rect which will be filtered out
        if (convertedRect.width > 0 &&
            convertedRect.height > 0 &&
            convertedRect.left >= -10000 &&
            convertedRect.top >= -10000 &&
            convertedRect.right <= renderObject.size.width + 10000 &&
            convertedRect.bottom <= renderObject.size.height + 10000) {
          return convertedRect;
        }
      }
    }
    // Return empty rect if conversion fails - this will cause the collider to be removed
    return Rect.zero;
  }

  /// Syncs colliders to all physics effects.
  void _syncCollidersToEffects() {
    // Create a fresh list from current colliders to ensure no stale references
    final collidersList = _colliders.values.toList();

    for (final effect in _effects) {
      if (effect is PhysicsEffect) {
        final world = effect.world;
        if (world is ForgeNewtonWorld) {
          // This completely replaces all colliders in the physics world
          world.setColliders(collidersList);
        }
      }
    }
  }

  /// Gets the current list of colliders.
  List<RRect> get colliders => _colliders.values.toList();

  /// Updates collider positions when layout changes (e.g., screen resize).
  /// This triggers all NewtonCollider widgets to re-report their positions.
  void _updateCollidersOnLayoutChange() {
    if (!mounted) return;

    // Trigger a rebuild to cause all NewtonCollider widgets to re-report
    // via their didChangeDependencies callbacks
    // This ensures colliders get fresh positions in the new coordinate space
    setState(() {
      // Empty setState just triggers a rebuild, which will cause
      // NewtonCollider widgets to re-report their positions
    });
  }
}

class _ElapsedTimeNotifier with ChangeNotifier implements ValueListenable<Duration> {
  Duration _duration = Duration.zero;

  @override
  Duration get value => _duration;

  set value(Duration value) {
    _duration = value;
    notifyListeners();
  }

  @override
  String toString() {
    return '_ElapsedTimeNotifier{_duration: $_duration}';
  }
}

class _NewtonScope extends InheritedWidget {
  const _NewtonScope({
    required super.child,
    required NewtonState newtonState,
  }) : _newtonState = newtonState;

  final NewtonState _newtonState;

  @override
  bool updateShouldNotify(_NewtonScope old) => _newtonState != old._newtonState;
}
