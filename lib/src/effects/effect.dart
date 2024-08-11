import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/utils/random_extensions.dart';

/// An abstract class representing an effect that emits particles for animations in Newton.
///
/// Extend this class to create custom particle effects. Subclasses must implement the
/// `instantiateParticle` method to define how particles are emitted and their behavior.
/// The `Effect` class provides the framework for creating visually stunning animations
/// with particles that can be customized based on your specific requirements.
///
/// Example:
/// ```dart
/// class CustomEffect extends Effect<AnimatedParticle> {
///   @override
///   AnimatedParticle instantiateParticle(Size surfaceSize) {
///     // Define the behavior of particles during emission.
///     // Set particle positions, travel paths, and animation properties here.
///   }
/// }
/// ```
///
/// The `Effect` class is used with the `NewtonEmitter` widget to create captivating animations
/// in your Flutter application. By implementing the `instantiateParticle` method, you have full
/// control over particle properties, such as emission frequency, particle appearance, movement,
/// and animation. This allows you to achieve a wide range of stunning visual effects, such as
/// rain, smoke, explosions, and more.
abstract class Effect<T extends AnimatedParticle> {
  /// Creates an `Effect` instance with the given particle and effect configurations.
  ///
  /// The `effectConfiguration` and `particleConfiguration` parameters allow customization
  /// of particle behavior and emission characteristics.
  Effect({
    required this.effectConfiguration,
    required this.particleConfiguration,
  });

  /// Immutable list of active particles managed by the effect.
  final List<T> _activeParticles = List.empty(growable: true);

  /// Provides access to the active particles as a read-only list.
  List<T> get activeParticles => _activeParticles.toList();

  /// Random number generator for particle properties.
  final random = Random();

  /// Total elapsed time since the effect started.
  Duration totalElapsed = Duration.zero;

  /// Elapsed duration since start of the effect for the last emitted particle.
  Duration _lastInstantiation = Duration.zero;

  /// Size of the animation surface.
  Size _surfaceSize = Size.zero;

  /// Configuration for the effect. See [EffectConfiguration].
  final EffectConfiguration effectConfiguration;

  /// Configuration for particle properties. See [ParticleConfiguration].
  final ParticleConfiguration particleConfiguration;

  /// Total number of emitted particles.
  int _totalEmittedCount = 0;

  /// Callback to notify when a post effect is occurring.
  ValueChanged<Effect>? postEffectCallback;

  /// Root effect that triggered this effect.
  Effect get rootEffect => _rootEffect ?? this;

  set rootEffect(Effect rootEffect) {
    _rootEffect = rootEffect;
  }

  Effect? _rootEffect;

  /// Indicates if the effect was added at runtime.
  bool addedAtRuntime = false;

  /// Current state of the effect.
  EffectState _state = EffectState.running;

  /// Provides access to the current state of the effect.
  EffectState get state => _state;

  /// Indicates whether the effect should be played in the foreground.
  bool get foreground => effectConfiguration.foreground;

  /// Callback to be notified when the state has changed.
  //ignore: avoid_setters_without_getters
  set stateChangeCallback(void Function(Effect, EffectState)? value) {
    _stateChangeCallback = value;
    _stateChangeCallback?.call(this, _state);
  }

  void Function(Effect, EffectState)? _stateChangeCallback;

  bool _firstEmision = true;

  /// Abstract method to be implemented by subclasses to define particle emission behavior.
  ///
  /// This method is called upon particle emission and is responsible for instantiating particles
  /// and setting their initial properties, positions, and trajectories. Use the provided `surfaceSize`
  /// parameter to determine the available animation area and customize particle behavior accordingly.
  ///
  /// Example:
  /// ```dart
  /// AnimatedParticle instantiateParticle(Size surfaceSize) {
  ///   // Implement the particle emission behavior here.
  ///   // Customize particle properties based on the `surfaceSize`.
  ///   // Create and add particles to the animation.
  /// }
  /// ```
  T instantiateParticle(Size surfaceSize);

  /// Advances the effect animation based on the elapsed duration.
  ///
  /// This method is automatically called to update the particle animation.
  /// It handles particle emission, cleaning up finished particles, updating
  /// particle states, and managing the effect lifecycle.
  @mustCallSuper
  void forward(Duration elapsedDuration) {
    totalElapsed += elapsedDuration;
    if (totalElapsed < effectConfiguration.startDelay) {
      _lastInstantiation = totalElapsed;
      return;
    }
    _emitParticles();
    _cleanParticles();
    _updateParticles();
    _killEffectWhenOver();
  }

  /// Emits particles based on the current configuration and elapsed time.
  void _emitParticles() {
    if (_firstEmision || (totalElapsed - _lastInstantiation > effectConfiguration.emitDuration)) {
      _lastInstantiation = totalElapsed;
      if (_state == EffectState.running) {
        _firstEmision = false;
        for (var i = 0; i < effectConfiguration.particlesPerEmit; i++) {
          if (_isEmissionAllowed()) {
            _totalEmittedCount++;
            _activeParticles.add(instantiateParticle(_surfaceSize));
          } else {
            break;
          }
        }
      }
    }
  }

