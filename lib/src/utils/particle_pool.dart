import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

/// A pool for reusing [Particle] instances to reduce memory allocations.
///
/// This pool helps improve performance by reusing particle instances instead of
/// creating new ones every time, reducing garbage collection pressure.
class ParticlePool {
  /// Creates a new [ParticlePool] with the specified maximum size.
  ///
  /// - [maxSize]: The maximum number of particles to keep in the pool.
  ///   Defaults to 100. When the pool reaches this size, additional particles
  ///   returned via [release] will be discarded instead of being stored.
  ParticlePool({this.maxSize = 100});

  /// Maximum number of particles to keep in the pool.
  final int maxSize;

  final List<Particle> _pool = [];

  /// Acquires a particle from the pool or creates a new one if the pool is empty.
  ///
  /// The particle should be initialized with the provided configuration and position.
  /// After use, return it to the pool using [release].
  Particle acquire({
    required ParticleConfiguration configuration,
    required Offset position,
    double rotation = 0,
  }) {
    if (_pool.isNotEmpty) {
      final particle = _pool.removeLast();
      _resetParticle(particle, configuration, position, rotation);
      return particle;
    }
    return Particle(
      configuration: configuration,
      position: position,
      rotation: rotation,
    );
  }

  /// Returns a particle to the pool for reuse.
  ///
  /// The particle will be stored and can be reused later. Only particles
  /// created through [acquire] should be returned to this pool.
  void release(Particle particle) {
    if (_pool.length < maxSize) {
      _pool.add(particle);
    }
  }

  /// Resets a particle's mutable state to prepare it for reuse.
  void _resetParticle(
    Particle particle,
    ParticleConfiguration configuration,
    Offset position,
    double rotation,
  ) {
    particle.resetForPool(
      configuration: configuration,
      position: position,
      rotation: rotation,
    );
  }

  /// Clears all particles from the pool.
  void clear() {
    _pool.clear();
  }

  /// Returns the current number of particles in the pool.
  int get size => _pool.length;
}
