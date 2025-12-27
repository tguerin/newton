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

  /// Creates a [RelativisticEffectConfiguration] for the fountain effect.
  RelativisticEffectConfiguration toConfiguration() {
    return RelativisticEffectConfiguration(
      gravity: gravity,
      origin: origin,
      maxOriginOffset: const Offset(0.1, 0),
      minOriginOffset: const Offset(-0.1, 0),
      // Spray upward (270 degrees) with slight spread
      maxAngle: 300,
      minAngle: 240,
      maxVelocity: Velocity.custom(20),
      minVelocity: Velocity.custom(15),
      maxParticleLifespan: const Duration(seconds: 3),
      minParticleLifespan: const Duration(seconds: 2),
      maxEndScale: 0.8,
      minEndScale: 0.6,
      minBeginScale: 0.8,
      maxFadeOutThreshold: 0.8,
      minFadeOutThreshold: 0.6,
      particleCount: particleCount,
      particlesPerEmit: particlesPerEmit,
      emitDuration: emitDuration,
      particleConfiguration: ParticleConfiguration(
        shape: const CircleShape(),
        size: const Size(4, 4),
        color: SingleParticleColor(color: color),
      ),
      scaleCurve: Curves.easeOut,
      fadeOutCurve: Curves.easeIn,
    );
  }
}
