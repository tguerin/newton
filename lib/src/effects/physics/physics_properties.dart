import 'package:flutter/foundation.dart';
import 'package:newton_particles/newton_particles.dart';

/// Groups all physics-related properties for particle effects.
///
/// This class encapsulates density, friction, restitution, velocity, and angle ranges, and gravity
/// with comprehensive validations to ensure all values are within acceptable ranges.
///
/// Example usage:
///
/// ```dart
/// final properties = PhysicsProperties(
///   density: NumRange.between(Density.defaultDensity, Density.defaultDensity),
///   friction: NumRange.between(Friction.ice, Friction.rubber),
///   restitution: NumRange.between(Restitution.rubberBall, Restitution.basketball),
///   velocity: NumRange.between(Velocity.rainDrop, Velocity.car),
///   angle: NumRange.between(0, 360),
///   gravity: Gravity.earthGravity,
/// );
/// ```
@immutable
class PhysicsProperties {
  /// Creates a [PhysicsProperties] instance with the specified physics properties.
  ///
  /// All ranges must have valid min/max values, and individual properties must
  /// satisfy their constraints:
  /// - Restitution: 0.0 to 1.2 (noBounce to flubber)
  /// - Friction: >= 0.0
  /// - Density: > 0.0
  /// - Velocity: >= 0.0 (negative values allowed for special effects)
  /// - Angle: -180.0 to 180.0 degrees (or 0.0 to 360.0)
  const PhysicsProperties({
    this.density = const NumRange.between(Density.defaultDensity, Density.defaultDensity),
    this.friction = const NumRange.between(Friction.ice, Friction.ice),
    this.restitution = const NumRange.between(Restitution.rubberBall, Restitution.rubberBall),
    this.velocity = const NumRange.between(Velocity.rainDrop, Velocity.rainDrop),
    this.angle = const NumRange.single(0),
    this.gravity = Gravity.earthGravity,
    this.onlyInteractWithEdges = false,
    this.solidEdges = const SolidEdges.all(),
  });

  /// Creates a low-friction [PhysicsProperties] for slippery effects.
  ///
  /// Defaults:
  /// - Density: defaultDensity
  /// - Friction: ice to teflon (very low friction)
  /// - Restitution: rubberBall (moderate bounce)
  /// - Velocity: rainDrop to highway (moderate to high speed)
  /// - Angle: 0 (straight)
  /// - Gravity: earthGravity
  ///
  /// All parameters are optional and can be overridden.
  factory PhysicsProperties.slippery({
    NumRange<Density>? density,
    NumRange<Friction>? friction,
    NumRange<Restitution>? restitution,
    NumRange<Velocity>? velocity,
    NumRange<double>? angle,
    Gravity? gravity,
    bool? onlyInteractWithEdges,
    SolidEdges? solidEdges,
  }) {
    return PhysicsProperties(
      density: density ?? const NumRange.between(Density.defaultDensity, Density.defaultDensity),
      friction: friction ?? const NumRange.between(Friction.ice, Friction.teflon),
      restitution: restitution ?? const NumRange.between(Restitution.rubberBall, Restitution.rubberBall),
      velocity: velocity ?? const NumRange.between(Velocity.rainDrop, Velocity.highway),
      angle: angle ?? const NumRange.single(0),
      gravity: gravity ?? Gravity.earthGravity,
      onlyInteractWithEdges: onlyInteractWithEdges ?? false,
      solidEdges: solidEdges ?? const SolidEdges.all(),
    );
  }

