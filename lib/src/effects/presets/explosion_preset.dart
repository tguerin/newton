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

  /// Creates a [RelativisticEffectConfiguration] for the explosion effect.
  RelativisticEffectConfiguration toConfiguration() {
    return RelativisticEffectConfiguration(
      gravity: gravity,
      origin: origin,
      maxAngle: 360,
      maxVelocity: Velocity.custom(25),
      minVelocity: Velocity.custom(15),
      maxEndScale: 0.3,
      minEndScale: 0.1,
      maxBeginScale: 1.5,
      maxFadeOutThreshold: 0.7,
      minFadeOutThreshold: 0.5,
      particleCount: particleCount,
      particlesPerEmit: particlesPerEmit,
      emitDuration: const Duration(milliseconds: 1),
      particleConfiguration: ParticleConfiguration(
        shape: const CircleShape(),
        size: const Size(6, 6),
        color: LinearInterpolationParticleColor(colors: colors),
      ),
      solidEdges: SolidEdges.none,
      scaleCurve: Curves.easeOut,
      fadeOutCurve: Curves.easeIn,
    );
  }
}
