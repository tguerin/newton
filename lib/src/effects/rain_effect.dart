import 'package:flutter/animation.dart';
import 'package:newton_particles/newton_particles.dart';

/// A particle effect that creates a rain animation in Newton.
///
/// The `RainEffect` class extends the `Effect` class and provides a particle effect
/// that simulates falling raindrops. The rain effect emits particles from random x-coordinates
/// at the top of the animation surface, creating a realistic rain animation.
class RainEffect extends Effect<AnimatedParticle> {
  /// Creates a `RainEffect` with the specified configurations.
  ///
  /// - [particleConfiguration]: Configuration for the individual particles.
  /// - [effectConfiguration]: Configuration for the effect behavior.
  RainEffect({
    required super.particleConfiguration,
    required super.effectConfiguration,
  });

  @override
  AnimatedParticle instantiateParticle(Size surfaceSize) {
    return AnimatedParticle(
      particle: Particle(
        configuration: particleConfiguration,
        position: Offset(
          random.nextDouble() * surfaceSize.width,
          0,
        ),
      ),
      pathTransformation: StraightPathTransformation(
        distance: surfaceSize.height,
        angle: 90,
      ),
      elapsedTimeOnStart: totalElapsed,
      animationDuration: randomDuration(),
      scaleRange: randomScaleRange(),
      fadeOutThreshold: randomFadeOutThreshold(),
      fadeInThreshold: randomFadeInThreshold(),
      distanceCurve: effectConfiguration.distanceCurve,
      fadeInCurve: effectConfiguration.fadeInCurve,
      fadeOutCurve: effectConfiguration.fadeOutCurve,
      scaleCurve: effectConfiguration.scaleCurve,
      trail: effectConfiguration.trail,
    );
  }
}
