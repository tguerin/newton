import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/effects/relativistic/path.dart';

class RelativisticParticle extends AnimatedParticle {
  RelativisticParticle({
    required this.angle,
    required this.density,
    required this.friction,
    required this.pathTransformation,
    required this.restitution,
    required this.velocity,
    required this.onlyInteractWithEdges,
    required super.animationDuration,
    required super.elapsedTimeOnStart,
    required super.fadeInCurve,
    required super.fadeInThreshold,
    required super.fadeOutCurve,
    required super.fadeOutThreshold,
    required super.foreground,
    required super.particle,
    required super.scaleCurve,
    required super.scaleRange,
    required super.trail,
  });

  final double angle;
  final Friction friction;
  final Density density;
  final bool onlyInteractWithEdges;
  final Restitution restitution;
  final Velocity velocity;
  final RelativisticPathTransformation pathTransformation;

  @override
  void onAnimationUpdate(Duration totalElapsed) {
    super.onAnimationUpdate(totalElapsed);
    pathTransformation.transform(this);
  }
}
