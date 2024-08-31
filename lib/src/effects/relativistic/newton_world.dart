import 'dart:ui';

import 'package:newton_particles/src/effects/relativistic/relativistic_particle.dart';

/// The `NewtonWorld` abstract interface defines the core methods required for managing
/// relativistic particles in a simulated world. It provides functionalities to add, remove,
/// and update particles, as well as to compute their positions on the screen.
abstract interface class NewtonWorld {
  /// Adds a `RelativisticParticle` to the world.
  ///
  /// - [relativistParticle]: The particle to be added to the simulation.
  void addParticle(RelativisticParticle relativistParticle);

  /// Advances the simulation forward by the given elapsed duration.
  ///
  /// - [elapsedDuration]: The duration to move the simulation forward.
  void forward(Duration elapsedDuration);

  /// Retrieves the screen position of a given `RelativisticParticle`.
  ///
  /// - [relativisticParticle]: The particle for which to compute the screen position.
  ///
  /// Returns the screen position as an [Offset], or `null` if the position
  /// cannot be determined.
  Offset? getParticleScreenPosition(RelativisticParticle relativisticParticle);

  /// Removes a `RelativisticParticle` from the world.
  ///
  /// - [particle]: The particle to be removed from the simulation.
  void removeParticle(RelativisticParticle particle);

  /// Updates the size of the surface on which the simulation is displayed.
  ///
  /// - [surfaceSize]: The new size of the surface.
  void updateSurfaceSize(Size surfaceSize);

  /// Updates the list of active particles in the world.
  ///
  /// - [activeParticles]: A list of currently active particles to be updated in the simulation.
  void updateParticles(List<RelativisticParticle> activeParticles);
}
