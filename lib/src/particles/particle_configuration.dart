import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

/// The `ParticleConfiguration` class represents the configuration for a particle in the animation.
///
/// The `ParticleConfiguration` class holds information about the shape, size, and color of a particle.
/// It is used to define the appearance of each particle in the animation.
class ParticleConfiguration {
  /// The shape of the particle.
  final Shape shape;

  /// The size of the particle.
  final Size size;

  /// The color of the particle. By default will use a single black color.
  final ParticleColor color;

  /// Effect to trigger once particle travel is over.
  final Effect<AnimatedParticle> Function(Particle)? postEffectBuilder;

  /// Creates a `ParticleConfiguration` with the specified shape, size, and color.
  ///
  /// The `shape` parameter is required and represents the shape of the particle, which can be a `CircleShape`,
  /// `SquareShape`, or `ImageShape`.
  ///
  /// The `size` parameter is required and represents the size of the particle as a `Size` object.
  ///
  /// The `color` parameter is optional and represents the color of the particle. It defaults to `Colors.black`.
  ///
  /// The `postEffectBuilder` parameter is optional and represents the effect to trigger once particle travel is over.
  /// It defaults to `null`, that means no effect.
  const ParticleConfiguration({
    required this.shape,
    required this.size,
    this.color = const SingleParticleColor(color: Colors.black),
    this.postEffectBuilder,
  });
}
