import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

/// The `Particle` class represents a single particle in the animation.
///
/// The `Particle` class holds information about the particle's configuration, position, size,
/// and appearance. It is responsible for drawing the particle on the canvas using the provided
/// `configuration` and applying any transformations specified by the `rotation`.
class Particle {
  /// The configuration of the particle, defining its shape, size, and color.
  final ParticleConfiguration configuration;

  /// The initial position of the particle when it was created.
  final Offset initialPosition;

  /// The current position of the particle.
  Offset position;

  /// The current size of the particle.
  Size size;

  /// The rotation in degrees of the particle
  double rotation;

  Color _color = Colors.black;

  /// The current color of the particle
  ///
  /// Use [updateColor] and [updateOpacity] to adjust the color of the particle
  Color get color => _color;

  /// Creates a `Particle` with the specified configuration and position.
  ///
  /// The `configuration` parameter is required and represents the particle's configuration, defining
  /// its shape, size, and color.
  ///
  /// The `position` parameter is required and represents the initial position of the particle on the canvas.
  ///
  /// The `rotation` parameter is optional and represents the rotation of the particle expressed in degrees
  Particle({
    required this.configuration,
    required this.position,
    this.rotation = 0,
  })  : size = configuration.size,
        initialPosition = position {
    _color = configuration.color.computeColor(0.0);
  }

  /// Gets the initial size of the particle as defined in its configuration.
  Size get initialSize => configuration.size;

  /// Update the `color` of the particle.
  ///
  /// The `updateColor` will adjust the color of the particle according to the current progress of the effect.
  /// If progress is outside the range [0,1] it will be clamped to the nearest value.
  updateColor(double progress) {
    _color = configuration.color.computeColor(progress.clamp(0, 1));
  }

  /// Update the `opacity` of the particle.
  ///
  /// The `updateOpacity` will adjust the opacity accordingly.
  /// If opacity is outside the range [0,1] it will be clamped to the nearest value.
  void updateOpacity(double opacity) {
    _color = _color.withOpacity(opacity.clamp(0, 1));
  }


  /// Computes the transformation for rendering the image using the particle state.
  ///
  /// Returns the computed transformation for rendering the image with the current particle state.
  (ui.Image, ui.Rect, ui.RSTransform, ui.Color) computeTransformation(
      ui.Image defaultShapes) {
    return configuration.shape.computeTransformation(this, defaultShapes);
  }
}
