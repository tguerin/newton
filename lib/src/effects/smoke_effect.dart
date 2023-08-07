import 'package:flutter/animation.dart';
import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/utils/random_extensions.dart';

/// A particle effect that creates a smoke animation in Newton.
///
/// The `SmokeEffect` class extends the `Effect` class and provides a particle effect
/// that simulates rising smoke.
class SmokeEffect extends Effect<AnimatedParticle> {
  final double smokeWidth;

  SmokeEffect({
    required super.particleConfiguration,
    required super.effectConfiguration,
    this.smokeWidth = 30,
  });

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
      startTime: totalElapsed,
      animationDuration: randomDuration(),
      pathTransformation: StraightPathTransformation(
          distance: randomDistance(), angle: angleDegrees),
      fadeOutThreshold: randomFadeOutThreshold(),
      fadeInLimit: randomFadeInLimit(),
      scaleRange: randomScaleRange(),
      distanceCurve: effectConfiguration.distanceCurve,
      fadeInCurve: effectConfiguration.fadeInCurve,
      fadeOutCurve: effectConfiguration.fadeOutCurve,
      scaleCurve: effectConfiguration.scaleCurve,
      trail: effectConfiguration.trail,
    );
  }
}
