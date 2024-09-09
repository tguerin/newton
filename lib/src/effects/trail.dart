import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

/// A sealed class representing a trail of particles to be drawn on a canvas.
///
/// This class defines the common properties and methods required for a trail.
/// Subclasses should override the [draw] method to implement their specific
/// drawing logic.
sealed class Trail {
  /// Creates a [Trail] with the given [trailProgress].
  ///
  /// The [trailProgress] defaults to 0 if not specified.
  const Trail({this.trailProgress = 0});

  /// The progress of the trail, typically a value between 0 and 1.
  ///
  /// `trailProgress` indicates how far back in time the trail should be drawn
  /// relative to the current position of the particle.
  final double trailProgress;

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
  /// Creates an instance of [NoTrail] with no visible effect.
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
/// particle position to the current position of the [AnimatedParticle].
class StraightTrail extends Trail {
  /// Creates a [StraightTrail] with the specified [trailProgress] and [trailWidth].
  ///
  /// - [trailProgress]: The progress indicating how far back the trail should be drawn.
  /// - [trailWidth]: The width of the trail line.
  const StraightTrail({
    required super.trailProgress,
    required this.trailWidth,
  });

  /// The width of the trail line.
  final double trailWidth;

  @override
  void draw(
    Canvas canvas,
    double currentProgress,
    AnimatedParticle animatedParticle,
  ) {
    if (animatedParticle is! DeterministicAnimatedParticle) return;
    final endTrailProgress = (currentProgress - trailProgress).clamp(0.0, 1.0);
    final endTrailAdjustedProgress = animatedParticle.distanceCurve.transform(endTrailProgress);
    final endTrailPosition = animatedParticle.positionFor(endTrailAdjustedProgress);

    final trailPaint = Paint()
      ..shader = ui.Gradient.linear(
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
      )
      ..strokeCap = StrokeCap.round
      ..strokeWidth = trailWidth;

    canvas.drawLine(
      endTrailPosition,
      animatedParticle.particle.position,
      trailPaint,
    );
  }
}
