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
  /// - [animationDuration]: The duration of the animation for this particle.
  /// - [elapsedTimeOnStart]: The total elapsed time when the particle was emitted, used to track animation progress.
  /// - [fadeInCurve]: The curve controlling the fade-in animation progress.
  /// - [fadeInThreshold]: The progress threshold where the particle starts fading in (0.0 to 1.0).
  /// - [fadeOutCurve]: The curve controlling the fade-out animation progress.
  /// - [fadeOutThreshold]: The progress threshold where the particle starts fading out (0.0 to 1.0).
  /// - [particle]: The [Particle] instance associated with this animated particle, containing its visual and positional properties.
  /// - [scaleCurve]: The curve controlling the scaling animation progress.
  /// - [scaleRange]: The range of scaling applied to the particle during the animation.
  /// - [trail]: The trail effect associated with the particle, adding visual effects that follow the particle's movement.
  AnimatedParticle({
    required this.animationDuration,
    required this.elapsedTimeOnStart,
    required this.fadeInCurve,
    required this.fadeInThreshold,
    required this.fadeOutCurve,
    required this.fadeOutThreshold,
    required this.foreground,
    required this.particle,
    required this.scaleCurve,
    required this.scaleRange,
    required this.trail,
  });

  /// The duration of the animation for this particle.
  final Duration animationDuration;

  /// The total elapsed time when the particle was emitted.
  ///
  /// This is used to calculate the progress of the particle's animation relative to its lifespan.
  final Duration elapsedTimeOnStart;

  /// The curve used to control the fade-in animation progress.
  ///
  /// This curve determines how the particle's opacity increases from 0 to full opacity as it fades in.
  final Curve fadeInCurve;

  /// The progress threshold at which the particle starts to fade in during the animation.
  ///
  /// This value is between 0.0 and 1.0, where 0.0 represents the start of the animation and 1.0 represents the end.
  final double fadeInThreshold;

  /// The curve used to control the fade-out animation progress.
  ///
  /// This curve determines how the particle's opacity decreases from full opacity to 0 as it fades out.
  final Curve fadeOutCurve;

  /// The progress threshold at which the particle starts to fade out during the animation.
  ///
  /// This value is between 0.0 and 1.0, where 0.0 represents the start of the animation and 1.0 represents the end.
  final double fadeOutThreshold;

  /// Should this particle be displayed in the foreground layer?
  ///
  /// True to display the particle in the foreground, false otherwise.
  final bool foreground;

  /// The [Particle] associated with this animated particle.
  ///
  /// This object holds the visual and positional properties of the particle, such as color, size, and position.
  final Particle particle;

  /// The curve used to control the scaling animation progress.
  ///
  /// This curve determines how the particle's size changes over the course of the animation.
  final Curve scaleCurve;

  /// The range of scaling applied to the particle during the animation.
  ///
  /// This [Tween] defines the minimum and maximum scale that the particle can reach during the animation.
  final Tween<double> scaleRange;

  /// The trail effect associated with the particle.
  ///
  /// This [Trail] adds visual effects that follow the particle's movement, such as a fading path.
  final Trail trail;

  /// The current progress of the particle's animation, ranging from 0.0 to 1.0.
  ///
  /// This is calculated based on the elapsed time and animation duration.
  double _currentProgress = 0;

  /// Updates the animation of the particle based on the total elapsed time.
  ///
  /// This method calculates the current progress of the animation and updates the particle's
  /// opacity and size based on the specified fade-in, fade-out, and scaling curves.
  ///
  /// - [totalElapsed]: The total elapsed time since the start of the effect, used to update the particle's state.
  void onAnimationUpdate(Duration totalElapsed) {
    final progress = (totalElapsed.inMilliseconds / animationDuration.inMilliseconds).clamp(0.0, 1.0);
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
  }

  /// Called when the particle is created, allowing for any initialization.
  ///
  /// This method can be overridden to perform actions when the particle is first instantiated.
  void onParticleCreated() {}

  /// Called when the surface size changes to adjust the particle's position if needed.
  ///
  /// This method is useful for adapting the particle's behavior when the size of its container changes.
  ///
  /// - [oldSize]: The previous size of the surface before the change.
  /// - [newSize]: The new size of the surface after the change.
  void onSurfaceSizeChanged(Size oldSize, Size newSize) {}

  /// Draws additional shapes or effects, such as trails, associated with the particle.
  ///
  /// This method is primarily used to render [Trail] effects that follow the particle.
  ///
  /// - [canvas]: The canvas on which to draw the extra effects.
  void drawExtra(Canvas canvas) {
    final currentProgress = _currentProgress;
    trail.draw(canvas, currentProgress, this);
  }
}
