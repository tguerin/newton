import 'package:flutter/material.dart' hide Velocity;
import 'package:newton_particles/newton_particles.dart';

/// A preset configuration for a rain effect.
///
/// This preset creates rain particles that fall straight down with gravity,
/// perfect for weather animations. The rain uses physics-based particles.
///
/// Example usage:
///
/// ```dart
/// Newton(
///   activeEffects: [RainPreset()],
/// )
/// ```
class RainPreset {
  /// Creates a rain preset with customizable options.
  ///
  /// - [color]: Color of the rain drops. Defaults to light blue.
  /// - [particleCount]: Total number of rain drops to emit.
  ///   Defaults to 0 (infinite). Set to a positive number for finite rain.
  /// - [particlesPerEmit]: Number of rain drops emitted per burst.
  ///   Defaults to 5.
  /// - [emitDuration]: Duration between particle emissions. Defaults to 100ms.
  /// - [origin]: Origin point for rain emission (0.0-1.0 relative to size).
  ///   Defaults to top center (0.5, 0.0).
  /// - [gravity]: Gravity applied to rain drops. Defaults to earth gravity.
  const RainPreset({
    this.color = const Color(0xFF87CEEB),
    this.particleCount = 0,
    this.particlesPerEmit = 5,
    this.emitDuration = const Duration(milliseconds: 100),
    this.origin = const Offset(0.5, 0),
    this.gravity = Gravity.earthGravity,
  });

  /// Color of the rain drops.
  final Color color;

  /// Total number of rain drops to emit.
  final int particleCount;

  /// Number of rain drops emitted per burst.
  final int particlesPerEmit;

  /// Duration between particle emissions.
  final Duration emitDuration;

  /// Origin point for rain emission (relative 0.0-1.0).
  final Offset origin;

  /// Gravity applied to rain drops.
  final Gravity gravity;

  /// Creates a [PhysicsEffectConfiguration] for the rain effect.
  ///
  /// **Note**: This returns a `PhysicsEffectConfiguration` (the new recommended API).
  /// The old `RelativisticEffectConfiguration` is deprecated.
  PhysicsEffectConfiguration toConfiguration() {
    return PhysicsEffectConfiguration(
      physicsProperties: PhysicsProperties(
        gravity: gravity,
        angle: const Range.single(90),
        velocity: Range.between(Velocity.custom(15), Velocity.custom(20)),
        solidEdges: const SolidEdges.only(bottom: true),
        onlyInteractWithEdges: true,
      ),
      visualProperties: const VisualProperties(
        fadeOutThreshold: Range.single(0.9),
      ),
      emissionProperties: EmissionProperties(
        particleCount: particleCount,
        particlesPerEmit: particlesPerEmit,
        emitDuration: emitDuration,
        origin: origin,
        minOriginOffset: const Offset(-1, 0),
        maxOriginOffset: const Offset(1, 0),
        minParticleLifespan: const Duration(seconds: 3),
        maxParticleLifespan: const Duration(seconds: 5),
      ),
      particleConfiguration: ParticleConfiguration(
        shape: const CircleShape(),
        size: const Size(2, 8),
        color: SingleParticleColor(color: color),
      ),
    );
  }
}
