import 'package:newton_particles/src/effects/animated_particle.dart';
import 'package:newton_particles/src/effects/relativistic/path.dart';

class RelativisticParticle extends AnimatedParticle {
  final RelativisticPathTransformation pathTransformation;

  RelativisticParticle({
    required this.pathTransformation,
    required super.animationDuration,
    required super.elapsedTimeOnStart,
    required super.fadeInCurve,
    required super.fadeInThreshold,
    required super.fadeOutCurve,
    required super.fadeOutThreshold,
    required super.particle,
    required super.scaleCurve,
    required super.scaleRange,
    required super.trail,
  });

  @override
  void onAnimationUpdate(Duration totalElapsed) {
    super.onAnimationUpdate(totalElapsed);
    pathTransformation.transform(this);
  }
}
