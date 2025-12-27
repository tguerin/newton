import 'package:flutter/widgets.dart';

/// Groups all emission-related properties for particle effects.
///
/// This class encapsulates properties related to how particles are emitted,
/// including timing, count, origin, and lifespan.
@immutable
class EmissionProperties {
  /// Creates an [EmissionProperties] instance with the specified emission properties.
  const EmissionProperties({
    this.emitCurve = Curves.decelerate,
    this.emitDuration = const Duration(milliseconds: 100),
    this.particleCount = 0,
    this.particlesPerEmit = 1,
    this.origin = const Offset(0.5, 0.5),
    this.minOriginOffset = Offset.zero,
    this.maxOriginOffset = Offset.zero,
    this.minParticleLifespan = const Duration(seconds: 1),
    this.maxParticleLifespan = const Duration(seconds: 1),
  });

  /// Curve to control the emission timing of particles.
  final Curve emitCurve;

  /// Duration between particle emissions.
  final Duration emitDuration;

  /// Total number of particles that will be emitted.
  final int particleCount;

  /// Number of particles emitted in each burst.
  final int particlesPerEmit;

  /// Origin point for particle emission, relative from the top-left of the container.
  final Offset origin;

  /// Minimum offset from the origin point for particle emission.
  final Offset minOriginOffset;

  /// Maximum offset from the origin point for particle emission.
  final Offset maxOriginOffset;

  /// Minimum particle lifespan duration.
  final Duration minParticleLifespan;

  /// Maximum particle lifespan duration.
  final Duration maxParticleLifespan;

  /// Creates a copy of this [EmissionProperties] with the given fields replaced with new values.
  EmissionProperties copyWith({
    Curve? emitCurve,
    Duration? emitDuration,
    int? particleCount,
    int? particlesPerEmit,
    Offset? origin,
    Offset? minOriginOffset,
    Offset? maxOriginOffset,
    Duration? minParticleLifespan,
    Duration? maxParticleLifespan,
  }) {
    return EmissionProperties(
      emitCurve: emitCurve ?? this.emitCurve,
      emitDuration: emitDuration ?? this.emitDuration,
      particleCount: particleCount ?? this.particleCount,
      particlesPerEmit: particlesPerEmit ?? this.particlesPerEmit,
      origin: origin ?? this.origin,
      minOriginOffset: minOriginOffset ?? this.minOriginOffset,
      maxOriginOffset: maxOriginOffset ?? this.maxOriginOffset,
      minParticleLifespan: minParticleLifespan ?? this.minParticleLifespan,
      maxParticleLifespan: maxParticleLifespan ?? this.maxParticleLifespan,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmissionProperties &&
          runtimeType == other.runtimeType &&
          emitCurve == other.emitCurve &&
          emitDuration == other.emitDuration &&
          particleCount == other.particleCount &&
          particlesPerEmit == other.particlesPerEmit &&
          origin == other.origin &&
          minOriginOffset == other.minOriginOffset &&
          maxOriginOffset == other.maxOriginOffset &&
          minParticleLifespan == other.minParticleLifespan &&
          maxParticleLifespan == other.maxParticleLifespan;

  @override
  int get hashCode =>
      emitCurve.hashCode ^
      emitDuration.hashCode ^
      particleCount.hashCode ^
      particlesPerEmit.hashCode ^
      origin.hashCode ^
      minOriginOffset.hashCode ^
      maxOriginOffset.hashCode ^
      minParticleLifespan.hashCode ^
      maxParticleLifespan.hashCode;

  @override
  String toString() =>
      'EmissionProperties(emitCurve: $emitCurve, emitDuration: $emitDuration, particleCount: $particleCount, particlesPerEmit: $particlesPerEmit, origin: $origin, minOriginOffset: $minOriginOffset, maxOriginOffset: $maxOriginOffset, minParticleLifespan: $minParticleLifespan, maxParticleLifespan: $maxParticleLifespan)';
}