  /// Cleans up particles that have finished their animation.
  void _cleanParticles() {
    _activeParticles.removeWhere((activeParticle) {
      final animationOver = activeParticle.animationDuration < totalElapsed - activeParticle.elapsedTimeOnStart;
      if (animationOver) {
        final postEffectBuilder = activeParticle.particle.configuration.postEffectBuilder;
        if (postEffectBuilder != null) {
          postEffectCallback?.call(
            postEffectBuilder(activeParticle.particle)
              ..rootEffect = rootEffect
              ..addedAtRuntime = addedAtRuntime,
          );
        }
      }
      return animationOver;
    });
  }

  /// Updates the state of all active particles based on the current progress.
  void _updateParticles() {
    for (final element in _activeParticles) {
      element.onAnimationUpdate(
        (totalElapsed - element.elapsedTimeOnStart).inMilliseconds / element.animationDuration.inMilliseconds,
      );
    }
  }

  /// Terminates the effect when all emissions are complete and no particles remain active.
  void _killEffectWhenOver() {
    if (_isEmissionOver()) {
      kill();
    }
  }

  /// Checks if the emission of particles is allowed based on the configuration.
  bool _isEmissionAllowed() {
    return _totalEmittedCount < effectConfiguration.particleCount || effectConfiguration.particleCount <= 0;
  }

  /// Checks if the emission process is complete.
  bool _isEmissionOver() {
    return activeParticles.isEmpty &&
        _totalEmittedCount == effectConfiguration.particleCount &&
        effectConfiguration.particleCount > 0;
  }

  /// Updates the effect's state and notifies listeners of the state change.
  void _updateState(EffectState state) {
    _state = state;
    _stateChangeCallback?.call(this, _state);
  }

  /// Gets the size of the animation surface.
  Size get surfaceSize => _surfaceSize;

  /// Sets the size of the animation surface.
  set surfaceSize(Size value) {
    if (_surfaceSize == value) return;
    for (final particle in _activeParticles) {
      particle.onSurfaceSizeChanged(_surfaceSize, value);
    }
    _surfaceSize = value;
  }

  /// Starts the effect emission, allowing particles to be emitted.
  ///
  /// This method transitions the effect to the running state and enables
  /// particle emission. If the effect has been killed, an error is thrown.
  void start() {
    if (_state == EffectState.killed) {
      throw StateError('Can’t start a killed effect');
    }
    _updateState(EffectState.running);
  }

  /// Stops the effect emission, optionally canceling all active particles.
  ///
  /// This method transitions the effect to the stopped state, halting
  /// particle emission. If `cancel` is true, all active particles are cleared.
  void stop({bool cancel = false}) {
    if (_state == EffectState.killed) return;
    _firstEmision = true;
    _updateState(EffectState.stopped);
    if (cancel) {
      _activeParticles.clear();
    }
  }

  /// Kills the effect, stopping all particle emission and removing active particles.
  ///
  /// This method transitions the effect to the killed state, stops emission,
  /// and clears all active particles and callbacks.
  void kill() {
    stop(cancel: true);
    _updateState(EffectState.killed);
    postEffectCallback = null;
  }

  /// Helper method to generate a random distance
  /// within the range [EffectConfiguration.minDistance] - [EffectConfiguration.maxDistance].
  double randomDistance() {
    return random.nextDoubleRange(
      effectConfiguration.minDistance,
      effectConfiguration.maxDistance,
    );
  }

  /// Helper method to generate a random angle
  /// within the range [EffectConfiguration.minAngle] - [EffectConfiguration.maxAngle].
  double randomAngle() {
    return random.nextDoubleRange(
      effectConfiguration.minAngle,
      effectConfiguration.maxAngle,
    );
  }

  /// Helper method to generate a random duration
  /// within the range [EffectConfiguration.minDuration] - [EffectConfiguration.maxDuration].
  Duration randomDuration() {
    return Duration(
      milliseconds: random.nextIntRange(
        effectConfiguration.minDuration.inMilliseconds,
        effectConfiguration.maxDuration.inMilliseconds,
      ),
    );
  }

  /// Helper method to generate a random scale range
  /// within the range ([EffectConfiguration.minBeginScale] - [EffectConfiguration.maxBeginScale])
  /// - ([EffectConfiguration.minEndScale] - [EffectConfiguration.maxEndScale]).
  ///
  /// If no end scale is defined, the beginning scale is used as the end scale.
  Tween<double> randomScaleRange() {
    final beginScale = random.nextDoubleRange(
      effectConfiguration.minBeginScale,
      effectConfiguration.maxBeginScale,
    );
    final endScale = (effectConfiguration.minEndScale < 0 || effectConfiguration.maxEndScale < 0)
        ? beginScale
        : random.nextDoubleRange(
            effectConfiguration.minEndScale,
            effectConfiguration.maxEndScale,
          );
    return Tween(begin: beginScale, end: endScale);
  }

  /// Helper method to generate a random fade-out threshold
  /// within the range [EffectConfiguration.minFadeOutThreshold] - [EffectConfiguration.maxFadeOutThreshold].
  double randomFadeOutThreshold() {
    return random.nextDoubleRange(
      effectConfiguration.minFadeOutThreshold,
      effectConfiguration.maxFadeOutThreshold,
    );
  }

  /// Helper method to generate a random fade-in limit
  /// within the range [EffectConfiguration.minFadeInThreshold] - [EffectConfiguration.maxFadeInThreshold].
  double randomFadeInLimit() {
    return random.nextDoubleRange(
      effectConfiguration.minFadeInThreshold,
      effectConfiguration.maxFadeInThreshold,
    );
  }
}
