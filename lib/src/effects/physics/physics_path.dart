import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/effects/physics/physics_particle.dart';
import 'package:newton_particles/src/effects/relativistic/newton_world.dart';

/// The `PhysicsPathTransformation` class is responsible for transforming the position
/// of a `PhysicsParticle` within a `NewtonWorld`.
///
/// This class takes into account the physics simulation as modeled by the `NewtonWorld`
/// and applies them to the particle's position, ensuring that the particle's position is
/// updated according to the simulated physics of the world.
///
/// Example usage:
///
/// ```dart
/// final world = NewtonWorld(...);
/// final transformation = PhysicsPathTransformation(world: world);
/// transformation.transform(physicsParticle);
/// ```
///
/// This will update the position of the particle based on the current state
/// of the `NewtonWorld`.
class PhysicsPathTransformation {
  /// Creates a `PhysicsPathTransformation` instance with the specified `NewtonWorld`.
  ///
  /// The `world` parameter is required and represents the physics world in which
  /// the particle's position will be transformed.
  PhysicsPathTransformation({required this.world});

  /// The `NewtonWorld` instance representing the simulated physics environment.
  final NewtonWorld world;

  /// Transforms the position of the given particle based on the current
  /// state of the `NewtonWorld`.
  ///
  /// This method calculates the new screen position of the particle within the
  /// physics world and updates the particle's position accordingly. If the
  /// position cannot be determined (e.g., if it is out of bounds), no changes are made.
  ///
  /// - [particle]: The `PhysicsParticle` whose position is to be transformed.
  void transform(PhysicsParticle particle) {
    final position = world.getParticleScreenPosition(particle);
    if (position == null) return;
    particle.particle.position = position;
  }
}
