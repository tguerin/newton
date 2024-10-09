import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

/// The `Particle` class represents a single particle in the animation.
///
/// The `Particle` class holds information about the particle's configuration, position, size,
/// and appearance. It is responsible for drawing the particle on the canvas using the provided
/// `configuration` and applying any transformations specified by the `rotation`.
class Particle {
  /// Creates a `Particle` with the specified configuration and position.
  ///
  /// The `configuration` parameter is required and represents the particle's configuration, defining
  /// its shape, size, and color.
  ///
  /// The `position` parameter is required and represents the initial relative position of the particle on the canvas.
  /// The position is placed from top left Offset(0, 0) of the canvas.
  ///
  /// The `rotation` parameter is optional and represents the rotation of the particle expressed in degrees
  Particle({
    required ParticleConfiguration configuration,
    required this.position,
    this.rotation = 0,
  })  : size = configuration.size,
        initialPosition = position,
        initialSize = configuration.size,
        initialColor = configuration.color,
        postEffectBuilder = configuration.postEffectBuilder {
    shape = configuration.shapeBuilder?.call(initialPosition) ?? configuration.shape!;
    _color = configuration.color.computeColor(0);
    _zIndex = configuration.zIndexBuilder?.call(initialPosition) ?? 0;
  }

  /// The initial position of the particle when it was created.
  final Offset initialPosition;

  /// The initial size of the particle as defined in its configuration.
  final Size initialSize;

  /// The initial color of the particle as defined in its configuration.
  final ParticleColor initialColor;

  /// The shape of the particle as defined in its configuration.
  late final Shape shape;

  /// Effect to trigger once particle travel is over.
  final PostEffectBuilder? postEffectBuilder;

  /// The current position of the particle relative to the top left of the canvas.
  Offset position;

  /// The rotation in degrees of the particle
  double rotation;

  /// The current size of the particle.
  Size size;

  Color _color = Colors.black;

  late final int _zIndex;

  /// The z-index of the particle, used during painting to determine the order in which particles are rendered.
  int get zIndex => _zIndex;

  /// The current color of the particle
  ///
  /// Use [updateColor] and [updateOpacity] to adjust the color of the particle
  Color get color => _color;

  /// Computes the transformation for rendering the image using the particle state.
  ///
  /// Returns the computed transformation for rendering the image with the current particle state.
  ({ui.Image image, ui.Rect rect, ui.RSTransform transform, ui.Color color, ui.BlendMode? blendMode})?
      computeTransformation(
    ui.Image defaultShapes,
  ) {
    return shape.computeTransformation(this, defaultShapes);
  }

  /// Update the `color` of the particle.
  ///
  /// The `updateColor` will adjust the color of the particle according to the current progress of the effect.
  /// If progress is outside the range [0,1] it will be clamped to the nearest value.
  void updateColor(double progress) {
    _color = initialColor.computeColor(progress.clamp(0, 1));
  }

  /// Update the `opacity` of the particle.
  ///
  /// The `updateOpacity` will adjust the opacity accordingly.
  /// If opacity is outside the range [0,1] it will be clamped to the nearest value.
  void updateOpacity(double opacity) {
    _color = _color.withOpacity(opacity.clamp(0, 1));
  }
}
