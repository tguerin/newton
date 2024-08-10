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
  /// Constructs a [Shape] instance.
  const Shape();

  /// Default size of the sprite used to get shapes.
  static const defaultSpriteSize = Size(500, 500);

  /// Computes the transformation parameters for rendering particles using this shape.
  ///
  /// The method returns a tuple containing an [Image], a [Rect], an [RSTransform],
  /// and a [Color]. These parameters are used by the canvas to draw the particle
  /// in the desired shape and orientation.
  ///
  /// - [particle]: The [Particle] instance containing properties such as size and position.
  /// - [defaultShapes]: The [Image] representing default shape textures.
  ///
  /// Returns a tuple `(Image, Rect, RSTransform, Color)` with the computed parameters.
  (Image, Rect, RSTransform, Color) computeTransformation(
    Particle particle,
    Image defaultShapes,
  );
}

/// Represents a circular shape for rendering particles.
///
/// This class calculates the transformation needed to render particles as circles
/// using the default sprite size.
class CircleShape extends Shape {
  @override
  (Image, Rect, RSTransform, Color) computeTransformation(
    Particle particle,
    Image defaultShapes,
  ) {
    final rect = Rect.fromLTWH(
      Shape.defaultSpriteSize.width,
      0,
      Shape.defaultSpriteSize.width,
      Shape.defaultSpriteSize.height,
    );
    final transform = RSTransform.fromComponents(
      rotation: 0,
      scale: min(
        particle.size.width / Shape.defaultSpriteSize.width,
        particle.size.height / Shape.defaultSpriteSize.height,
      ),
      anchorX: Shape.defaultSpriteSize.width / 2,
      anchorY: Shape.defaultSpriteSize.height / 2,
      translateX: particle.position.dx,
      translateY: particle.position.dy,
    );
    final color = particle.color;
    return (defaultShapes, rect, transform, color);
  }
}

/// Represents a square shape for rendering particles.
///
/// This class calculates the transformation needed to render particles as squares
/// using the default sprite size.
class SquareShape extends Shape {
  @override
  (Image, Rect, RSTransform, Color) computeTransformation(
    Particle particle,
    Image defaultShapes,
  ) {
    final rect = Rect.fromLTWH(
      0,
      0,
      Shape.defaultSpriteSize.width,
      Shape.defaultSpriteSize.height,
    );
    final transform = RSTransform.fromComponents(
      rotation: 0,
      scale: min(
        particle.size.width / Shape.defaultSpriteSize.width,
        particle.size.height / Shape.defaultSpriteSize.height,
      ),
      anchorX: Shape.defaultSpriteSize.width / 2,
      anchorY: Shape.defaultSpriteSize.height / 2,
      translateX: particle.position.dx,
      translateY: particle.position.dy,
    );
    final color = particle.color;
    return (defaultShapes, rect, transform, color);
  }
}

/// Represents a shape based on an image for rendering particles.
///
/// This class allows particles to be rendered using a custom image. The image
/// is used to define the shape and appearance of the particles.
class ImageShape extends Shape {
  /// Constructs an [ImageShape] with the specified [image].
  const ImageShape(this.image);

  /// The image used to render particles.
  final Image image;

  @override
  (Image, Rect, RSTransform, Color) computeTransformation(
    Particle particle,
    Image defaultShapes,
  ) {
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