  /// Creates a bouncy [PhysicsProperties] with high restitution.
  ///
  /// Defaults:
  /// - Density: defaultDensity
  /// - Friction: ice (low friction for more bounce)
  /// - Restitution: basketball to superBall (high bounce)
  /// - Velocity: rainDrop to car (moderate to high speed)
  /// - Angle: 0 (straight)
  /// - Gravity: earthGravity
  ///
  /// All parameters are optional and can be overridden.
  factory PhysicsProperties.bouncy({
    NumRange<Density>? density,
    NumRange<Friction>? friction,
    NumRange<Restitution>? restitution,
    NumRange<Velocity>? velocity,
    NumRange<double>? angle,
    Gravity? gravity,
    bool? onlyInteractWithEdges,
    SolidEdges? solidEdges,
  }) {
    return PhysicsProperties(
      density: density ?? const NumRange.between(Density.defaultDensity, Density.defaultDensity),
      friction: friction ?? const NumRange.between(Friction.ice, Friction.ice),
      restitution: restitution ?? const NumRange.between(Restitution.basketball, Restitution.superBall),
      velocity: velocity ?? const NumRange.between(Velocity.rainDrop, Velocity.car),
      angle: angle ?? const NumRange.single(0),
      gravity: gravity ?? Gravity.earthGravity,
      onlyInteractWithEdges: onlyInteractWithEdges ?? false,
      solidEdges: solidEdges ?? const SolidEdges.all(),
    );
  }

  /// The density range for particles.
  final NumRange<double> density;

  /// The friction range for particles.
  final NumRange<double> friction;

  /// The restitution (bounciness) range for particles.
  final NumRange<double> restitution;

  /// The velocity range for particles.
  final NumRange<double> velocity;

  /// The angle range for particles in degrees.
  final NumRange<double> angle;

  /// The gravitational force applied to particles.
  final Gravity gravity;

  /// Whether the particles should interact only with the edges of the container.
  final bool onlyInteractWithEdges;

  /// Specifies which edges of the container are hard (solid) boundaries.
  final SolidEdges solidEdges;

  /// Generates a random density within the specified range.
  Density randomDensity() {
    return Density.custom(density.random());
  }

  /// Generates a random friction coefficient within the specified range.
  Friction randomFriction() {
    return Friction.custom(friction.random());
  }

  /// Generates a random restitution (bounciness) within the specified range.
  Restitution randomRestitution() {
    return Restitution.custom(restitution.random());
  }

  /// Generates a random velocity within the specified range.
  Velocity randomVelocity() {
    return Velocity.custom(velocity.random());
  }

  /// Generates a random angle within the specified range.
  double randomAngle() {
    return angle.random();
  }

  /// Creates a copy of this [PhysicsProperties] with the given fields replaced with new values.
  PhysicsProperties copyWith({
    NumRange<double>? density,
    NumRange<double>? friction,
    NumRange<double>? restitution,
    NumRange<double>? velocity,
    NumRange<double>? angle,
    Gravity? gravity,
    bool? onlyInteractWithEdges,
    SolidEdges? solidEdges,
  }) {
    return PhysicsProperties(
      density: density ?? this.density,
      friction: friction ?? this.friction,
      restitution: restitution ?? this.restitution,
      velocity: velocity ?? this.velocity,
      angle: angle ?? this.angle,
      gravity: gravity ?? this.gravity,
      onlyInteractWithEdges: onlyInteractWithEdges ?? this.onlyInteractWithEdges,
      solidEdges: solidEdges ?? this.solidEdges,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhysicsProperties &&
          runtimeType == other.runtimeType &&
          density == other.density &&
          friction == other.friction &&
          restitution == other.restitution &&
          velocity == other.velocity &&
          angle == other.angle &&
          gravity == other.gravity &&
          onlyInteractWithEdges == other.onlyInteractWithEdges &&
          solidEdges == other.solidEdges;

  @override
  int get hashCode =>
      density.hashCode ^
      friction.hashCode ^
      restitution.hashCode ^
      velocity.hashCode ^
      angle.hashCode ^
      gravity.hashCode ^
      onlyInteractWithEdges.hashCode ^
      solidEdges.hashCode;

  @override
  String toString() =>
      'PhysicsProperties(density: $density, friction: $friction, restitution: $restitution, velocity: $velocity, angle: $angle, gravity: $gravity, onlyInteractWithEdges: $onlyInteractWithEdges, solidEdges: $solidEdges)';
}
