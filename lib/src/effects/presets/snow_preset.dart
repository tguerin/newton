import 'package:flutter/material.dart' hide Velocity;
import 'package:newton_particles/newton_particles.dart';

/// A preset configuration for a snow effect.
///
/// This preset creates snowflakes that fall slowly with slight horizontal drift,
/// perfect for winter weather animations. The snow uses physics-based particles
/// with low gravity and slight wind effect.
///
/// Example usage:
///
/// ```dart
/// Newton(
///   activeEffects: [SnowPreset()],
/// )
/// ```
class SnowPreset {
  /// Creates a snow preset with customizable options.
  ///
  /// - [color]: Color of the snowflakes. Defaults to white.
  /// - [particleCount]: Total number of snowflakes to emit.
  ///   Defaults to 0 (infinite). Set to a positive number for finite snow.
  /// - [particlesPerEmit]: Number of snowflakes emitted per burst.
  ///   Defaults to 3.
  /// - [emitDuration]: Duration between particle emissions. Defaults to 200ms.
  /// - [origin]: Origin point for snow emission (0.0-1.0 relative to size).
  ///   Defaults to top center (0.5, 0.0).
  /// - [windStrength]: Horizontal wind effect (negative = left, positive = right).
  ///   Defaults to 0.5 (slight rightward drift).
  const SnowPreset({
    this.color = Colors.white,
    this.particleCount = 0,
    this.particlesPerEmit = 3,
    this.emitDuration = const Duration(milliseconds: 200),
    this.origin = const Offset(0.5, 0),
    this.windStrength = 0.5,
  });

  /// Color of the snowflakes.
  final Color color;

  /// Total number of snowflakes to emit.
  final int particleCount;

  /// Number of snowflakes emitted per burst.
  final int particlesPerEmit;

  /// Duration between particle emissions.
  final Duration emitDuration;

  /// Origin point for snow emission (relative 0.0-1.0).
  final Offset origin;

  /// Horizontal wind effect (negative = left, positive = right).
  final double windStrength;

  /// Creates a [PhysicsEffectConfiguration] for the snow effect.
  ///
  /// **Note**: This returns a `PhysicsEffectConfiguration` (the new recommended API).
  /// The old `RelativisticEffectConfiguration` is deprecated.
  PhysicsEffectConfiguration toConfiguration() {
    // Light gravity for slow fall
    const gravity = Gravity(0, 2);

    return PhysicsEffectConfiguration(
      gravity: gravity,
      origin: origin,
      maxOriginOffset: const Offset(1, 0),
      minOriginOffset: const Offset(-1, 0),
      // Slight angle variation for drift
      maxAngle: 95 + windStrength * 5,
      minAngle: 85 + windStrength * 5,
      maxVelocity: Velocity.custom(8),
      minVelocity: Velocity.custom(4),
      maxParticleLifespan: const Duration(seconds: 10),
      minParticleLifespan: const Duration(seconds: 7),
      maxEndScale: 1.2,
      minEndScale: 0.8,
      minBeginScale: 0.8,
      maxFadeOutThreshold: 0.9,
      minFadeOutThreshold: 0.7,
      particleCount: particleCount,
      particlesPerEmit: particlesPerEmit,
      emitDuration: emitDuration,
      particleConfiguration: ParticleConfiguration(
        shape: const CircleShape(),
        size: const Size(6, 6),
        color: SingleParticleColor(color: color),
      ),
      solidEdges: const SolidEdges.only(bottom: true),
      onlyInteractWithEdges: true,
      scaleCurve: Curves.easeInOut,
      fadeOutCurve: Curves.easeIn,
    );
  }
}
