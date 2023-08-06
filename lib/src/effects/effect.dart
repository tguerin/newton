import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:newton_particles/src/effects/effect_configuration.dart';
import 'package:newton_particles/src/particles/animated_particle.dart';
import 'package:newton_particles/src/particles/particle_configuration.dart';
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
  final List<AnimatedParticle> _activeParticles = List.empty(growable: true);

  /// Immutable List of active particles managed by the effect.
  List<AnimatedParticle> get activeParticles => _activeParticles.toList();

  /// Random number generator for particle properties.
  final random = Random();

  /// Total elapsed time since the effect started.
  double totalElapsed = 0;

  /// Timestamp of the last particle emission.
  double _lastInstantiation = 0;

  /// Size of the animation surface.
  Size _surfaceSize = const Size(0, 0);

  /// Flag indicating whether particle emission should stop.
  bool _stopEmission = false;

  /// Flag indicating if the effect is killed and no longer active.
  bool _killed = false;

  /// Configuration for the effect. See [EffectConfiguration].
  final EffectConfiguration effectConfiguration;

  /// Configuration for particle properties. See [ParticleConfiguration].
  final ParticleConfiguration particleConfiguration;

  /// Total number of emitted particles
  int _totalEmittedCount = 0;

  /// Register a callback if you want to be notified that a post effect is occurring
  ValueChanged<Effect>? postEffectCallback;

  Effect({
    required this.particleConfiguration,
    required this.effectConfiguration,
  });

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
  AnimatedParticle instantiateParticle(Size surfaceSize);

  /// Advances the effect animation based on the elapsed time in milliseconds.
  /// This method is automatically called to update the particle animation.
  @mustCallSuper
  forward(int elapsedMillis) {
    totalElapsed += elapsedMillis;
    _emitParticles();
    _cleanParticles();
    _updateParticles();
    _killEffectWhenOver();
  }

  void _emitParticles() {
    if (totalElapsed - _lastInstantiation > effectConfiguration.emitDuration) {
      _lastInstantiation = totalElapsed;
      if (!_stopEmission) {
        for (int i = 0; i < effectConfiguration.particlesPerEmit; i++) {
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

  void _cleanParticles() {
    _activeParticles.removeWhere((activeParticle) {
      final animationOver = activeParticle.animationDuration <
          totalElapsed - activeParticle.startTime;
      if (animationOver) {
        final postEffectBuilder =
            activeParticle.particle.configuration.postEffectBuilder;
        if (postEffectBuilder != null) {
          postEffectCallback?.call(postEffectBuilder(activeParticle.particle));
        }
      }
      return animationOver;
    });
  }

  void _updateParticles() {
    for (var element in _activeParticles) {
      element.onAnimationUpdate(
          (totalElapsed - element.startTime) / element.animationDuration);
    }
  }

  void _killEffectWhenOver() {
    if (_isEmissionOver()) {
      kill();
    }
  }

  bool _isEmissionAllowed() {
    return _totalEmittedCount < effectConfiguration.particleCount ||
        effectConfiguration.particleCount <= 0;
  }

  bool _isEmissionOver() {
    return activeParticles.isEmpty &&
        _totalEmittedCount == effectConfiguration.particleCount &&
        effectConfiguration.particleCount > 0;
  }

  /// Sets the size of the animation surface.
  set surfaceSize(Size value) {
    for (var particle in _activeParticles) {
      particle.onSurfaceSizeChanged(_surfaceSize, value);
    }
    _surfaceSize = value;
  }

  /// Starts the effect emission, allowing particles to be emitted.
  start() {
    if (_killed) {
      throw StateError("Can't start a killed effect");
    }
    _stopEmission = false;
  }

  /// Stops the effect emission, optionally cancelling all active particles.
  stop({bool cancel = false}) {
    if (_killed) return;
    _stopEmission = true;
    if (cancel) {
      _activeParticles.clear();
    }
  }

  /// Checks if the effect emission is stopped.
  bool get isStopped => _stopEmission;

  /// Kills the effect, stopping all particle emission and removing active particles.
  kill() {
    stop(cancel: true);
    _killed = true;
    postEffectCallback = null;
  }

  /// Checks if the effect is no longer active and has been killed.
  bool get isDead => _killed;

  /// Helper method to generate random distance
  /// within the range [EffectConfiguration.minDistance] - [EffectConfiguration.maxDistance].
  double randomDistance() {
    return random.nextDoubleRange(
      effectConfiguration.minDistance,
      effectConfiguration.maxDistance,
    );
  }

  /// Helper method to generate random angle
  /// within the range [EffectConfiguration.minAngle] - [EffectConfiguration.maxAngle].
  double randomAngle() {
    return random.nextDoubleRange(
      effectConfiguration.minAngle,
      effectConfiguration.maxAngle,
    );
  }

  /// Helper method to generate random duration
  /// within the range [EffectConfiguration.minDuration] - [EffectConfiguration.maxDuration].
  int randomDuration() {
    return random.nextIntRange(
      effectConfiguration.minDuration,
      effectConfiguration.maxDuration,
    );
  }

  /// Helper method to generate random scale range
  /// within the range ([EffectConfiguration.minBeginScale] - [EffectConfiguration.maxBeginScale])
  /// - ([EffectConfiguration.minEndScale] - [EffectConfiguration.maxEndScale] ).
  ///
  /// If no endScale is defined, we us the beginScale as endScale.
  Tween<double> randomScaleRange() {
    final beginScale = random.nextDoubleRange(
      effectConfiguration.minBeginScale,
      effectConfiguration.maxBeginScale,
    );
    final endScale = (effectConfiguration.minEndScale < 0 ||
            effectConfiguration.maxEndScale < 0)
        ? beginScale
        : random.nextDoubleRange(
            effectConfiguration.minEndScale, effectConfiguration.maxEndScale);
    return Tween(begin: beginScale, end: endScale);
  }

  /// Helper method to generate random fadeOut threshold
  /// within the range [EffectConfiguration.minFadeOutThreshold] - [EffectConfiguration.maxFadeOutThreshold]
  double randomFadeOutThreshold() {
    return random.nextDoubleRange(
      effectConfiguration.minFadeOutThreshold,
      effectConfiguration.maxFadeOutThreshold,
    );
  }

  /// Helper method to generate random fadeIn limit
  /// within the range [EffectConfiguration.minFadeInLimit] - [EffectConfiguration.maxFadeInLimit]
  double randomFadeInLimit() {
    return random.nextDoubleRange(
      effectConfiguration.minFadeInLimit,
      effectConfiguration.maxFadeInLimit,
    );
  }
}
