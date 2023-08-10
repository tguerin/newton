import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

/// A sealed class representing a trail of particles to be drawn on a canvas.
///
/// This class defines the common properties and methods required for a trail.
/// Subclasses should override the [draw] method to implement their specific
/// drawing logic.
sealed class Trail {
  /// The progress of the trail, typically a value between 0 and 1.
  /// To clarify, `trailProgress` means how far we want to go back for the trail to be drawn.
  final double trailProgress;

  /// Creates a [Trail] with the given [trailProgress].
  ///
  /// The [trailProgress] defaults to 0 if not specified.
  const Trail({this.trailProgress = 0});

  /// Draws the trail on the [canvas] using the given [currentProgress] and
  /// [animatedParticle].
  ///
  /// Subclasses should implement this method to provide their specific
  /// drawing behavior.
  void draw(
    Canvas canvas,
    double currentProgress,
    AnimatedParticle animatedParticle,
  );
}

/// A subclass of [Trail] representing a trail with no visible drawing.
///
/// This class represents a trail with no specific drawing behavior. When
/// drawn, it does nothing and leaves no visible trail on the canvas.
class NoTrail extends Trail {
  const NoTrail();

  @override
  void draw(
    Canvas canvas,
    double currentProgress,
    AnimatedParticle animatedParticle,
  ) {
    // Nothing to draw
  }
}

/// A subclass of [Trail] representing a straight line trail.
///
/// This class represents a trail that draws a straight line from the initial
/// particle position to the current position of the [animatedParticle].
class StraightTrail extends Trail {
  /// The width of the trail line.
  final double trailWidth;

  const StraightTrail({
    required super.trailProgress,
    required this.trailWidth,
  });

  @override
  void draw(
    Canvas canvas,
    double currentProgress,
    AnimatedParticle animatedParticle,
  ) {
    final endTrailProgress = (currentProgress - trailProgress).clamp(0.0, 1.0);
    final endTrailAdjustedProgress =
        animatedParticle.distanceCurve.transform(endTrailProgress);
    final endTrailPosition = animatedParticle.pathTransformation.transform(
      animatedParticle.particle.initialPosition,
      endTrailAdjustedProgress,
    );

    final trailPaint = Paint();
    trailPaint.shader = ui.Gradient.linear(
      animatedParticle.particle.position,
      endTrailPosition,
      [
        animatedParticle.particle.color,
        Colors.transparent,
      ],
      [
        0.2,
        1.0,
      ],
    );
    trailPaint.strokeCap = StrokeCap.round;
    trailPaint.strokeWidth = trailWidth;

    canvas.drawLine(
      endTrailPosition,
      animatedParticle.particle.position,
      trailPaint,
    );
  }
}
