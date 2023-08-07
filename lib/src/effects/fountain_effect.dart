import 'dart:ui';

import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/utils/random_extensions.dart';

/// A particle effect that creates a fountain like animation in Newton.
///
/// The `FountainEffect` class extends the `Effect` class and provides a particle effect
/// that creates particles going up and following a Bezier path to imitate a fountain.
class FountainEffect extends Effect<AnimatedParticle> {
  final double width;

  FountainEffect({
    required super.particleConfiguration,
    required super.effectConfiguration,
    required this.width,
  });

  @override
  AnimatedParticle instantiateParticle(Size surfaceSize) {
    Path path = Path();
    final randomWidth = random.nextDoubleRange(-width / 2, width / 2);
    final distance = randomDistance();
    path.moveTo(surfaceSize.width / 2, surfaceSize.height / 2);
    path.relativeQuadraticBezierTo(
      randomWidth,
      -distance,
      randomWidth * 4,
      -distance / random.nextIntRange(2, 6),
    );
    return AnimatedParticle(
      particle: Particle(
        configuration: particleConfiguration,
        position: Offset(
          effectConfiguration.origin.dx,
          effectConfiguration.origin.dy,
        ),
      ),
      startTime: totalElapsed,
      animationDuration: randomDuration(),
      pathTransformation: PathMetricsTransformation(
        path: path,
      ),
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
