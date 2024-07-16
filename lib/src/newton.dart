/// The `newton_particles` library provides a highly configurable particle emitter to create
/// captivating animations, such as rain, smoke, or explosions, in Flutter apps.
///
/// To use the `newton` library, import it in your Dart code and add a `Newton` widget
/// to your widget tree. The `Newton` widget allows you to add and manage different particle
/// effects by providing a list of `Effect` instances. It handles the animation and rendering
/// of the active particle effects on a custom canvas.
library newton_particles;

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/newton_painter.dart';
import 'package:newton_particles/src/utils/bundle_extensions.dart';

/// The `Newton` widget is the entry point for creating captivating particle animations.
///
/// Use the `Newton` widget to add and manage different particle effects like rain, smoke,
/// or explosions in your Flutter app. Pass a list of `Effect` instances to the `activeEffects`
/// parameter to create the desired particle animations. The `Newton` widget handles the animation
/// and rendering of the active particle effects on a custom canvas.
class Newton extends StatefulWidget {
  /// The list of active particle effects to be rendered.
  final List<Effect> activeEffects;

  /// The blend mode to be used when drawing the particle effects on the canvas.
  /// defaults to `BlendMode.dstIn`.
  /// if you use Particle with ImageShader, set it to `BlendMode.srcIn` is better, such as emoji.
  final BlendMode blendMode;

  final Widget? child;

  /// Callback called when effect state has changed. See [EffectState].
  final void Function(Effect, EffectState)? onEffectStateChanged;

  const Newton({
    this.activeEffects = const [],
    this.child,
    this.onEffectStateChanged,
    this.blendMode = BlendMode.dstIn,
    super.key,
  });

  @override
  State<Newton> createState() => NewtonState();
}

/// The `NewtonState` class represents the state for the `Newton` widget.
///
/// The `NewtonState` class extends `State` and implements `SingleTickerProviderStateMixin`,
/// allowing it to create a ticker for handling animations. It manages the active particle effects
/// and handles their animation updates. Additionally, it uses a `CustomPainter` to render the
/// particle effects on a custom canvas.
class NewtonState extends State<Newton> with SingleTickerProviderStateMixin {
  static const _shapeSpriteSheetPath = "packages/newton_particles/assets/images/newton.png";
  late Ticker _ticker;
  int _lastElapsedMillis = 0;
  // final List<Effect> _activeEffects = List.empty(growable: true);
  final List<Effect> _pendingActiveEffects = List.empty(growable: true);
  late Future<ui.Image> _shapeSpriteSheet;

  final EffectManager _backEffectManager = EffectManager();
  final EffectManager _frontEffectManager = EffectManager();

  @override
  void initState() {
    super.initState();
    _shapeSpriteSheet = rootBundle.loadImage(_shapeSpriteSheetPath);
    _setupEffectsFromWidget();
    _ticker = createTicker(_onFrameUpdate);
    _ticker.start();
  }

  void _onFrameUpdate(elapsed) {
    _cleanDeadEffects();
    _updateActiveEffects(elapsed);
  }

  void _cleanDeadEffects() {
    _backEffectManager.cleanDeadEffects();
    _frontEffectManager.cleanDeadEffects();
  }

