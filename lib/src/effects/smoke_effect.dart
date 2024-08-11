import 'package:flutter/animation.dart';
import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/utils/random_extensions.dart';

/// A particle effect that creates a smoke animation in Newton.
///
/// The `SmokeEffect` class extends the `Effect` class and provides a particle effect
/// that simulates rising smoke. It configures particles to move in a manner that
/// resembles smoke rising, with adjustable properties for the width of the smoke
/// and other customizable animation parameters.
class SmokeEffect extends Effect<AnimatedParticle> {
  /// Creates a `SmokeEffect` with the specified configurations.
  ///
  /// - [effectConfiguration]: Configuration for the effect behavior.
  /// - [particleConfiguration]: Configuration for the individual particles.
  /// - [smokeWidth]: The width of the smoke effect in logical pixels.
  SmokeEffect({
    required super.effectConfiguration,
    required super.particleConfiguration,
    this.smokeWidth = 30,
  });

  /// The width of the smoke effect in logical pixels.
  final double smokeWidth;

  @override
  AnimatedParticle instantiateParticle(Size surfaceSize) {
    final angleDegrees = -90 + randomAngle();
    final beginX = random.nextDoubleRange(-smokeWidth / 2, smokeWidth / 2);

    return AnimatedParticle(
      particle: Particle(
        configuration: particleConfiguration,
        position: Offset(
          beginX + effectConfiguration.origin.dx,
          effectConfiguration.origin.dy,
        ),
      ),
      elapsedTimeOnStart: totalElapsed,
      animationDuration: randomDuration(),
      pathTransformation: StraightPathTransformation(
        distance: randomDistance(),
        angle: angleDegrees,
      ),
      fadeOutThreshold: randomFadeOutThreshold(),
      fadeInThreshold: randomFadeInThreshold(),
      scaleRange: randomScaleRange(),
      distanceCurve: effectConfiguration.distanceCurve,
      fadeInCurve: effectConfiguration.fadeInCurve,
      fadeOutCurve: effectConfiguration.fadeOutCurve,
      scaleCurve: effectConfiguration.scaleCurve,
      trail: effectConfiguration.trail,
    );
  }
}
