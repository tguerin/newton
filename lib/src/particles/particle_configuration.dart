import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

/// The `ParticleConfiguration` class represents the configuration for a particle in the animation.
///
/// The `ParticleConfiguration` class holds information about the shape, size, and color of a particle.
/// It is used to define the appearance of each particle in the animation.
class ParticleConfiguration {
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
    this.color = const SingleParticleColor(color: Colors.white),
    this.postEffectBuilder,
  });

  /// The shape of the particle.
  final Shape shape;

  /// The size of the particle.
  final Size size;

  /// The color of the particle. By default will use a single black color.
  final ParticleColor color;

  /// Effect to trigger once particle travel is over.
  final EffectConfiguration Function(Particle, Effect<AnimatedParticle, EffectConfiguration>)? postEffectBuilder;

  /// Creates a copy of this `ParticleConfiguration` but with the given fields replaced with new values.
  ///
  /// - [shape] replaces the current shape of the particle.
  /// - [size] replaces the current size of the particle.
  /// - [color] replaces the current color of the particle.
  /// - [postEffectBuilder] replaces the current post-effect builder of the particle.
  ///
  /// Returns a new `ParticleConfiguration` instance with the updated properties.
  ParticleConfiguration copyWith({
    Shape? shape,
    Size? size,
    ParticleColor? color,
    EffectConfiguration Function(Particle, Effect<AnimatedParticle, EffectConfiguration>)? postEffectBuilder,
  }) {
    return ParticleConfiguration(
      shape: shape ?? this.shape,
      size: size ?? this.size,
      color: color ?? this.color,
      postEffectBuilder: postEffectBuilder ?? this.postEffectBuilder,
    );
  }
}
