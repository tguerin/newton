import 'package:flutter/widgets.dart';
import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/effects/relativistic/forge/forge_newton_world.dart';
import 'package:newton_particles/src/effects/relativistic/newton_world.dart';
import 'package:newton_particles/src/effects/relativistic/path.dart';

class RelativistEffect extends Effect<RelativisticParticle, RelativisticEffectConfiguration> {
  RelativistEffect(super.effectConfiguration)
      : _world = ForgeNewtonWorld(
          effectConfiguration.gravity,
          effectConfiguration.hardEdges,
        );

  final NewtonWorld _world;

  @override
  void onTimeForwarded(Duration elapsedDuration) {
    _world.forward(elapsedDuration);
  }

  @override
  void onParticleDestroyed(RelativisticParticle particle) {
    _world.removeParticle(particle);
  }

  @override
  RelativisticParticle instantiateParticle(Size surfaceSize) {
    final effectConfiguration = this.effectConfiguration.configurationOverrider?.call(this) ?? this.effectConfiguration;
    final randomOriginOffset = effectConfiguration.randomOriginOffset();
    final relativistParticle = RelativisticParticle(
      angle: effectConfiguration.randomAngle(),
      restitution: effectConfiguration.randomRestitution(),
      friction: effectConfiguration.randomFriction(),
      velocity: effectConfiguration.randomVelocity(),
      density: effectConfiguration.randomDensity(),
      animationDuration: effectConfiguration.randomDuration(),
      elapsedTimeOnStart: totalElapsed,
      fadeInCurve: effectConfiguration.fadeInCurve,
      fadeInThreshold: effectConfiguration.randomFadeInThreshold(),
      fadeOutCurve: effectConfiguration.fadeOutCurve,
      fadeOutThreshold: effectConfiguration.randomFadeOutThreshold(),
      foreground: effectConfiguration.randomParticleForeground(),
      onlyInteractWithEdges: effectConfiguration.onlyInteractWithEdges,
      particle: Particle(
        configuration: effectConfiguration.particleConfiguration,
        position: Offset(
              effectConfiguration.origin.dx * surfaceSize.width,
              effectConfiguration.origin.dy * surfaceSize.height,
            ) +
            Offset(
              randomOriginOffset.dx * surfaceSize.width,
              randomOriginOffset.dy * surfaceSize.height,
            ),
      ),
      pathTransformation: RelativisticPathTransformation(world: _world),
      scaleRange: effectConfiguration.randomScaleRange(),
      scaleCurve: effectConfiguration.scaleCurve,
      trail: effectConfiguration.trail,
    );
    _world.addParticle(relativistParticle);
    return relativistParticle;
  }

  @override
  void onSurfaceSizeChanged() {
    _world.updateSurfaceSize(surfaceSize);
  }

  @override
  void onParticlesUpdated() {
    _world.updateParticles(activeParticles);
  }
}
