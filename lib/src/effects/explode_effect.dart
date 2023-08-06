import 'package:flutter/animation.dart';
import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/utils/random_extensions.dart';

/// A particle effect that creates an explosion animation in Newton.
///
/// The `ExplodeEffect` class extends the `Effect` class and provides a particle effect
/// that resembles an explosion. The explosion effect emits particles from a specific origin
/// point in a burst-like manner.
class ExplodeEffect extends Effect<AnimatedParticle> {
  ExplodeEffect({
    required super.particleConfiguration,
    required super.effectConfiguration,
  });

  @override
  AnimatedParticle instantiateParticle(Size surfaceSize) {
    return AnimatedParticle(
      particle: Particle(
        configuration: particleConfiguration,
        position: Offset(
            effectConfiguration.origin.dx, effectConfiguration.origin.dy),
      ),
      startTime: totalElapsed,
      animationDuration: randomDuration(),
      scaleRange: randomScaleRange(),
      fadeOutThreshold: randomFadeOutThreshold(),
      pathTransformation: StraightPathTransformation(
        distance: randomDistance(),
        angle: randomAngle(),
      ),
      distanceCurve: effectConfiguration.distanceCurve,
      fadeInLimit: randomFadeInLimit(),
      fadeInCurve: effectConfiguration.fadeInCurve,
      fadeOutCurve: effectConfiguration.fadeOutCurve,
      scaleCurve: effectConfiguration.scaleCurve,
    );
  }
}
