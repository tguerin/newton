import 'dart:ui';

import 'package:newton_particles/newton_particles.dart';
import 'package:vector_math/vector_math_64.dart';

/// The `Particle` class represents a single particle in the animation.
///
/// The `Particle` class holds information about the particle's configuration, position, size,
/// and appearance. It is responsible for drawing the particle on the canvas using the provided
/// `configuration` and applying any transformations specified by the `rotation`.
class Particle {
  /// The configuration of the particle, defining its shape, size, and color.
  final ParticleConfiguration configuration;

  /// The transformation matrix for the particle's rotation.
  final Matrix4 _transform = Matrix4.identity();

  /// The paint used to style the particle when drawn on the canvas.
  final Paint paint = Paint();

  /// The initial position of the particle when it was created.
  final Offset initialPosition;

  /// The current position of the particle.
  Offset position;

  /// The current size of the particle.
  Size size;

  /// Creates a `Particle` with the specified configuration and position.
  ///
  /// The `configuration` parameter is required and represents the particle's configuration, defining
  /// its shape, size, and color.
  ///
  /// The `position` parameter is required and represents the initial position of the particle on the canvas.
  ///
  /// The `rotation` parameter is optional and represents the rotation of the particle as a `Vector2` of
  /// rotation angles in degrees. If provided, the particle will be rotated based on the `x` and `y` angles
  /// specified in the `rotation` vector.
  Particle({
    required this.configuration,
    required this.position,
    Vector2? rotation,
  })  : size = configuration.size,
        initialPosition = position {
    if (rotation != null) {
      _transform.setRotationX(radians(rotation.x));
      _transform.setRotationY(radians(rotation.y));
    }
    configuration.color.configure(0.0, this);
  }

  /// Gets the initial size of the particle as defined in its configuration.
  Size get initialSize => configuration.size;

  /// Update the `color` of the particle.
  ///
  /// The `updateColor` will adjust the color of the particle according to the current progress of the effect.
  /// If progress is outside the range [0,1] it will be clamped to the nearest value.
  updateColor(double progress) {
    configuration.color.configure(progress.clamp(0, 1), this);
  }

  /// Update the `opacity` of the particle.
  ///
  /// The `updateOpacity` will adjust the opacity accordingly.
  /// If opacity is outside the range [0,1] it will be clamped to the nearest value.
  void updateOpacity(double opacity) {
    paint.color = paint.color.withOpacity(opacity.clamp(0, 1));
  }

  /// Draws the particle on the given `canvas`.
  ///
  /// The `draw` method uses the particle's `configuration` and `paint` to draw the particle's shape
  /// at its current `position` and `size` on the canvas. Any specified transformations are applied
  /// using the `_transform` matrix before drawing the particle.
  draw(Canvas canvas) => configuration.shape.draw(
        canvas,
        position,
        size,
        _transform,
        paint,
      );
}
