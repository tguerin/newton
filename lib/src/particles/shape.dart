import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  /// The method returns a tuple containing an [ui.Image], a [Rect], an [RSTransform],
  /// and a [Color]. These parameters are used by the canvas to draw the particle
  /// in the desired shape and orientation.
  ///
  /// - [particle]: The [Particle] instance containing properties such as size and position.
  /// - [defaultShapes]: The [ui.Image] representing default shape textures.
  ///
  /// Returns a tuple `(Image, Rect, RSTransform, Color)` with the computed parameters.
  ({ui.Image image, ui.Rect rect, ui.RSTransform transform, ui.Color color})? computeTransformation(
    Particle particle,
    ui.Image defaultShapes,
  );

  void dispose();
}

/// Represents a circular shape for rendering particles.
///
/// This class calculates the transformation needed to render particles as circles
/// using the default sprite size.
class CircleShape extends Shape {
  @override
  ({ui.Image image, ui.Rect rect, ui.RSTransform transform, ui.Color color})? computeTransformation(
    Particle particle,
    ui.Image defaultShapes,
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
    return (image: defaultShapes, rect: rect, transform: transform, color: color);
  }

  @override
  void dispose() {}
}

/// Represents a shape based on an image for rendering particles.
///
/// This class allows particles to be rendered using a custom image. The image
/// is used to define the shape and appearance of the particles.
class ImageShape extends Shape {
  /// Constructs an [ImageShape] with the specified [image].
  const ImageShape(this.image);

  /// The image used to render particles.
  final ui.Image image;

  @override
  ({ui.Image image, ui.Rect rect, ui.RSTransform transform, ui.Color color})? computeTransformation(
      Particle particle,
      ui.Image defaultShapes,
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
    return (image: image, rect: rect, transform: transform, color: color);
  }

  @override
  void dispose() {
    image.dispose();
  }
}

/// Represents a shape based on an asset image for rendering particles.
///
/// This class allows particles to be rendered using an image loaded from the asset.
/// If the primary image fails to load, a placeholder image can be used as a fallback.
class ImageAssetShape extends Shape {
  /// Constructs an [ImageAssetShape] with the specified [imagePath] and a [placeholderImage].
  ///
  /// - [imagePath]: The path to the image asset.
  /// - [placeholderImage]: An optional placeholder image used if the asset fails to load.
  /// - [deferLoading]: If set to true, the image loading will be deferred and must be initiated manually.
  ImageAssetShape(
      this.imagePath, {
        bool deferLoading = false,
        ui.Image? placeholderImage,
      }) : _imageShape = placeholderImage != null ? ImageShape(placeholderImage) : null {
    if (!deferLoading) {
      load();
    }
  }

  /// The path to the image asset used for rendering.
  final String imagePath;

  /// The image shape created from the loaded or placeholder image.
  ImageShape? _imageShape;

  /// Loads the image from assets.
  ///
  /// This method attempts to load the image from the given [imagePath]. If the
  /// loading fails, the [_imageShape] remains as the placeholder if it was provided.
  Future<void> load() async {
    try {
      final data = await rootBundle.load(imagePath);
      final completer = Completer<ui.Image>();
      ui.decodeImageFromList(Uint8List.view(data.buffer), completer.complete);
      _imageShape = ImageShape(await completer.future);
    } catch (e) {
      // If loading fails, keep using the placeholder image
    }
  }

  @override
  ({ui.Image image, ui.Rect rect, ui.RSTransform transform, ui.Color color})? computeTransformation(
      Particle particle,
      ui.Image defaultShapes,
      ) {
    final imageShape = _imageShape;
    if (imageShape == null) {
      return null;
    }
    return imageShape.computeTransformation(particle, defaultShapes);
  }

  @override
  void dispose() {
    _imageShape?.dispose();
  }
}

/// Represents a square shape for rendering particles.
///
/// This class calculates the transformation needed to render particles as squares
/// using the default sprite size.
class SquareShape extends Shape {
  @override
  ({ui.Image image, ui.Rect rect, ui.RSTransform transform, ui.Color color})? computeTransformation(
    Particle particle,
    ui.Image defaultShapes,
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
    return (image: defaultShapes, rect: rect, transform: transform, color: color);
  }

  @override
  void dispose() {}
}
