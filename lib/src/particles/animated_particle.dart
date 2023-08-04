import 'package:flutter/animation.dart';
import 'package:newton_particles/newton_particles.dart';

/// The `AnimatedParticle` class represents a particle with animation properties.
///
/// The `AnimatedParticle` class combines a [Particle] with animation-specific properties,
/// such as animation duration, distance, angle, fading in/out effects, scaling, and more.
class AnimatedParticle {
  /// The [Particle] associated with this animated particle.
  final Particle particle;

  /// The [PathTransformation] that will follow particle upon emission. Default: [StraightPathTransformation]
  final PathTransformation pathTransformation;

  /// The duration of the animation for this particle in milliseconds.
  final int animationDuration;

  /// The start time of the animation for this particle in milliseconds.
  final double startTime;

  /// The curve used to control the distance animation progress.
  final Curve distanceCurve;

  /// The threshold at which the particle starts to fade out during the animation.
  final double fadeOutThreshold;

  /// The curve used to control the fade-out animation progress.
  final Curve fadeOutCurve;

  /// The limit at which the particle starts to fade in during the animation.
  final double fadeInLimit;

  /// The curve used to control the fade-in animation progress.
  final Curve fadeInCurve;

  /// The range of scaling applied to the particle during the animation.
  final Tween<double> scaleRange;

  /// The curve used to control the scaling animation progress.
  final Curve scaleCurve;

  AnimatedParticle({
    required this.particle,
    required this.pathTransformation,
    required this.startTime,
    required this.animationDuration,
    required this.distanceCurve,
    required this.fadeInLimit,
    required this.fadeInCurve,
    required this.fadeOutThreshold,
    required this.fadeOutCurve,
    required this.scaleRange,
    required this.scaleCurve,
  });

  /// Called when the animation updates to apply transformations and positioning to the particle.
  ///
  /// The `progress` parameter represents the animation progress in a range from 0.0 to 1.0.
  /// Based on the progress, the particle's opacity, size, and position will be updated
  /// according to the specified animation properties.
  onAnimationUpdate(double progress) {
    particle.updateColor(progress);
    if (progress <= fadeInLimit && fadeInLimit != 0) {
      final fadeInProgress = progress / fadeInLimit;
      final opacity = fadeInCurve.transform(fadeInProgress);
      particle.updateOpacity(opacity);
    }

    if (progress >= fadeOutThreshold && fadeOutThreshold != 1) {
      var fadeOutProgress =
          (progress - fadeOutThreshold) / (1 - fadeOutThreshold);
      final opacity = 1 - fadeOutCurve.transform(fadeOutProgress);
      particle.updateOpacity(opacity);
    }

    final currentScale = scaleRange.transform(scaleCurve.transform(progress));
    particle.size = Size(
      particle.initialSize.width * currentScale,
      particle.initialSize.height * currentScale,
    );

    var distanceProgress = distanceCurve.transform(progress);
    particle.position = pathTransformation.transform(
      particle.initialPosition,
      distanceProgress,
    );
  }

  /// Called when the surface size changes to adjust the particle's position if needed.
  ///
  /// The `oldSize` parameter represents the previous size of the surface.
  /// The `newSize` parameter represents the new size of the surface.
  onSurfaceSizeChanged(Size oldSize, Size newSize) {}
}
