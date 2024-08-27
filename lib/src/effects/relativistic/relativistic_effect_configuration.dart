import 'package:flutter/widgets.dart' hide Velocity;
import 'package:newton_particles/newton_particles.dart';

typedef Gravity = Offset;

class HardEdges {
  const HardEdges.all()
      : left = true,
        top = true,
        right = true,
        bottom = true;

  const HardEdges.only({
    this.left = false,
    this.top = false,
    this.right = false,
    this.bottom = false,
  });

  final bool left;
  final bool top;
  final bool right;
  final bool bottom;
}

class RelativisticEffectConfiguration extends EffectConfiguration {
  const RelativisticEffectConfiguration({
    required this.gravity,
    required super.particleConfiguration,
    this.hardEdges = const HardEdges.all(),
    this.maxDensity = Density.styrofoam,
    this.maxFriction = Friction.ice,
    this.maxRestitution = Restitution.rubberBall,
    this.maxVelocity = Velocity.rainDrop,
    this.minDensity = Density.styrofoam,
    this.minFriction = Friction.ice,
    this.minRestitution = Restitution.rubberBall,
    this.minVelocity = Velocity.rainDrop,
    super.emitCurve,
    super.emitDuration,
    super.fadeInCurve,
    super.fadeOutCurve,
    super.foreground,
    super.maxAngle,
    super.maxBeginScale,
    super.maxDuration,
    super.maxEndScale,
    super.maxFadeInThreshold,
    super.maxFadeOutThreshold,
    super.maxOriginOffset,
    super.minAngle,
    super.minBeginScale,
    super.minDuration,
    super.minEndScale,
    super.minFadeInThreshold,
    super.minFadeOutThreshold,
    super.minOriginOffset,
    super.origin,
    super.particleCount,
    super.particlesPerEmit,
    super.scaleCurve,
    super.startDelay,
    super.trail,
  });

  final Gravity gravity;
  final HardEdges hardEdges;
  final Density maxDensity;
  final Friction maxFriction;
  final Restitution maxRestitution;
  final Velocity maxVelocity;
  final Density minDensity;
  final Friction minFriction;
  final Restitution minRestitution;
  final Velocity minVelocity;

  @override
  RelativisticEffectConfiguration copyWith({
    Gravity? gravity,
    HardEdges? hardEdges,
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
    Duration? maxDuration,
    double? maxDistance,
    double? maxEndScale,
    double? maxFadeInThreshold,
    double? maxFadeOutThreshold,
    Offset? maxOriginOffset,
    Velocity? maxVelocity,
    double? minAngle,
    double? minBeginScale,
    Duration? minDuration,
    double? minDistance,
    double? minEndScale,
    double? minFadeInThreshold,
    double? minFadeOutThreshold,
    Offset? minOriginOffset,
    Velocity? minVelocity,
    Offset? origin,
    ParticleConfiguration? particleConfiguration,
    int? particleCount,
    int? particlesPerEmit,
    Curve? scaleCurve,
    Duration? startDelay,
    Trail? trail,
  }) {
    return RelativisticEffectConfiguration(
      gravity: gravity ?? this.gravity,
      hardEdges: hardEdges ?? this.hardEdges,
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
      maxDuration: maxDuration ?? this.maxDuration,
      maxEndScale: maxEndScale ?? this.maxEndScale,
      maxFadeInThreshold: maxFadeInThreshold ?? this.maxFadeInThreshold,
      maxFadeOutThreshold: maxFadeOutThreshold ?? this.maxFadeOutThreshold,
      maxOriginOffset: maxOriginOffset ?? this.maxOriginOffset,
      minAngle: minAngle ?? this.minAngle,
      minBeginScale: minBeginScale ?? this.minBeginScale,
      minDuration: minDuration ?? this.minDuration,
      minEndScale: minEndScale ?? this.minEndScale,
      minFadeInThreshold: minFadeInThreshold ?? this.minFadeInThreshold,
      minFadeOutThreshold: minFadeOutThreshold ?? this.minFadeOutThreshold,
      minOriginOffset: minOriginOffset ?? this.minOriginOffset,
      minVelocity: minVelocity ?? this.minVelocity,
      origin: origin ?? this.origin,
      particleCount: particleCount ?? this.particleCount,
      particlesPerEmit: particlesPerEmit ?? this.particlesPerEmit,
      scaleCurve: scaleCurve ?? this.scaleCurve,
      startDelay: startDelay ?? this.startDelay,
      trail: trail ?? this.trail,
    );
  }

  Density randomDensity() {
    return Density.custom(random.nextDoubleRange(minDensity.value, minDensity.value));
  }

  Friction randomFriction() {
    return Friction.custom(random.nextDoubleRange(minFriction.value, maxFriction.value));
  }

  Restitution randomRestitution() {
    return Restitution.custom(random.nextDoubleRange(minRestitution.value, maxRestitution.value));
  }

  Velocity randomVelocity() {
    return Velocity.custom(random.nextDoubleRange(minVelocity.value, maxVelocity.value));
  }
}
