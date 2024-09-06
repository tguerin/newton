import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/effects/relativistic/newton_world.dart';

/// The `RelativisticPathTransformation` class is responsible for transforming the position
/// of a `RelativisticParticle` within a `NewtonWorld`.
///
/// This class takes into account the relativistic effects as modeled by the `NewtonWorld`
/// and applies them to the particle's position, ensuring that the particle's position is
/// updated according to the simulated physics of the world.
///
/// Example usage:
///
/// ```dart
/// final world = NewtonWorld(...);
/// final transformation = RelativisticPathTransformation(world: world);
/// transformation.transform(relativisticParticle);
/// ```
///
/// This will update the position of `relativisticParticle` based on the current state
/// of the `NewtonWorld`.
class RelativisticPathTransformation {
  /// Creates a `RelativisticPathTransformation` instance with the specified `NewtonWorld`.
  ///
  /// The `world` parameter is required and represents the physics world in which
  /// the particle's position will be transformed.
  RelativisticPathTransformation({required this.world});

  /// The `NewtonWorld` instance representing the simulated physics environment.
  final NewtonWorld world;

  /// Transforms the position of the given `RelativisticParticle` based on the current
  /// state of the `NewtonWorld`.
  ///
  /// This method calculates the new screen position of the particle within the
  /// relativistic world and updates the particle's position accordingly. If the
  /// position cannot be determined (e.g., if it is out of bounds), no changes are made.
  ///
  /// - [relativisticParticle]: The particle whose position is to be transformed.
  void transform(RelativisticParticle relativisticParticle) {
    final position = world.getParticleScreenPosition(relativisticParticle);
    if (position == null) return;
    relativisticParticle.particle.position = position;
  }
}
