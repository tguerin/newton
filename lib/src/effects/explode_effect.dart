import 'package:flutter/animation.dart';
import 'package:newton/src/effects/effect.dart';
import 'package:newton/src/particles/animated_particle.dart';
import 'package:newton/src/particles/particle.dart';
import 'package:newton/src/utils/random_extensions.dart';

class ExplodeEffect extends Effect<AnimatedParticle> {
  ExplodeEffect({
    required super.particleConfiguration,
    super.particlesPerEmit,
    super.emitDuration,
    super.emitCurve,
    super.origin,
    super.minDistance,
    super.maxDistance,
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
        position: Offset(origin.dx, origin.dy),
      ),
      startTime: totalElapsed,
      animationDuration: randomDuration(),
      distance: randomDistance(),
      scaleRange: randomScaleRange(),
      fadeOutThreshold: randomFadeOutThreshold(),
      angle: random.nextDoubleRange(0, 360),
      distanceCurve: distanceCurve,
      fadeInLimit: randomFadeInLimit(),
      fadeInCurve: fadeInCurve,
      fadeOutCurve: fadeOutCurve,
      scaleCurve: scaleCurve,
    );
  }
}
