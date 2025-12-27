import 'package:flutter/widgets.dart' hide Velocity;
import 'package:newton_particles/newton_particles.dart';

/// The `PhysicsEffectConfiguration` class extends `EffectConfiguration` to add
/// additional properties for simulating physics-based effects in a particle system.
///
/// This class allows you to configure various properties such as gravity, hard edges, density,
/// friction, restitution, and velocity, with options for both minimum and maximum values.
/// It also provides a mechanism to override the configuration dynamically via a callback.
///
/// Example usage:
///
/// ```dart
/// final config = PhysicsEffectConfiguration(
///   gravity: Gravity.earthGravity,
///   particleConfiguration: ParticleConfiguration(...),
/// );
/// ```
@immutable
class PhysicsEffectConfiguration extends EffectConfiguration {
  /// Creates an instance of [PhysicsEffectConfiguration] with customizable parameters
  /// for simulating particle physics.
  ///
  /// This configuration adds properties like gravity, velocity, and material characteristics such as friction and restitution,
  /// which impact how particles behave under simulated physical laws.
  ///
  /// - [gravity]: The gravitational force applied to the particles, influencing their motion.
  /// - [particleConfiguration]: General particle configuration inherited from [EffectConfiguration], defining how particles are emitted and animated.
  /// - [configurationOverrider]: A function to dynamically override default particle configurations during runtime.
  /// - [maxDensity]: The maximum density of the particles, affecting their mass and interaction with other particles. Defaults to [Density.defaultDensity].
  /// - [maxFriction]: The maximum friction applied to particles, slowing them down when in contact with surfaces. Defaults to [Friction.ice], representing minimal friction.
  /// - [maxRestitution]: The maximum restitution, controlling how much energy is conserved in particle collisions (elasticity). Defaults to [Restitution.rubberBall], representing a bouncy collision.
  /// - [maxVelocity]: The maximum velocity a particle can reach, which can be limited to simulate realistic speed constraints. Defaults to [Velocity.rainDrop].
  /// - [minDensity]: The minimum density of the particles, determining their resistance to external forces. Defaults to [Density.defaultDensity].
  /// - [minFriction]: The minimum friction applied to particles, which influences their ability to slide across surfaces. Defaults to [Friction.ice].
  /// - [minRestitution]: The minimum restitution for particles, controlling how little energy is conserved in collisions. Defaults to [Restitution.rubberBall].
  /// - [minVelocity]: The minimum velocity a particle can have. Defaults to [Velocity.rainDrop].
  /// - [onlyInteractWithEdges]: If `true`, particles will only interact with the defined edges and not with each other. Defaults to `false`.
  /// - [solidEdges]: Specifies solid boundaries for the particles' movement. By default, it uses [SolidEdges.all()], indicating that particles are constrained by edges on all sides.
  ///
  /// Inherited parameters from [EffectConfiguration]:
  /// - [emitCurve]: Controls the timing of particle emission.
  /// - [emitDuration]: The duration between particle emissions.
  /// - [fadeInCurve]: Controls the fade-in animation for particles.
  /// - [fadeOutCurve]: Controls the fade-out animation for particles.
  /// - [maxAngle]: The maximum angle (in degrees) for the particle trajectory.
  /// - [maxBeginScale]: The maximum initial scale of particles.
  /// - [maxEndScale]: The maximum final scale of particles.
  /// - [maxFadeInThreshold]: The maximum opacity level at which particles will complete fading in.
  /// - [maxFadeOutThreshold]: The maximum opacity level at which particles will start fading out.
  /// - [maxOriginOffset]: The maximum offset for the particle emission origin.
  /// - [maxParticleLifespan]: The maximum time a particle can exist before being removed.
  /// - [minAngle]: The minimum angle (in degrees) for particle trajectory.
  /// - [minBeginScale]: The minimum initial scale of particles.
  /// - [minEndScale]: The minimum final scale of particles.
  /// - [minFadeInThreshold]: The minimum opacity level at which particles will start fading in.
  /// - [minFadeOutThreshold]: The minimum opacity level at which particles will start fading out.
  /// - [minOriginOffset]: The minimum offset for the particle emission origin.
  /// - [minParticleLifespan]: The minimum time a particle can exist before being removed.
  /// - [origin]: The origin point for particle emission, relative to the top-left of the container.
  /// - [particleCount]: The total number of particles that will be emitted over the lifetime of the effect.
  /// - [particlesPerEmit]: The number of particles emitted at each emission event.
  /// - [particleLayer]: The visual layer to which particles belong.
  /// - [scaleCurve]: Controls the scaling of particles over time.
  /// - [startDelay]: The delay before the particle effect starts after initiation.
  /// - [trail]: Specifies any trail effect applied to particles as they move.
  const PhysicsEffectConfiguration({
    required this.gravity,
    required super.particleConfiguration,
    this.configurationOverrider,
    this.maxDensity = Density.defaultDensity,
    this.maxFriction = Friction.ice,
    this.maxRestitution = Restitution.rubberBall,
    this.maxVelocity = Velocity.rainDrop,
    this.minDensity = Density.defaultDensity,
    this.minFriction = Friction.ice,
    this.minRestitution = Restitution.rubberBall,
    this.minVelocity = Velocity.rainDrop,
    this.onlyInteractWithEdges = false,
    this.solidEdges = const SolidEdges.all(),
    super.emitCurve,
    super.emitDuration,
    super.fadeInCurve,
    super.fadeOutCurve,
    super.maxAngle,
    super.maxBeginScale,
    super.maxParticleLifespan,
    super.maxEndScale,
    super.maxFadeInThreshold,
    super.maxFadeOutThreshold,
    super.maxOriginOffset,
    super.minAngle,
    super.minBeginScale,
    super.minEndScale,
    super.minFadeInThreshold,
    super.minFadeOutThreshold,
    super.minOriginOffset,
    super.minParticleLifespan,
    super.origin,
    super.particleCount,
    super.particlesPerEmit,
    super.particleLayer,
    super.scaleCurve,
    super.startDelay,
    super.trail,
  });

