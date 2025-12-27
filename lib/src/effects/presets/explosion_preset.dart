import 'package:flutter/material.dart' hide Velocity;
import 'package:newton_particles/newton_particles.dart';

/// A preset configuration for an explosion effect.
///
/// This preset creates particles that burst outward in all directions,
/// perfect for explosion or impact animations. The explosion uses
/// physics-based particles with high velocity.
///
/// Example usage:
///
/// ```dart
/// Newton(
///   activeEffects: [ExplosionPreset()],
/// )
/// ```
class ExplosionPreset {
  /// Creates an explosion preset with customizable options.
  ///
  /// - [colors]: List of colors for the explosion particles. Defaults to
  ///   fire colors (red, orange, yellow).
  /// - [particleCount]: Total number of particles in the explosion.
  ///   Defaults to 30.
  /// - [particlesPerEmit]: Number of particles emitted in the burst.
  ///   Defaults to 30 (all at once).
  /// - [origin]: Origin point for the explosion (0.0-1.0 relative to size).
  ///   Defaults to center (0.5, 0.5).
  /// - [gravity]: Gravity applied to particles. Defaults to zero (no gravity).
  const ExplosionPreset({
    this.colors = const [
      Colors.red,
      Colors.orange,
      Colors.yellow,
    ],
    this.particleCount = 30,
    this.particlesPerEmit = 30,
    this.origin = const Offset(0.5, 0.5),
    this.gravity = Gravity.zero,
  });

  /// Colors for the explosion particles.
  final List<Color> colors;

  /// Total number of particles in the explosion.
  final int particleCount;

  /// Number of particles emitted in the burst.
  final int particlesPerEmit;

  /// Origin point for the explosion (relative 0.0-1.0).
  final Offset origin;

  /// Gravity applied to particles.
  final Gravity gravity;

  /// Creates a [PhysicsEffectConfiguration] for the explosion effect.
  ///
  /// **Note**: This returns a `PhysicsEffectConfiguration` (the new recommended API).
  /// The old `RelativisticEffectConfiguration` is deprecated.
  PhysicsEffectConfiguration toConfiguration() {
    return PhysicsEffectConfiguration(
      physicsProperties: PhysicsProperties(
        gravity: gravity,
        angle: const NumRange.between(0, 360),
        velocity: NumRange.between(Velocity.custom(15), Velocity.custom(25)),
        solidEdges: SolidEdges.none,
      ),
      visualProperties: const VisualProperties(
        beginScale: NumRange.single(1.5),
        endScale: NumRange.between(0.1, 0.3),
        fadeOutThreshold: NumRange.between(0.5, 0.7),
        scaleCurve: Curves.easeOut,
        fadeOutCurve: Curves.easeIn,
      ),
      emissionProperties: EmissionProperties(
        particleCount: particleCount,
        particlesPerEmit: particlesPerEmit,
        emitDuration: const Duration(milliseconds: 1),
        origin: origin,
      ),
      particleConfiguration: ParticleConfiguration(
        shape: const CircleShape(),
        size: const Size(6, 6),
        color: LinearInterpolationParticleColor(colors: colors),
      ),
    );
  }
}
