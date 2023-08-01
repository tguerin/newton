import 'package:flutter/animation.dart';
import 'package:newton_particles/newton_particles.dart';

/// A particle effect that creates a pulsing animation in Newton.
///
/// The `PulseEffect` class extends the `Effect` class and provides a particle effect
/// that creates a pulsating animation. The pulsing effect emits particles from a specific origin
/// point in a rhythmic manner, resembling a pulsing or beating motion.
class PulseEffect extends Effect<AnimatedParticle> {
  PulseEffect({
    required super.particleConfiguration,
    required super.effectConfiguration,
  });

  @override
  AnimatedParticle instantiateParticle(Size surfaceSize) {
    final particlesPerEmit = effectConfiguration.particlesPerEmit;
    final angle =
        360 / particlesPerEmit * (activeParticles.length % particlesPerEmit);
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
        angle: angle,
      ),
      distanceCurve: effectConfiguration.distanceCurve,
      fadeInLimit: randomFadeInLimit(),
      fadeInCurve: effectConfiguration.fadeInCurve,
      fadeOutCurve: effectConfiguration.fadeOutCurve,
      scaleCurve: effectConfiguration.scaleCurve,
    );
  }
}
