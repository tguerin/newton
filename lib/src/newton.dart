/// The `newton_particles` library provides a highly configurable particle emitter to create
/// captivating animations, such as rain, smoke, or explosions, in Flutter apps.
///
/// To use the `newton` library, import it in your Dart code and add a `Newton` widget
/// to your widget tree. The `Newton` widget allows you to add and manage different particle
/// effects by providing a list of `Effect` instances. It handles the animation and rendering
/// of the active particle effects on a custom canvas.
library newton_particles;

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
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
    this.effectConfigurations = const [],
    this.child,
    this.onEffectStateChanged,
    this.blendMode = BlendMode.dstIn,
    super.key,
  });

  /// The blend mode to be used when drawing the particle effects on the canvas.
  /// defaults to `BlendMode.dstIn`.
  /// if you use Particle with ImageShader, set it to `BlendMode.srcIn` is better, such as emoji.
  final BlendMode blendMode;

  /// The list of effect configurations to be rendered.
  final List<EffectConfiguration> effectConfigurations;

  /// An optional child widget to be displayed with the particle effects.
  final Widget? child;

  /// Callback called when effect state has changed. See [EffectState].
  final void Function(Effect, EffectState)? onEffectStateChanged;

  @override
  State<Newton> createState() => NewtonState();

  static NewtonState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_NewtonScope>()!;
    return scope._newtonState;
  }

  static NewtonState? maybeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_NewtonScope>();
    return scope?._newtonState;
  }
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
  var _lastElapsed = Duration.zero;
  final _pendingActiveEffects = List<Effect>.empty(growable: true);
  late Future<ui.Image> _shapeSpriteSheet;

  final _backgroundEffects = <Effect>[];
  final _backgroundElapsedTimeNotifier = _ElapsedTimeNotifier();
  final _foregroundEffects = <Effect>[];
  final _foregroundElapsedTimeNotifier = _ElapsedTimeNotifier();

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
    _backgroundEffects.removeWhere((effect) => effect.state == EffectState.killed);
    _foregroundEffects.removeWhere((effect) => effect.state == EffectState.killed);
  }

  void _updateActiveEffects(Duration elapsed) {
    if (_pendingActiveEffects.isNotEmpty) {
      _backgroundEffects.addAll(_pendingActiveEffects.where(_isBackgroundEffect));
      _foregroundEffects.addAll(_pendingActiveEffects.where(_isForegroundEffect));
      _pendingActiveEffects.clear();
    }
    if (_backgroundEffects.isNotEmpty) {
      _backgroundElapsedTimeNotifier.value = elapsed - _lastElapsed;
    }
    if (_foregroundEffects.isNotEmpty) {
      _foregroundElapsedTimeNotifier.value = elapsed - _lastElapsed;
    }
    _lastElapsed = elapsed;
  }

  @override
  Widget build(BuildContext context) {
    return _NewtonScope(
      newtonState: this,
      child: FutureBuilder(
        future: _shapeSpriteSheet,
        builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
          if (snapshot.hasData) {
            return RepaintBoundary(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return CustomPaint(
                    willChange: _backgroundEffects.isNotEmpty || _foregroundEffects.isNotEmpty,
                    size: constraints.biggest,
                    painter: NewtonPainter(
                      blendMode: widget.blendMode,
                      elapsedTimeNotifier: _backgroundElapsedTimeNotifier,
                      effects: _backgroundEffects,
                      shapesSpriteSheet: snapshot.data!,
                    ),
                    foregroundPainter: NewtonPainter(
                      blendMode: widget.blendMode,
                      elapsedTimeNotifier: _foregroundElapsedTimeNotifier,
                      effects: _foregroundEffects,
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
      ),
    );
  }

  bool _isBackgroundEffect<T extends AnimatedParticle, R extends EffectConfiguration>(Effect<T, R> effect) =>
      !effect.effectConfiguration.foreground;

  bool _isForegroundEffect<T extends AnimatedParticle, R extends EffectConfiguration>(Effect<T, R> effect) =>
      effect.effectConfiguration.foreground;

  /// Adds a new particle effect to the list of active effects.
  ///
  /// The `addEffect` method allows you to dynamically add a new particle effect to the list
  /// of active effects. Simply provide an `Effect` instance representing the desired effect,
  /// and the `Newton` widget will render it on the canvas.
  Effect<AnimatedParticle, EffectConfiguration> addEffect(EffectConfiguration effectConfiguration) {
    final effect = effectConfiguration.effect()
      ..addedAtRuntime = true
      ..postEffectCallback = _onPostEffect
      ..stateChangeCallback = _onEffectStateChanged;
    if (effectConfiguration.foreground) {
      _foregroundEffects.add(
        effect,
      );
    } else {
      _backgroundEffects.add(
        effect,
      );
    }
    return effect;
  }

  /// Remove a effect from the list of active effects.
  ///
  /// The `removeEffect` method allows you to dynamically remove a particle effect from the list
  /// of active effects.
  void removeEffect<T extends AnimatedParticle, R extends EffectConfiguration>(Effect<T, R> effect) {
    if (effect.effectConfiguration.foreground) {
      _foregroundEffects.removeWhere((e) => e.rootEffect == effect);
    } else {
      _backgroundEffects.removeWhere((e) => e.rootEffect == effect);
    }
  }

  /// Remove a effect from the list of active effects given an effect configuration.
  ///
  /// The `removeEffect` method allows you to dynamically remove a particle effect from the list
  /// of active effects given an effect configuration. All effects with same configuration will be removed.
  void removeEffectConfiguration<T extends EffectConfiguration>(T effectConfiguration) {
    final effects = switch (effectConfiguration.foreground) {
      true => _foregroundEffects,
      false => _backgroundEffects,
    };
    return effects.removeWhere(
      (e) => e.effectConfiguration == effectConfiguration || e.rootEffect?.effectConfiguration == effectConfiguration,
    );
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
    _backgroundEffects.removeWhere((effect) {
      effect.postEffectCallback = null;
      return true;
    });
    _foregroundEffects.removeWhere((effect) {
      effect.postEffectCallback = null;
      return true;
    });
  }

  @override
  void didUpdateWidget(Newton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.effectConfigurations != oldWidget.effectConfigurations) {
      _pendingActiveEffects.removeWhere(_isEffectRemoved);
      _backgroundEffects.removeWhere(_isEffectRemoved);
      _foregroundEffects.removeWhere(_isEffectRemoved);
      _setupEffectsFromWidget();
    }
  }

  bool _isEffectRemoved<T extends AnimatedParticle, R extends EffectConfiguration>(Effect<T, R> effect) {
    // Keep only pending effects that are still active even if it's a post effect
    return !widget.effectConfigurations.contains(effect.effectConfiguration) && !effect.addedAtRuntime;
  }

  void _setupEffectsFromWidget() {
    for (final configuration in widget.effectConfigurations) {
      final effect = configuration.effect()
        ..postEffectCallback = _onPostEffect
        ..stateChangeCallback = _onEffectStateChanged;
      if (configuration.foreground) {
        _foregroundEffects.add(effect);
      } else {
        _backgroundEffects.add(effect);
      }
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
