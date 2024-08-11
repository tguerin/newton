import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:newton_particles/newton_particles.dart';

/// The `AnimatedParticle` class represents a particle with animation properties.
///
/// This class combines a [Particle] with various animation properties, enabling
/// complex visual effects such as movement along a path, scaling, fading, and more.
/// It allows particles to be animated with customizable properties for enhanced visual
/// presentation in particle systems.
class AnimatedParticle {
  /// Creates an instance of [AnimatedParticle] with the specified properties.
  ///
  /// - [animationDuration]: The duration of the animation.
  /// - [distanceCurve]: The curve controlling distance animation progress.
  /// - [elapsedTimeOnStart]: Total elapsed duration when particle was emitted.
  /// - [fadeInCurve]: The curve controlling fade-in animation progress.
  /// - [fadeInThreshold]: The threshold where the particle starts fading in.
  /// - [fadeOutCurve]: The curve controlling fade-out animation progress.
  /// - [fadeOutThreshold]: The threshold where the particle starts fading out.
  /// - [particle]: The [Particle] instance associated with this animated particle.
  /// - [pathTransformation]: The path transformation the particle follows upon emission.
  /// - [scaleCurve]: The curve controlling scaling animation progress.
  /// - [scaleRange]: The range of scaling applied during the animation.
  /// - [trail]: The trail effect associated with the particle.
  AnimatedParticle({
    required this.animationDuration,
    required this.distanceCurve,
    required this.elapsedTimeOnStart,
    required this.fadeInCurve,
    required this.fadeInThreshold,
    required this.fadeOutCurve,
    required this.fadeOutThreshold,
    required this.particle,
    required this.pathTransformation,
    required this.scaleCurve,
    required this.scaleRange,
    required this.trail,
  });

  /// The duration of the animation for this particle.
  final Duration animationDuration;

  /// The curve used to control the distance animation progress.
  final Curve distanceCurve;

  /// Total elapsed duration when particle was emitted.
  final Duration elapsedTimeOnStart;

  /// The curve used to control the fade-in animation progress.
  final Curve fadeInCurve;

  /// The threshold at which the particle starts to fade in during the animation.
  final double fadeInThreshold;

  /// The curve used to control the fade-out animation progress.
  final Curve fadeOutCurve;

  /// The threshold at which the particle starts to fade out during the animation.
  final double fadeOutThreshold;

  /// The [Particle] associated with this animated particle.
  final Particle particle;

  /// The [PathTransformation] that the particle will follow upon emission.
  /// Default: [StraightPathTransformation].
  final PathTransformation pathTransformation;

  /// The curve used to control the scaling animation progress.
  final Curve scaleCurve;

  /// The range of scaling applied to the particle during the animation.
  final Tween<double> scaleRange;

  /// The trail effect associated with the particle.
  final Trail trail;

  /// The current progress of the animation, used internally.
  double _currentProgress = 0;

  /// Called when the animation updates to apply transformations and positioning to the particle.
  ///
  /// The `progress` parameter represents the animation progress in a range from 0.0 to 1.0.
  /// Based on the progress, the particle's opacity, size, and position will be updated
  /// according to the specified animation properties.
  void onAnimationUpdate(double progress) {
    _currentProgress = progress;
    particle.updateColor(progress);

    if (progress <= fadeInThreshold && fadeInThreshold != 0) {
      final fadeInProgress = progress / fadeInThreshold;
      final opacity = fadeInCurve.transform(fadeInProgress);
      particle.updateOpacity(opacity);
    }

    if (progress >= fadeOutThreshold && fadeOutThreshold != 1) {
      final fadeOutProgress = (progress - fadeOutThreshold) / (1 - fadeOutThreshold);
      final opacity = 1 - fadeOutCurve.transform(fadeOutProgress);
      particle.updateOpacity(opacity);
    }

    final currentScale = scaleRange.transform(scaleCurve.transform(progress));
    particle.size = Size(
      particle.initialSize.width * currentScale,
      particle.initialSize.height * currentScale,
    );

    final distanceProgress = distanceCurve.transform(progress);
    particle.position = pathTransformation.transform(
      particle.initialPosition,
      distanceProgress,
    );
  }

  /// Called when the surface size changes to adjust the particle's position if needed.
  ///
  /// The `oldSize` parameter represents the previous size of the surface.
  /// The `newSize` parameter represents the new size of the surface.
  void onSurfaceSizeChanged(Size oldSize, Size newSize) {}

  /// Draws additional shapes or effects, such as trails, associated with the particle.
  ///
  /// This method is primarily used to render [Trail] effects.
  void drawExtra(Canvas canvas) {
    trail.draw(canvas, _currentProgress, this);
  }
}
