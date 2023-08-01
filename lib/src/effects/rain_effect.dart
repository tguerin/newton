import 'package:flutter/animation.dart';
import 'package:newton_particles/newton_particles.dart';

/// A particle effect that creates a rain animation in Newton.
///
/// The `RainEffect` class extends the `Effect` class and provides a particle effect
/// that simulates falling raindrops. The rain effect emits particles from random x-coordinates
/// at the top of the animation surface, creating a realistic rain animation.
class RainEffect extends Effect<AnimatedParticle> {
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
      path: StraightPath(angle: 90),
      distance: surfaceSize.height,
      startTime: totalElapsed,
      animationDuration: randomDuration(),
      scaleRange: randomScaleRange(),
      fadeOutThreshold: randomFadeOutThreshold(),
      fadeInLimit: randomFadeInLimit(),
      distanceCurve: effectConfiguration.distanceCurve,
      fadeInCurve: effectConfiguration.fadeInCurve,
      fadeOutCurve: effectConfiguration.fadeOutCurve,
      scaleCurve: effectConfiguration.scaleCurve,
    );
  }
}
