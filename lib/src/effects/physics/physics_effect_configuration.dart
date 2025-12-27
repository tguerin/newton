import 'package:flutter/widgets.dart' hide Velocity;
import 'package:newton_particles/newton_particles.dart';

/// The `PhysicsEffectConfiguration` class extends `EffectConfiguration` to add
/// additional properties for simulating physics-based effects in a particle system.
///
/// This class allows you to configure various properties such as gravity, hard edges, density,
/// friction, restitution, and velocity using grouped properties for better organization.
///
/// Example usage:
///
/// ```dart
/// final config = PhysicsEffectConfiguration(
///   physicsProperties: PhysicsProperties.bouncy(),
///   visualProperties: VisualProperties(...),
///   particleConfiguration: ParticleConfiguration(...),
/// );
/// ```
@immutable
class PhysicsEffectConfiguration extends EffectConfiguration {
  /// Creates a [PhysicsEffectConfiguration] with grouped properties.
  ///
  /// This constructor accepts [PhysicsProperties] to group all physics-related ranges together,
  /// and optionally [VisualProperties] to group visual-related ranges (scale, fade thresholds).
  /// This provides better organization and validation.
  PhysicsEffectConfiguration({
    required super.particleConfiguration,
    this.physicsProperties = const PhysicsProperties(),
    this.visualProperties = const VisualProperties(),
    this.emissionProperties = const EmissionProperties(),
    this.animationProperties = const AnimationProperties(),
    this.layerProperties = const LayerProperties(),
    this.configurationOverrider,
  })  : gravity = physicsProperties.gravity,
        minDensity = Density.custom(physicsProperties.density.min),
        maxDensity = Density.custom(physicsProperties.density.max),
        minFriction = Friction.custom(physicsProperties.friction.min),
        maxFriction = Friction.custom(physicsProperties.friction.max),
        minRestitution = Restitution.custom(physicsProperties.restitution.min),
        maxRestitution = Restitution.custom(physicsProperties.restitution.max),
        minVelocity = Velocity.custom(physicsProperties.velocity.min),
        maxVelocity = Velocity.custom(physicsProperties.velocity.max),
        onlyInteractWithEdges = physicsProperties.onlyInteractWithEdges,
        solidEdges = physicsProperties.solidEdges,
        // Map visual properties (single values only)
        fadeInCurve = visualProperties.fadeInCurve,
        fadeOutCurve = visualProperties.fadeOutCurve,
        scaleCurve = visualProperties.scaleCurve,
        // Map emission properties
        emitCurve = emissionProperties.emitCurve,
        emitDuration = emissionProperties.emitDuration,
        particleCount = emissionProperties.particleCount,
        particlesPerEmit = emissionProperties.particlesPerEmit,
        origin = emissionProperties.origin,
        // Map animation properties
        startDelay = animationProperties.startDelay,
        // Map layer properties
        particleLayer = layerProperties.particleLayer,
        trail = layerProperties.trail;

  /// A callback function that can override the configuration dynamically.
  final PhysicsEffectConfiguration Function(
    Effect<PhysicsParticle, PhysicsEffectConfiguration>,
  )? configurationOverrider;

  /// The physics properties (grouped ranges for density, friction, restitution, velocity, and gravity).
  final PhysicsProperties physicsProperties;

  /// The visual properties (grouped ranges for scale and fade thresholds).
  final VisualProperties visualProperties;

  /// The emission properties (emission timing, count, origin, and lifespan).
  final EmissionProperties emissionProperties;

  /// The animation properties (start delay).
  final AnimationProperties animationProperties;

  /// The layer properties (particle layer and trail).
  final LayerProperties layerProperties;

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

  // Visual properties mapped to EffectConfiguration fields (single values only)
  @override
  final Curve fadeInCurve;

  @override
  final Curve fadeOutCurve;

  @override
  final Curve scaleCurve;

  // Emission properties mapped to EffectConfiguration fields
  @override
  final Curve emitCurve;

  @override
  final Duration emitDuration;

  @override
  final int particleCount;

  @override
  final int particlesPerEmit;

  @override
  final Offset origin;

  // Animation properties mapped to EffectConfiguration fields
  @override
  final Duration startDelay;

  // Layer properties mapped to EffectConfiguration fields
  @override
  final ParticleLayer particleLayer;

  @override
  final Trail trail;

  @override
  PhysicsEffectConfiguration copyWith({
    PhysicsEffectConfiguration Function(
      Effect<PhysicsParticle, PhysicsEffectConfiguration>,
    )? configurationOverrider,
    PhysicsProperties? physicsProperties,
    VisualProperties? visualProperties,
    EmissionProperties? emissionProperties,
    AnimationProperties? animationProperties,
    LayerProperties? layerProperties,
    ParticleConfiguration? particleConfiguration,
  }) {
    return PhysicsEffectConfiguration(
      configurationOverrider: configurationOverrider ?? this.configurationOverrider,
      physicsProperties: physicsProperties ?? this.physicsProperties,
      visualProperties: visualProperties ?? this.visualProperties,
      emissionProperties: emissionProperties ?? this.emissionProperties,
      animationProperties: animationProperties ?? this.animationProperties,
      layerProperties: layerProperties ?? this.layerProperties,
      particleConfiguration: particleConfiguration ?? this.particleConfiguration,
    );
  }

  @override
  double randomAngle() {
    return physicsProperties.randomAngle();
  }

  @override
  Duration randomDuration() {
    return Duration(
      milliseconds: random.nextIntRange(
        emissionProperties.minParticleLifespan.inMilliseconds,
        emissionProperties.maxParticleLifespan.inMilliseconds,
      ),
    );
  }

  @override
  double randomFadeInThreshold() {
    return visualProperties.randomFadeInThreshold();
  }

  @override
  double randomFadeOutThreshold() {
    return visualProperties.randomFadeOutThreshold();
  }

  @override
  Offset randomOriginOffset() {
    return Offset(
      random.nextDoubleRange(
        emissionProperties.minOriginOffset.dx,
        emissionProperties.maxOriginOffset.dx,
      ),
      random.nextDoubleRange(
        emissionProperties.minOriginOffset.dy,
        emissionProperties.maxOriginOffset.dy,
      ),
    );
  }

  @override
  Tween<double> randomScaleRange() {
    return visualProperties.randomScaleRange();
  }

  /// Generates a random density within the specified range.
  Density randomDensity() {
    return physicsProperties.randomDensity();
  }

  /// Generates a random friction coefficient within the specified range.
  Friction randomFriction() {
    return physicsProperties.randomFriction();
  }

  /// Generates a random restitution (bounciness) within the specified range.
  Restitution randomRestitution() {
    return physicsProperties.randomRestitution();
  }

  /// Generates a random velocity within the specified range.
  Velocity randomVelocity() {
    return physicsProperties.randomVelocity();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is PhysicsEffectConfiguration &&
          runtimeType == other.runtimeType &&
          configurationOverrider == other.configurationOverrider &&
          physicsProperties == other.physicsProperties &&
          visualProperties == other.visualProperties &&
          solidEdges == other.solidEdges &&
          onlyInteractWithEdges == other.onlyInteractWithEdges;

  @override
  int get hashCode =>
      super.hashCode ^
      configurationOverrider.hashCode ^
      physicsProperties.hashCode ^
      visualProperties.hashCode ^
      solidEdges.hashCode ^
      onlyInteractWithEdges.hashCode;
}