  void _updateActiveEffects(Duration elapsed) {
    if (_pendingActiveEffects.isNotEmpty) {
      _backEffectManager.addAll(_pendingActiveEffects.where(_isBackgroundEffect));
      _frontEffectManager.addAll(_pendingActiveEffects.where(_isForegroundEffect));
      _pendingActiveEffects.clear();
    }
    if (_backEffectManager.effects.isNotEmpty) {
      for (var element in _backEffectManager.effects) {
        element.forward(elapsed.inMilliseconds - _lastElapsedMillis);
      }
      _lastElapsedMillis = elapsed.inMilliseconds;
    }

    if (_frontEffectManager.effects.isNotEmpty) {
      for (var element in _frontEffectManager.effects) {
        element.forward(elapsed.inMilliseconds - _lastElapsedMillis);
      }

      _lastElapsedMillis = elapsed.inMilliseconds;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _shapeSpriteSheet,
        builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
          if (snapshot.hasData) {
            return RepaintBoundary(
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                for (var effect in _backEffectManager.effects) {
                  effect.surfaceSize = constraints.biggest;
                }

                for (var effect in _frontEffectManager.effects) {
                  effect.surfaceSize = constraints.biggest;
                }

                return CustomPaint(
                  willChange: true,
                  size: constraints.biggest,
                  painter: NewtonPainter(
                    shapesSpriteSheet: snapshot.data!,
                    effectsManager: _backEffectManager,
                    blendMode: widget.blendMode,
                  ),
                  foregroundPainter: NewtonPainter(
                    shapesSpriteSheet: snapshot.data!,
                    effectsManager: _frontEffectManager,
                    blendMode: widget.blendMode,
                  ),
                  child: widget.child,
                );
              }),
            );
          } else {
            return widget.child ?? Container();
          }
        });
  }

  bool _isBackgroundEffect(effect) => !effect.foreground;

  bool _isForegroundEffect(effect) => effect.foreground;

  /// Adds a new particle effect to the list of active effects.
  ///
  /// The `addEffect` method allows you to dynamically add a new particle effect to the list
  /// of active effects. Simply provide an `Effect` instance representing the desired effect,
  /// and the `Newton` widget will render it on the canvas.
  addEffect(Effect effect) {
    if (effect.foreground) {
      _frontEffectManager.add(
        effect
          ..surfaceSize = MediaQuery.sizeOf(context)
          ..addedAtRuntime = true
          ..postEffectCallback = _onPostEffect
          ..stateChangeCallback = _onEffectStateChanged,
      );
    } else {
      _backEffectManager.add(
        effect
          ..surfaceSize = MediaQuery.sizeOf(context)
          ..addedAtRuntime = true
          ..postEffectCallback = _onPostEffect
          ..stateChangeCallback = _onEffectStateChanged,
      );
    }
  }

  /// Remove a effect from the list of active effects.
  ///
  /// The `removeEffect` method allows you to dynamically remove a particle effect from the list
  /// of active effects.
  removeEffect(Effect effect) {
    if (effect.foreground) {
      _frontEffectManager.effects.removeWhere((e) => e.rootEffect == effect);
    } else {
      _backEffectManager.effects.removeWhere((e) => e.rootEffect == effect);
    }
  }

  @override
  void dispose() {
    _ticker.stop(canceled: true);
    _ticker.dispose();
    super.dispose();
  }

  void clearEffects() {
    _backEffectManager.effects.removeWhere((effect) {
      effect.postEffectCallback = null;
      return true;
    });
    _frontEffectManager.effects.removeWhere((effect) {
      effect.postEffectCallback = null;
      return true;
    });
  }

  @override
  void didUpdateWidget(Newton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeEffects != oldWidget.activeEffects) {
      _pendingActiveEffects.removeWhere(_isEffectRemoved);
      _backEffectManager.effects.removeWhere(_isEffectRemoved);
      _frontEffectManager.effects.removeWhere(_isEffectRemoved);
      _setupEffectsFromWidget();
    }
  }

  bool _isEffectRemoved(Effect<AnimatedParticle> effect) {
    // Keep only pending effects that are still active even if it's a post effect
    return !widget.activeEffects.contains(effect.rootEffect) && !effect.addedAtRuntime;
  }

  void _setupEffectsFromWidget() {
    for (var element in widget.activeEffects) {
      if (element.foreground) {
        _frontEffectManager.add(element
          ..postEffectCallback = _onPostEffect
          ..stateChangeCallback = _onEffectStateChanged);
      } else {
        _backEffectManager.add(element
          ..postEffectCallback = _onPostEffect
          ..stateChangeCallback = _onEffectStateChanged);
      }
    } 
  }

  _onPostEffect(Effect<AnimatedParticle> effect) {
    _pendingActiveEffects.add(effect
      ..postEffectCallback = _onPostEffect
      ..stateChangeCallback = _onEffectStateChanged);
  }

  _onEffectStateChanged(Effect effect, EffectState state) {
    widget.onEffectStateChanged?.call(effect, state);
  }
}