  /// A callback function that can override the configuration dynamically.
  final PhysicsEffectConfiguration Function(
    Effect<PhysicsParticle, PhysicsEffectConfiguration>,
  )? configurationOverrider;

  /// The gravitational force applied to the particles.
  final Gravity gravity;

  /// The maximum density of the particles.
  final Density maxDensity;

  /// The maximum friction applied to the particles.
  final Friction maxFriction;

  /// The maximum restitution (bounciness) of the particles.
  final Restitution maxRestitution;

  /// The maximum velocity of the particles.
  final Velocity maxVelocity;

  /// The minimum density of the particles.
  final Density minDensity;

  /// The minimum friction applied to the particles.
  final Friction minFriction;

  /// The minimum restitution (bounciness) of the particles.
  final Restitution minRestitution;

  /// The minimum velocity of the particles.
  final Velocity minVelocity;

  /// Whether the particles should interact only with the edges of the container.
  final bool onlyInteractWithEdges;

  /// Specifies which edges of the container are hard (solid) boundaries.
  final SolidEdges solidEdges;

  @override
  PhysicsEffectConfiguration copyWith({
    PhysicsEffectConfiguration Function(
      Effect<PhysicsParticle, PhysicsEffectConfiguration>,
    )? configurationOverrider,
    Gravity? gravity,
    Density? maxDensity,
    Friction? maxFriction,
    Restitution? maxRestitution,
    Density? minDensity,
    Friction? minFriction,
    Restitution? minRestitution,
    Curve? distanceCurve,
    Curve? emitCurve,
    Duration? emitDuration,
    Curve? fadeInCurve,
    Curve? fadeOutCurve,
    bool? foreground,
    double? maxAngle,
    double? maxBeginScale,
    double? maxDistance,
    double? maxEndScale,
    double? maxFadeInThreshold,
    double? maxFadeOutThreshold,
    Offset? maxOriginOffset,
    Duration? maxParticleLifespan,
    Velocity? maxVelocity,
    double? minAngle,
    double? minBeginScale,
    double? minDistance,
    double? minEndScale,
    double? minFadeInThreshold,
    double? minFadeOutThreshold,
    Offset? minOriginOffset,
    Duration? minParticleLifespan,
    Velocity? minVelocity,
    bool? onlyInteractWithEdges,
    Offset? origin,
    ParticleConfiguration? particleConfiguration,
    ParticleLayer? particleLayer,
    int? particleCount,
    int? particlesPerEmit,
    Curve? scaleCurve,
    SolidEdges? solidEdges,
    Duration? startDelay,
    Trail? trail,
  }) {
    return PhysicsEffectConfiguration(
      configurationOverrider: configurationOverrider ?? this.configurationOverrider,
      gravity: gravity ?? this.gravity,
      maxDensity: maxDensity ?? this.maxDensity,
      maxFriction: maxFriction ?? this.maxFriction,
      maxRestitution: maxRestitution ?? this.maxRestitution,
      maxVelocity: maxVelocity ?? this.maxVelocity,
      minDensity: minDensity ?? this.minDensity,
      minFriction: minFriction ?? this.minFriction,
      minRestitution: minRestitution ?? this.minRestitution,
      particleConfiguration: particleConfiguration ?? this.particleConfiguration,
      emitCurve: emitCurve ?? this.emitCurve,
      emitDuration: emitDuration ?? this.emitDuration,
      fadeInCurve: fadeInCurve ?? this.fadeInCurve,
      fadeOutCurve: fadeOutCurve ?? this.fadeOutCurve,
      maxAngle: maxAngle ?? this.maxAngle,
      maxBeginScale: maxBeginScale ?? this.maxBeginScale,
      maxEndScale: maxEndScale ?? this.maxEndScale,
      maxFadeInThreshold: maxFadeInThreshold ?? this.maxFadeInThreshold,
      maxFadeOutThreshold: maxFadeOutThreshold ?? this.maxFadeOutThreshold,
      maxOriginOffset: maxOriginOffset ?? this.maxOriginOffset,
      maxParticleLifespan: maxParticleLifespan ?? this.maxParticleLifespan,
      minAngle: minAngle ?? this.minAngle,
      minBeginScale: minBeginScale ?? this.minBeginScale,
      minEndScale: minEndScale ?? this.minEndScale,
      minFadeInThreshold: minFadeInThreshold ?? this.minFadeInThreshold,
      minFadeOutThreshold: minFadeOutThreshold ?? this.minFadeOutThreshold,
      minOriginOffset: minOriginOffset ?? this.minOriginOffset,
      minParticleLifespan: minParticleLifespan ?? this.minParticleLifespan,
      minVelocity: minVelocity ?? this.minVelocity,
      onlyInteractWithEdges: onlyInteractWithEdges ?? this.onlyInteractWithEdges,
      origin: origin ?? this.origin,
      particleCount: particleCount ?? this.particleCount,
      particleLayer: particleLayer ?? this.particleLayer,
      particlesPerEmit: particlesPerEmit ?? this.particlesPerEmit,
      scaleCurve: scaleCurve ?? this.scaleCurve,
      solidEdges: solidEdges ?? this.solidEdges,
      startDelay: startDelay ?? this.startDelay,
      trail: trail ?? this.trail,
    );
  }

