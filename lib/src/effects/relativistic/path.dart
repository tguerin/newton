import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/effects/relativistic/newton_world.dart';

class RelativisticPathTransformation {
  RelativisticPathTransformation({required this.world});
  final NewtonWorld world;

  void transform(RelativisticParticle relativisticParticle) {
    final position = world.getParticleScreenPosition(relativisticParticle);
    if(position == null) return;
    relativisticParticle.particle.position = position;
  }

}
