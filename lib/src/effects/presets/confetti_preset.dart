import 'package:flutter/material.dart' hide Velocity;
import 'package:newton_particles/newton_particles.dart';

/// A preset configuration for a confetti celebration effect.
///
/// This preset creates colorful confetti particles that fall with gravity,
/// perfect for celebration animations. The confetti uses physics-based
/// particles with bouncy collisions.
///
/// Example usage:
///
/// ```dart
/// Newton(
///   activeEffects: [ConfettiPreset()],
/// )
/// ```
class ConfettiPreset {
  /// Creates a confetti preset with customizable options.
  ///
  /// - [colors]: List of colors for the confetti particles. Defaults to a
  ///   festive rainbow of colors.
  /// - [particleCount]: Total number of confetti particles to emit.
  ///   Defaults to 50. Set to 0 for infinite emission.
  /// - [particlesPerEmit]: Number of particles emitted per burst.
  ///   Defaults to 10.
  /// - [emitDuration]: Duration between particle emissions. Defaults to 50ms.
  /// - [origin]: Origin point for confetti emission (0.0-1.0 relative to size).
  ///   Defaults to center top (0.5, 0.0).
  /// - [gravity]: Gravity applied to particles. Defaults to earth gravity.
  const ConfettiPreset({
    this.colors = const [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
    ],
    this.particleCount = 50,
    this.particlesPerEmit = 10,
    this.emitDuration = const Duration(milliseconds: 50),
    this.origin = const Offset(0.5, 0),
    this.gravity = Gravity.earthGravity,
  });

  /// Colors for the confetti particles.
  final List<Color> colors;

  /// Total number of confetti particles to emit.
  final int particleCount;

  /// Number of particles emitted per burst.
  final int particlesPerEmit;

  /// Duration between particle emissions.
  final Duration emitDuration;

  /// Origin point for confetti emission (relative 0.0-1.0).
  final Offset origin;

  /// Gravity applied to particles.
  final Gravity gravity;

  /// Creates a [PhysicsEffectConfiguration] for the confetti effect.
  ///
  /// **Note**: This returns a `PhysicsEffectConfiguration` (the new recommended API).
  /// The old `RelativisticEffectConfiguration` is deprecated.
  PhysicsEffectConfiguration toConfiguration() {
    return PhysicsEffectConfiguration(
      gravity: gravity,
      origin: origin,
      maxOriginOffset: const Offset(0.2, 0),
      minOriginOffset: const Offset(-0.2, 0),
      maxAngle: 180,
      maxVelocity: Velocity.custom(15),
      minVelocity: Velocity.custom(5),
      maxParticleLifespan: const Duration(seconds: 3),
      minParticleLifespan: const Duration(seconds: 2),
      maxEndScale: 0.5,
      minEndScale: 0.3,
      maxBeginScale: 1.2,
      minBeginScale: 0.8,
      maxFadeOutThreshold: 0.8,
      minFadeOutThreshold: 0.6,
      particleCount: particleCount,
      particlesPerEmit: particlesPerEmit,
      emitDuration: emitDuration,
      particleConfiguration: ParticleConfiguration(
        shape: const SquareShape(),
        size: const Size(8, 8),
        color: LinearInterpolationParticleColor(colors: colors),
      ),
      solidEdges: const SolidEdges.only(bottom: true),
      scaleCurve: Curves.easeOut,
      fadeOutCurve: Curves.easeIn,
    );
  }
}
