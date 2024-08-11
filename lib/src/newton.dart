/// The `newton_particles` library provides a highly configurable particle emitter to create
/// captivating animations, such as rain, smoke, or explosions, in Flutter apps.
///
/// To use the `newton` library, import it in your Dart code and add a `Newton` widget
/// to your widget tree. The `Newton` widget allows you to add and manage different particle
/// effects by providing a list of `Effect` instances. It handles the animation and rendering
/// of the active particle effects on a custom canvas.
library newton_particles;

import 'dart:ui' as ui;

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
  /// Constructs a [Newton] widget with the specified list of active effects.
  ///
  /// - [activeEffects]: A list of `Effect` instances representing the particle
  ///   effects to be rendered.
  /// - [child]: An optional widget to be displayed behind or in front of the particle effects.
  /// - [onEffectStateChanged]: A callback invoked when an effect's state changes.
  const Newton({
    this.activeEffects = const [],
    this.child,
    this.onEffectStateChanged,
    this.blendMode = BlendMode.dstIn,
    super.key,
  });

  /// The blend mode to be used when drawing the particle effects on the canvas.
  /// defaults to `BlendMode.dstIn`.
  /// if you use Particle with ImageShader, set it to `BlendMode.srcIn` is better, such as emoji.
  final BlendMode blendMode;

  /// The list of active particle effects to be rendered.
  final List<Effect> activeEffects;

  /// An optional child widget to be displayed with the particle effects.
  final Widget? child;

  /// Callback called when effect state has changed. See [EffectState].
  final void Function(Effect, EffectState)? onEffectStateChanged;

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
  static const _shapeSpriteSheetPath = 'packages/newton_particles/assets/images/newton.png';
  late Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  final List<Effect> _pendingActiveEffects = List.empty(growable: true);
  late Future<ui.Image> _shapeSpriteSheet;

  final EffectsNotifier _backgroundEffectManager = EffectsNotifier();
  final EffectsNotifier _foregroundEffectManager = EffectsNotifier();

  @override
  void initState() {
    super.initState();
    _shapeSpriteSheet = rootBundle.loadImage(_shapeSpriteSheetPath);
    _setupEffectsFromWidget();
    _ticker = createTicker(_onFrameUpdate);
    _ticker.start();
  }

  void _onFrameUpdate(Duration elapsed) {
    _cleanDeadEffects();
    _updateActiveEffects(elapsed);
  }

  void _cleanDeadEffects() {
    _backgroundEffectManager.cleanDeadEffects();
    _foregroundEffectManager.cleanDeadEffects();
  }

  void _updateActiveEffects(Duration elapsed) {
    if (_pendingActiveEffects.isNotEmpty) {
      _backgroundEffectManager.addAll(_pendingActiveEffects.where(_isBackgroundEffect));
      _foregroundEffectManager.addAll(_pendingActiveEffects.where(_isForegroundEffect));
      _pendingActiveEffects.clear();
    }
    for (final element in _backgroundEffectManager.effects) {
      element.forward(elapsed - _lastElapsed);
    }
    for (final element in _foregroundEffectManager.effects) {
      element.forward(elapsed - _lastElapsed);
    }
    _lastElapsed = elapsed;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _shapeSpriteSheet,
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        if (snapshot.hasData) {
          return RepaintBoundary(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return CustomPaint(
                  willChange:
                      _backgroundEffectManager.effects.isNotEmpty || _foregroundEffectManager.effects.isNotEmpty,
                  size: constraints.biggest,
                  painter: NewtonPainter(
                    blendMode: widget.blendMode,
                    effectsNotifier: _backgroundEffectManager,
                    shapesSpriteSheet: snapshot.data!,
                  ),
                  foregroundPainter: NewtonPainter(
                    blendMode: widget.blendMode,
                    effectsNotifier: _foregroundEffectManager,
                    shapesSpriteSheet: snapshot.data!,
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
    );
  }

  bool _isBackgroundEffect<T extends AnimatedParticle>(Effect<T> effect) => !effect.foreground;

  bool _isForegroundEffect<T extends AnimatedParticle>(Effect<T> effect) => effect.foreground;

  /// Adds a new particle effect to the list of active effects.
  ///
  /// The `addEffect` method allows you to dynamically add a new particle effect to the list
  /// of active effects. Simply provide an `Effect` instance representing the desired effect,
  /// and the `Newton` widget will render it on the canvas.
  void addEffect<T extends AnimatedParticle>(Effect<T> effect) {
    if (effect.foreground) {
      _foregroundEffectManager.add(
        effect
          ..surfaceSize = MediaQuery.sizeOf(context)
          ..addedAtRuntime = true
          ..postEffectCallback = _onPostEffect
          ..stateChangeCallback = _onEffectStateChanged,
      );
    } else {
      _backgroundEffectManager.add(
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
  void removeEffect<T extends AnimatedParticle>(Effect<T> effect) {
    if (effect.foreground) {
      _foregroundEffectManager.effects.removeWhere((e) => e.rootEffect == effect);
    } else {
      _backgroundEffectManager.effects.removeWhere((e) => e.rootEffect == effect);
    }
  }

  @override
  void dispose() {
    _ticker
      ..stop(canceled: true)
      ..dispose();
    super.dispose();
  }

  /// Clears all active particle effects from the widget.
  ///
  /// This method removes all currently active particle effects, effectively
  /// resetting the animation state of the `Newton` widget.
  void clearEffects() {
    _backgroundEffectManager.effects.removeWhere((effect) {
      effect.postEffectCallback = null;
      return true;
    });
    _foregroundEffectManager.effects.removeWhere((effect) {
      effect.postEffectCallback = null;
      return true;
    });
  }

  @override
  void didUpdateWidget(Newton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeEffects != oldWidget.activeEffects) {
      _pendingActiveEffects.removeWhere(_isEffectRemoved);
      _backgroundEffectManager.effects.removeWhere(_isEffectRemoved);
      _foregroundEffectManager.effects.removeWhere(_isEffectRemoved);
      _setupEffectsFromWidget();
    }
  }

  bool _isEffectRemoved<T extends AnimatedParticle>(Effect<T> effect) {
    // Keep only pending effects that are still active even if it's a post effect
    return !widget.activeEffects.contains(effect.rootEffect) && !effect.addedAtRuntime;
  }

  void _setupEffectsFromWidget() {
    for (final element in widget.activeEffects) {
      if (element.foreground) {
        _foregroundEffectManager.add(
          element
            ..postEffectCallback = _onPostEffect
            ..stateChangeCallback = _onEffectStateChanged,
        );
      } else {
        _backgroundEffectManager.add(
          element
            ..postEffectCallback = _onPostEffect
            ..stateChangeCallback = _onEffectStateChanged,
        );
      }
    }
  }

  void _onPostEffect<T extends AnimatedParticle>(Effect<T> effect) {
    _pendingActiveEffects.add(
      effect
        ..postEffectCallback = _onPostEffect
        ..stateChangeCallback = _onEffectStateChanged,
    );
  }

  void _onEffectStateChanged<T extends AnimatedParticle>(
    Effect<T> effect,
    EffectState state,
  ) {
    widget.onEffectStateChanged?.call(effect, state);
  }
}