  /// Generates a random density within the specified range.
  Density randomDensity() {
    return Density.custom(random.nextDoubleRange(minDensity.value, maxDensity.value));
  }

  /// Generates a random friction coefficient within the specified range.
  Friction randomFriction() {
    return Friction.custom(random.nextDoubleRange(minFriction.value, maxFriction.value));
  }

  /// Generates a random restitution (bounciness) within the specified range.
  Restitution randomRestitution() {
    return Restitution.custom(random.nextDoubleRange(minRestitution.value, maxRestitution.value));
  }

  /// Generates a random velocity within the specified range.
  Velocity randomVelocity() {
    return Velocity.custom(random.nextDoubleRange(minVelocity.value, maxVelocity.value));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is PhysicsEffectConfiguration &&
          runtimeType == other.runtimeType &&
          configurationOverrider == other.configurationOverrider &&
          gravity == other.gravity &&
          solidEdges == other.solidEdges &&
          maxDensity == other.maxDensity &&
          maxFriction == other.maxFriction &&
          maxRestitution == other.maxRestitution &&
          maxVelocity == other.maxVelocity &&
          minDensity == other.minDensity &&
          minFriction == other.minFriction &&
          minRestitution == other.minRestitution &&
          minVelocity == other.minVelocity &&
          onlyInteractWithEdges == other.onlyInteractWithEdges;

  @override
  int get hashCode =>
      super.hashCode ^
      configurationOverrider.hashCode ^
      gravity.hashCode ^
      solidEdges.hashCode ^
      maxDensity.hashCode ^
      maxFriction.hashCode ^
      maxRestitution.hashCode ^
      maxVelocity.hashCode ^
      minDensity.hashCode ^
      minFriction.hashCode ^
      minRestitution.hashCode ^
      minVelocity.hashCode ^
      onlyInteractWithEdges.hashCode;
}
