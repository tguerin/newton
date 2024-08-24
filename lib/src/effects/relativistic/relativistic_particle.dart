import 'package:newton_particles/src/effects/animated_particle.dart';
import 'package:newton_particles/src/effects/relativistic/path.dart';

class RelativisticParticle extends AnimatedParticle {

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
  final RelativisticPathTransformation pathTransformation;

  @override
  void onAnimationUpdate(Duration totalElapsed) {
    super.onAnimationUpdate(totalElapsed);
    pathTransformation.transform(this);
  }
}
