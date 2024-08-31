import 'package:flutter/widgets.dart';
import 'package:newton_particles/newton_particles.dart';

/// The `DeterministicAnimatedParticle` class represents a particle with a deterministic animation path.
///
/// This class extends [AnimatedParticle] and adds the ability to control the particle's movement
/// along a specific path using a custom or predefined [DeterministicPathTransformation].
/// It allows particles to follow precise trajectories with controlled distance animation.
class DeterministicAnimatedParticle extends AnimatedParticle {
  /// Creates an instance of [DeterministicAnimatedParticle] with the specified properties.
  ///
  /// - [distanceCurve]: The curve used to control the distance animation progress.
  /// - [onPathTransformationRequested]: A callback function to define a custom path transformation for the particle.
  /// - [animationDuration]: The duration of the particle's animation. Inherited from [AnimatedParticle].
  /// - [elapsedTimeOnStart]: The total elapsed time when the particle was emitted. Inherited from [AnimatedParticle].
  /// - [fadeInCurve]: The curve controlling the fade-in animation progress. Inherited from [AnimatedParticle].
  /// - [fadeInThreshold]: The progress threshold where the particle starts fading in. Inherited from [AnimatedParticle].
  /// - [fadeOutCurve]: The curve controlling the fade-out animation progress. Inherited from [AnimatedParticle].
  /// - [fadeOutThreshold]: The progress threshold where the particle starts fading out. Inherited from [AnimatedParticle].
  /// - [particle]: The [Particle] instance associated with this animated particle. Inherited from [AnimatedParticle].
  /// - [scaleCurve]: The curve used to control the scaling animation progress. Inherited from [AnimatedParticle].
  /// - [scaleRange]: The range of scaling applied to the particle during the animation. Inherited from [AnimatedParticle].
  /// - [trail]: The trail effect associated with the particle. Inherited from [AnimatedParticle].
  DeterministicAnimatedParticle({
    required this.distanceCurve,
    required this.onPathTransformationRequested,
    required super.animationDuration,
    required super.elapsedTimeOnStart,
    required super.fadeInCurve,
    required super.fadeInThreshold,
    required super.fadeOutCurve,
    required super.fadeOutThreshold,
    required super.foreground,
    required super.particle,
    required super.scaleCurve,
    required super.scaleRange,
    required super.trail,
  });

  /// The curve used to control the distance animation progress.
  ///
  /// This curve determines how the particle progresses along its path over time.
  final Curve distanceCurve;

  /// The [DeterministicPathTransformation] that the particle will follow upon emission.
  ///
  /// This property is set when the particle is created and defines how the particle's
  /// position is updated during the animation. The default is [StraightPathTransformation],
  /// but it can be customized via [onPathTransformationRequested].
  late DeterministicPathTransformation _pathTransformation;

  /// A callback that provides a custom path transformation for the particle.
  ///
  /// This function is called when the particle is created, allowing you to define a
  /// custom path for the particle to follow. The function takes the particle as a parameter
  /// and returns the corresponding [DeterministicPathTransformation].
  final DeterministicPathTransformation Function(DeterministicAnimatedParticle) onPathTransformationRequested;

  /// Called when the particle is created, initializing the path transformation.
  ///
  /// This method sets the [DeterministicPathTransformation] using the [onPathTransformationRequested] callback,
  /// allowing the particle to follow the defined path throughout its animation.
  @override
  void onParticleCreated() {
    super.onParticleCreated();
    _pathTransformation = onPathTransformationRequested(this);
  }

  /// Updates the animation of the particle, moving it along its path.
  ///
  /// This method calculates the current progress of the animation and uses the
  /// [distanceCurve] to determine the particle's position along the [DeterministicPathTransformation].
  ///
  /// - [totalElapsed]: The total elapsed time since the start of the effect, used to update the particle's state.
  @override
  void onAnimationUpdate(Duration totalElapsed) {
    super.onAnimationUpdate(totalElapsed);
    final progress = (totalElapsed.inMilliseconds / animationDuration.inMilliseconds).clamp(0.0, 1.0);
    final distanceProgress = distanceCurve.transform(progress);
    particle.position = _pathTransformation.positionFor(
      particle,
      distanceProgress,
    );
  }

  /// Calculates the position of the particle based on the given progress.
  ///
  /// This method provides the position of the particle at a specific point in its animation.
  /// It uses the [DeterministicPathTransformation] to determine where the particle should be.
  ///
  /// - [progress]: The progress of the animation, ranging from 0.0 to 1.0.
  ///
  /// Returns the [Offset] representing the particle's position at the given progress.
  Offset positionFor(double progress) => _pathTransformation.positionFor(particle, progress);
}
