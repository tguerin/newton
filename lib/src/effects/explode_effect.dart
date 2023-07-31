import 'package:flutter/animation.dart';

import 'package:newton_particles/src/effects/effect.dart';
import 'package:newton_particles/src/particles/animated_particle.dart';
import 'package:newton_particles/src/particles/particle.dart';
import 'package:newton_particles/src/utils/random_extensions.dart';

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
      distance: randomDistance(),
      scaleRange: randomScaleRange(),
      fadeOutThreshold: randomFadeOutThreshold(),
      angle: random.nextDoubleRange(0, 360),
      distanceCurve: effectConfiguration.distanceCurve,
      fadeInLimit: randomFadeInLimit(),
      fadeInCurve: effectConfiguration.fadeInCurve,
      fadeOutCurve: effectConfiguration.fadeOutCurve,
      scaleCurve: effectConfiguration.scaleCurve,
    );
  }
}
