import 'package:flutter/animation.dart';
import 'package:newton/src/effects/effect.dart';
import 'package:newton/src/particles/animated_particle.dart';
import 'package:newton/src/particles/particle.dart';

class RainEffect extends Effect<AnimatedParticle> {
  RainEffect({
    required super.particleConfiguration,
    super.emitDuration,
    super.particlesPerEmit,
    super.minDuration,
    super.maxDuration,
    super.minBeginScale,
    super.maxBeginScale,
    super.minEndScale,
    super.maxEndScale,
    super.minFadeOutThreshold,
    super.maxFadeOutThreshold,
    super.minFadeInLimit,
    super.maxFadeInLimit,
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
      angle: 90,
      distance: surfaceSize.height,
      startTime: totalElapsed,
      animationDuration: randomDuration(),
      scaleRange: randomScaleRange(),
      fadeOutThreshold: randomFadeOutThreshold(),
      fadeInLimit: randomFadeInLimit(),
      distanceCurve: distanceCurve,
      fadeInCurve: fadeInCurve,
      fadeOutCurve: fadeOutCurve,
      scaleCurve: scaleCurve,
    );
  }
}
