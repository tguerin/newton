import 'package:flutter/widgets.dart';
import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/effects/relativistic/newton_world.dart';
import 'package:newton_particles/src/effects/relativistic/path.dart';

class RelativistEffect extends Effect<RelativisticParticle, RelativisticEffectConfiguration> {
  RelativistEffect({
    required RelativisticEffectConfiguration effectConfiguration,
    required ParticleConfiguration particleConfiguration,
  })  : world = NewtonWorld(effectConfiguration.gravity),
        super(
          effectConfiguration: effectConfiguration,
          particleConfiguration: particleConfiguration,
        );

  final NewtonWorld world;

  @override
  void onTimeForwarded(Duration elapsedDuration) {
    world.forward(elapsedDuration);
  }

  @override
  void onParticleDestroyed(RelativisticParticle particle) {
    world.removeParticle(particle);
  }

  @override
  RelativisticParticle instantiateParticle(Size surfaceSize) {
    final origin = Offset(
      effectConfiguration.origin.dx * surfaceSize.width,
      effectConfiguration.origin.dy * surfaceSize.height,
    );
    final relativistParticle = RelativisticParticle(
      animationDuration: effectConfiguration.randomDuration(),
      elapsedTimeOnStart: totalElapsed,
      fadeInCurve: Curves.easeIn,
      fadeInThreshold: effectConfiguration.randomFadeInThreshold(),
      fadeOutCurve: Curves.easeIn,
      fadeOutThreshold: effectConfiguration.randomFadeOutThreshold(),
      particle: Particle(
        configuration: particleConfiguration,
        position: origin,
      ),
      pathTransformation: RelativisticPathTransformation(world: world),
      scaleCurve: Curves.easeIn,
      scaleRange: effectConfiguration.randomScaleRange(),
      trail: const NoTrail(),
    );
    world.addParticle(relativistParticle);
    return relativistParticle;
  }
}
