import 'package:flutter/widgets.dart';
import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/effects/relativistic/forge/forge_newton_world.dart';
import 'package:newton_particles/src/effects/relativistic/newton_world.dart';
import 'package:newton_particles/src/effects/relativistic/path.dart';

/// The `RelativistEffect` class represents a particle effect that applies relativistic physics
/// principles to particles within a simulated world.
///
/// This effect leverages the `NewtonWorld` to simulate particles with properties such as gravity,
/// friction, restitution, and velocity under relativistic transformations. The effect configuration
/// is highly customizable, allowing for dynamic creation and management of relativistic particles.
class RelativistEffect extends Effect<RelativisticParticle, RelativisticEffectConfiguration> {
  /// Creates a `RelativistEffect` with the specified configuration.
  ///
  /// The `RelativistEffect` initializes a new `ForgeNewtonWorld` with the provided gravity and
  /// hard edges settings from the effect configuration. This world serves as the environment
  /// where particles are simulated.
  RelativistEffect(super.effectConfiguration)
      : _world = ForgeNewtonWorld(
          effectConfiguration.gravity,
          effectConfiguration.solidEdges,
        );

  /// The `NewtonWorld` instance representing the simulated environment where particles are managed.
  final NewtonWorld _world;

  /// Advances the simulation by the given duration.
  ///
  /// This method forwards the state of the simulation by the specified [elapsedDuration], updating
  /// the positions and states of all particles in the world according to the rules of relativistic physics.
  @override
  void onTimeForwarded(Duration elapsedDuration) {
    _world.forward(elapsedDuration);
  }

  /// Handles the destruction of a particle within the simulation.
  ///
  /// When a particle is destroyed, this method ensures that it is removed from the `NewtonWorld`.
  ///
  /// - [particle]: The `RelativisticParticle` that has been destroyed.
  @override
  void onParticleDestroyed(RelativisticParticle particle) {
    _world.removeParticle(particle);
  }

  /// Instantiates a new `RelativisticParticle` with randomized properties based on the effect configuration.
  ///
  /// This method creates a new particle, applying random variations to its properties such as
  /// angle, restitution, friction, velocity, and more. The particle is then added to the `NewtonWorld` for simulation.
  ///
  /// - [surfaceSize]: The size of the surface on which the particles are rendered.
  ///
  /// Returns a newly created `RelativisticParticle` instance.
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

  /// Updates the size of the simulation surface.
  ///
  /// This method is called when the size of the surface on which particles are rendered changes.
  /// It updates the `NewtonWorld` with the new surface size to ensure that the simulation remains accurate.
  @override
  void onSurfaceSizeChanged() {
    _world.updateSurfaceSize(surfaceSize);
  }

  /// Updates the state of particles within the `NewtonWorld`.
  ///
  /// This method is called periodically to update the positions and states of all active particles
  /// in the simulation, ensuring that they behave according to the rules of the `NewtonWorld`.
  @override
  void onParticlesUpdated() {
    _world.updateParticles(activeParticles);
  }
}
