import 'dart:ui';

import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/utils/random_extensions.dart';

/// A particle effect that creates a fountain-like animation in Newton.
///
/// The `FountainEffect` class extends the `Effect` class and provides a particle effect
/// that creates particles that rise and follow a Bezier path to simulate a fountain.
class FountainEffect extends Effect<AnimatedParticle> {
  /// Creates a `FountainEffect` with the specified configurations.
  ///
  /// - [particleConfiguration]: Configuration for the individual particles.
  /// - [effectConfiguration]: Configuration for the effect behavior.
  /// - [width]: The width of the fountain effect, controlling the horizontal spread of particles.
  FountainEffect({
    required super.particleConfiguration,
    required super.effectConfiguration,
    required this.width,
  });

  /// The width of the fountain effect in logical pixels.
  final double width;

  @override
  AnimatedParticle instantiateParticle(Size surfaceSize) {
    final path = Path();
    final randomWidth = random.nextDoubleRange(-width / 2, width / 2);
    final distance = randomDistance();

    // Define the Bezier path to simulate the fountain trajectory
    path
      ..moveTo(surfaceSize.width / 2, surfaceSize.height / 2)
      ..relativeQuadraticBezierTo(
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
      elapsedTimeOnStart: totalElapsed,
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
