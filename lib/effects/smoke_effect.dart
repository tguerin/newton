import 'dart:ui';

import 'package:newton/effects/effect.dart';
import 'package:newton/particles/animated_particle.dart';
import 'package:newton/particles/particle.dart';
import 'package:newton/utils/random_extensions.dart';

class SmokeEffect extends Effect<AnimatedParticle> {
  final double angle;
  final double smokeWidth;

  SmokeEffect({
    required super.particleConfiguration,
    super.emitDuration,
    super.particlesPerEmit,
    super.origin = const Offset(0, 0),
    super.minDistance,
    super.maxDistance,
    super.minDuration,
    super.maxDuration,
    super.minBeginScale,
    super.maxBeginScale,
    super.minEndScale,
    super.maxEndScale,
    super.minFadeOutThreshold = 1,
    super.maxFadeOutThreshold = 1,
    this.angle = 15,
    this.smokeWidth = 30,
  });

  @override
  AnimatedParticle instantiateParticle(Size surfaceSize) {
    final angleDegrees = -90 + random.nextDoubleRange(-angle, angle);
    final beginX = random.nextDoubleRange(-smokeWidth / 2, smokeWidth / 2);
    return AnimatedParticle(
      particle: Particle(
        particleConfiguration,
        Offset(beginX + origin.dx, origin.dy),
      ),
      startTime: totalElapsed,
      animationDuration: randomDuration(),
      distance: randomDistance(),
      angle: angleDegrees,
      fadeOutThreshold: randomFadeOutThreshold(),
      fadeInLimit: randomFadeInLimit(),
      scaleRange: randomScaleRange(),
      distanceCurve: distanceCurve,
      fadeInCurve: fadeInCurve,
      fadeOutCurve: fadeOutCurve,
      scaleCurve: scaleCurve,
    );
  }
}
