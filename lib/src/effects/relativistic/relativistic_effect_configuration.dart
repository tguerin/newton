import 'package:flutter/widgets.dart' hide Velocity;
import 'package:newton_particles/newton_particles.dart';

@immutable
class Gravity {
  final double dx;
  final double dy;

  const Gravity(this.dx, this.dy);

  static const zero = Gravity(0, 0);
  static const earthGravity = Gravity(0, 9.807);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Gravity && runtimeType == other.runtimeType && dx == other.dx && dy == other.dy;

  @override
  int get hashCode => dx.hashCode ^ dy.hashCode;

  @override
  String toString() {
    return 'Gravity{dx: $dx, dy: $dy}';
  }
}

class HardEdges {
  static const none = HardEdges.only();
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

@immutable
class RelativisticEffectConfiguration extends EffectConfiguration {
  const RelativisticEffectConfiguration({
    required this.gravity,
    required super.particleConfiguration,
    this.configurationOverrider,
    this.hardEdges = const HardEdges.all(),
    this.maxDensity = Density.styrofoam,
    this.maxFriction = Friction.ice,
    this.maxRestitution = Restitution.rubberBall,
    this.maxVelocity = Velocity.rainDrop,
    this.minDensity = Density.styrofoam,
    this.minFriction = Friction.ice,
    this.minRestitution = Restitution.rubberBall,
    this.minVelocity = Velocity.rainDrop,
    this.onlyInteractWithEdges = false,
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
    super.particleLayer,
    super.particlesPerEmit,
    super.scaleCurve,
    super.startDelay,
    super.trail,
  });

  final RelativisticEffectConfiguration Function(
    Effect<RelativisticParticle, RelativisticEffectConfiguration>,
  )? configurationOverrider;
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
  final bool onlyInteractWithEdges;

  @override
  RelativisticEffectConfiguration copyWith({
    RelativisticEffectConfiguration Function(
      Effect<RelativisticParticle, RelativisticEffectConfiguration>,
    )? configurationOverrider,
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
    bool? onlyInteractWithEdges,
    Offset? origin,
    ParticleConfiguration? particleConfiguration,
    ParticleLayer? particleLayer,
    int? particleCount,
    int? particlesPerEmit,
    Curve? scaleCurve,
    Duration? startDelay,
    Trail? trail,
  }) {
    return RelativisticEffectConfiguration(
      configurationOverrider: configurationOverrider ?? this.configurationOverrider,
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
      onlyInteractWithEdges: onlyInteractWithEdges ?? this.onlyInteractWithEdges,
      origin: origin ?? this.origin,
      particleCount: particleCount ?? this.particleCount,
      particleLayer: particleLayer ?? this.particleLayer,
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is RelativisticEffectConfiguration &&
          runtimeType == other.runtimeType &&
          configurationOverrider == other.configurationOverrider &&
          gravity == other.gravity &&
          hardEdges == other.hardEdges &&
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
      hardEdges.hashCode ^
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
