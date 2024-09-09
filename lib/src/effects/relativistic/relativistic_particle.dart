import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/effects/relativistic/path.dart';

/// The `RelativisticParticle` class represents a particle that is influenced by relativistic effects
/// within a particle system.
///
/// This class extends `AnimatedParticle` and adds properties that allow for the simulation of
/// physical attributes such as angle, density, friction, restitution, and velocity. Additionally,
/// it incorporates a `RelativisticPathTransformation` that dictates how the particle's position
/// is transformed over time based on relativistic principles.
class RelativisticParticle extends AnimatedParticle {
  /// Creates a `RelativisticParticle` with the specified properties.
  ///
  /// - [angle]: The initial angle of the particle in degrees.
  /// - [density]: The density of the particle, affecting its mass and behavior in the system.
  /// - [friction]: The friction coefficient applied to the particle, affecting its resistance to motion.
  /// - [pathTransformation]: The transformation applied to the particle's path based on relativistic effects.
  /// - [restitution]: The restitution (bounciness) of the particle when it collides with other objects.
  /// - [velocity]: The velocity of the particle, determining its speed and direction.
  /// - [onlyInteractWithEdges]: A boolean that indicates whether the particle should only interact with the edges of the container.
  /// - [animationDuration]: The total duration of the particle's animation.
  /// - [elapsedTimeOnStart]: The elapsed time when the animation starts, useful for synchronizing multiple particles.
  /// - [fadeInCurve]: The curve that defines how the particle fades in.
  /// - [fadeInThreshold]: The threshold at which the particle starts to fade in.
  /// - [fadeOutCurve]: The curve that defines how the particle fades out.
  /// - [fadeOutThreshold]: The threshold at which the particle starts to fade out.
  /// - [foreground]: A boolean indicating whether the particle is rendered in the foreground.
  /// - [particle]: The underlying visual representation of the particle.
  /// - [scaleCurve]: The curve that defines the particle's scaling over time.
  /// - [scaleRange]: The range of scaling applied to the particle.
  /// - [trail]: An optional trail effect that follows the particle's movement.
  RelativisticParticle({
    required this.angle,
    required this.density,
    required this.friction,
    required this.pathTransformation,
    required this.restitution,
    required this.velocity,
    required this.onlyInteractWithEdges,
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

  /// The initial angle of the particle, expressed in degrees.
  final double angle;

  /// The friction coefficient applied to the particle, affecting its resistance to motion.
  final Friction friction;

  /// The density of the particle, which influences its mass and how it interacts with forces within the system.
  final Density density;

  /// Determines whether the particle should only interact with the edges of the container.
  final bool onlyInteractWithEdges;

  /// The restitution or bounciness of the particle, determining how it reacts upon collision.
  final Restitution restitution;

  /// The velocity of the particle, defining its speed and direction.
  final Velocity velocity;

  /// The transformation that dictates how the particle's position changes over time, based on relativistic effects.
  final RelativisticPathTransformation pathTransformation;

  /// Updates the particle's animation based on the total elapsed time.
  ///
  /// This method is called periodically during the animation to update the particle's state.
  /// It applies the `RelativisticPathTransformation` to adjust the particle's position according
  /// to the current simulation state.
  ///
  /// - [totalElapsed]: The total elapsed time since the start of the animation.
  @override
  void onAnimationUpdate(Duration totalElapsed) {
    super.onAnimationUpdate(totalElapsed);
    pathTransformation.transform(this);
  }
}
