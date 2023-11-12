import 'dart:math';
import 'dart:ui';

import 'package:newton_particles/newton_particles.dart';

/// A base class representing various shapes for rendering particles.
///
/// This sealed class defines different shapes that can be used for rendering particles.
/// It provides a method to compute the transformation parameters required for rendering
/// particles using the specified shape.
///
/// Each shape must override the [computeTransformation] method to calculate the necessary
/// transformation based on the particle's properties and the shape's specifications.
sealed class Shape {
  static const double defaultSpriteWidth = 500.0;
  static const double defaultSpriteHeight = 500.0;

  /// Computes the transformation parameters for rendering particles using this shape.
  ///
  /// see [Canvas.drawAtlas]
  (Image, Rect, RSTransform, Color) computeTransformation(
      Particle particle, Image defaultShapes);
}

/// Represents a circular shape for rendering particles.
class CircleShape extends Shape {
  @override
  (Image, Rect, RSTransform, Color) computeTransformation(
    Particle particle,
    Image defaultShapes,
  ) {
    const rect = Rect.fromLTWH(
      Shape.defaultSpriteWidth,
      0,
      Shape.defaultSpriteWidth,
      Shape.defaultSpriteHeight,
    );
    final transform = RSTransform.fromComponents(
      rotation: 0,
      scale: min(
        particle.size.width / Shape.defaultSpriteWidth,
        particle.size.height / Shape.defaultSpriteHeight,
      ),
      anchorX: Shape.defaultSpriteWidth / 2,
      anchorY: Shape.defaultSpriteHeight / 2,
      translateX: particle.position.dx,
      translateY: particle.position.dy,
    );
    final color = particle.color;
    return (defaultShapes, rect, transform, color);
  }
}

/// Represents a square shape for rendering particles.
class SquareShape extends Shape {
  @override
  (Image, Rect, RSTransform, Color) computeTransformation(
      Particle particle, Image defaultShapes) {
    const rect = Rect.fromLTWH(
      0,
      0,
      Shape.defaultSpriteWidth,
      Shape.defaultSpriteHeight,
    );
    final transform = RSTransform.fromComponents(
      rotation: 0,
      scale: min(
        particle.size.width / Shape.defaultSpriteWidth,
        particle.size.height / Shape.defaultSpriteHeight,
      ),
      anchorX: Shape.defaultSpriteWidth / 2,
      anchorY: Shape.defaultSpriteHeight / 2,
      translateX: particle.position.dx,
      translateY: particle.position.dy,
    );
    final color = particle.color;
    return (defaultShapes, rect, transform, color);
  }
}

/// Represents a shape based on an image for rendering particles.
class ImageShape extends Shape {
  final Image image;

  ImageShape(this.image);

  @override
  (Image, Rect, RSTransform, Color) computeTransformation(
      Particle particle, Image defaultShapes) {
    final rect = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final transform = RSTransform.fromComponents(
      rotation: 0,
      scale: min(
        particle.size.width / image.width,
        particle.size.height / image.height,
      ),
      anchorX: image.width / 2,
      anchorY: image.height / 2,
      translateX: particle.position.dx,
      translateY: particle.position.dy,
    );
    final color = particle.color;
    return (image, rect, transform, color);
  }
}
