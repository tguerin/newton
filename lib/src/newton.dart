/// The `newton_particles` library provides a powerful and highly configurable particle emitter
/// for creating visually captivating animations in Flutter apps, such as rain, smoke, or explosions.
///
/// To get started, import the `newton_particles` library into your Dart code and include the
/// `Newton` widget in your widget tree. The `Newton` widget allows you to add and manage
/// various particle effects by passing a list of `EffectConfiguration` instances.
/// It automatically handles the animation and rendering of these particle effects on a custom canvas.
library newton_particles;

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:newton_particles/newton_particles.dart';
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
  var _lastElapsed = Duration.zero;
  final _pendingActiveEffects = List<Effect>.empty(growable: true);
  late Future<ui.Image> _shapeSpriteSheet;

  final _effects = <Effect>[];
  final _effectsElapsedTimeNotifier = _ElapsedTimeNotifier();

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
    _effects.removeWhere((effect) => effect.state == EffectState.killed);
  }

  void _updateActiveEffects(Duration elapsed) {
    if (_pendingActiveEffects.isNotEmpty) {
      _effects.addAll(_pendingActiveEffects);
      _pendingActiveEffects.clear();
    }
    if (_effects.isNotEmpty) {
      _effectsElapsedTimeNotifier.value = elapsed - _lastElapsed;
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
                    willChange: _effects.isNotEmpty,
                    size: constraints.biggest,
                    painter: NewtonPainter(
                      elapsedTimeNotifier: _effectsElapsedTimeNotifier,
                      effects: _effects,
                      shapesSpriteSheet: snapshot.data!,
                    ),
                    foregroundPainter: NewtonPainter(
                      elapsedTimeNotifier: _effectsElapsedTimeNotifier,
                      effects: _effects,
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
    _effects
      ..forEach((effect) => effect.dispose())
      ..clear();
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
    if (widget.effectConfigurations != oldWidget.effectConfigurations) {
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
