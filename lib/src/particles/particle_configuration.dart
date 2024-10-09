import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

/// The `ParticleConfiguration` class represents the configuration for a particle in the animation.
///
/// The `ParticleConfiguration` class holds information about the shape, size, and color of a particle.
/// It is used to define the appearance of each particle in the animation.
@immutable
class ParticleConfiguration {
  /// Creates a `ParticleConfiguration` with the specified shape, size, and color.
  /// Either `shape` or `shapeBuilder` must be provided.
  ///
  /// The `shape` parameter represents the shape of the particle, which can be a `CircleShape`,
  /// `SquareShape`, or `ImageShape`.
  ///
  /// The `shapeBuilder` parameter can be used to dynamically create a shape based on the initial position of the particle.
  ///
  /// The `size` parameter is required and represents the size of the particle as a `Size` object.
  ///
  /// The `color` parameter is optional and represents the color of the particle. It defaults to `Colors.black`.
  ///
  /// The `zIndexBuilder` parameter is optional and can be used to generate z-index values which determine the particle rendering order.
  ///
  /// The `postEffectBuilder` parameter is optional and represents the effect to trigger once particle travel is over.
  /// It defaults to `null`, that means no effect.
  const ParticleConfiguration({
    this.shape,
    this.shapeBuilder,
    required this.size,
    this.color = const SingleParticleColor(color: Colors.white),
    this.zIndexBuilder,
    this.postEffectBuilder,
  }) : assert(
          (shape != null || shapeBuilder != null) && (shape == null || shapeBuilder == null),
          'Either shape or shapeBuilder must be provided but not both',
        );

  /// The shape of the particle.
  final Shape? shape;

  /// Builder to create shapes instead of using the singular [shape].
  final ShapeBuilder? shapeBuilder;

  /// The size of the particle.
  final Size size;

  /// The color of the particle. By default will use a single black color.
  final ParticleColor color;

  /// Builder to generate z-index values to have fine-grained control of particle rendering order.
  /// By default, all particles are rendered on top of each other.
  final ZIndexBuilder? zIndexBuilder;

  /// Effect to trigger once particle travel is over.
  final PostEffectBuilder? postEffectBuilder;

  /// Creates a copy of this `ParticleConfiguration` but with the given fields replaced with new values.
  ///
  /// - [shape] replaces the current shape of the particle.
  /// - [shapeBuilder] replaces the current shape builder of the particle.
  /// - [size] replaces the current size of the particle.
  /// - [color] replaces the current color of the particle.
  /// - [zIndexBuilder] replaces the current z-index builder of the particle.
  /// - [postEffectBuilder] replaces the current post-effect builder of the particle.
  ///
  /// Returns a new `ParticleConfiguration` instance with the updated properties.
  ParticleConfiguration copyWith({
    Shape? shape,
    ShapeBuilder? shapeBuilder,
    Size? size,
    ParticleColor? color,
    ZIndexBuilder? zIndexBuilder,
    PostEffectBuilder? postEffectBuilder,
  }) {
    return ParticleConfiguration(
      shape: shape ?? this.shape,
      shapeBuilder: shapeBuilder ?? this.shapeBuilder,
      size: size ?? this.size,
      color: color ?? this.color,
      zIndexBuilder: zIndexBuilder ?? this.zIndexBuilder,
      postEffectBuilder: postEffectBuilder ?? this.postEffectBuilder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticleConfiguration &&
          runtimeType == other.runtimeType &&
          shape == other.shape &&
          shapeBuilder == other.shapeBuilder &&
          size == other.size &&
          color == other.color &&
          zIndexBuilder == other.zIndexBuilder &&
          postEffectBuilder == other.postEffectBuilder;

  @override
  int get hashCode =>
      shape.hashCode ^
      shapeBuilder.hashCode ^
      size.hashCode ^
      color.hashCode ^
      zIndexBuilder.hashCode ^
      postEffectBuilder.hashCode;
}
