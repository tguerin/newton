import 'package:flutter/material.dart' hide Velocity;
import 'package:newton_particles/newton_particles.dart';

/// A preset configuration for a fountain effect.
///
/// This preset creates particles that spray upward and fall back down,
/// perfect for fountain or water animations. The fountain uses
/// physics-based particles with gravity.
///
/// Example usage:
///
/// ```dart
/// Newton(
///   activeEffects: [FountainPreset()],
/// )
/// ```
class FountainPreset {
  /// Creates a fountain preset with customizable options.
  ///
  /// - [color]: Color of the fountain particles. Defaults to light blue.
  /// - [particleCount]: Total number of particles to emit.
  ///   Defaults to 0 (infinite). Set to a positive number for finite emission.
  /// - [particlesPerEmit]: Number of particles emitted per burst.
  ///   Defaults to 8.
  /// - [emitDuration]: Duration between particle emissions. Defaults to 50ms.
  /// - [origin]: Origin point for the fountain (0.0-1.0 relative to size).
  ///   Defaults to bottom center (0.5, 1.0).
  /// - [gravity]: Gravity applied to particles. Defaults to earth gravity.
  const FountainPreset({
    this.color = const Color(0xFF87CEEB),
    this.particleCount = 0,
    this.particlesPerEmit = 8,
    this.emitDuration = const Duration(milliseconds: 50),
    this.origin = const Offset(0.5, 1),
    this.gravity = Gravity.earthGravity,
  });

  /// Color of the fountain particles.
  final Color color;

  /// Total number of particles to emit.
  final int particleCount;

  /// Number of particles emitted per burst.
  final int particlesPerEmit;

  /// Duration between particle emissions.
  final Duration emitDuration;

  /// Origin point for the fountain (relative 0.0-1.0).
  final Offset origin;

  /// Gravity applied to particles.
  final Gravity gravity;

  /// Creates a [PhysicsEffectConfiguration] for the fountain effect.
  ///
  /// **Note**: This returns a `PhysicsEffectConfiguration` (the new recommended API).
  /// The old `RelativisticEffectConfiguration` is deprecated.
  PhysicsEffectConfiguration toConfiguration() {
    return PhysicsEffectConfiguration(
      physicsProperties: PhysicsProperties(
        gravity: gravity,
        angle: const NumRange.between(240, 300), // Spray upward (270 degrees) with slight spread
        velocity: NumRange.between(Velocity.custom(15), Velocity.custom(20)),
      ),
      visualProperties: const VisualProperties(
        beginScale: NumRange.single(0.8),
        endScale: NumRange.between(0.6, 0.8),
        fadeOutThreshold: NumRange.between(0.6, 0.8),
        scaleCurve: Curves.easeOut,
        fadeOutCurve: Curves.easeIn,
      ),
      emissionProperties: EmissionProperties(
        particleCount: particleCount,
        particlesPerEmit: particlesPerEmit,
        emitDuration: emitDuration,
        origin: origin,
        minOriginOffset: const Offset(-0.1, 0),
        maxOriginOffset: const Offset(0.1, 0),
        particleLifespan: const DurationRange.between(Duration(seconds: 2), Duration(seconds: 3)),
      ),
      particleConfiguration: ParticleConfiguration(
        shape: const CircleShape(),
        size: const Size(4, 4),
        color: SingleParticleColor(color: color),
      ),
    );
  }
}
