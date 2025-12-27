import 'package:flutter/widgets.dart';
import 'package:newton_particles/src/utils/range.dart';

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
    this.particleLifespan = const DurationRange.single(Duration(seconds: 1)),
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

  /// Particle lifespan range.
  ///
  /// Use [DurationRange.single] for a fixed duration or [DurationRange.between] for a range.
  /// Example:
  /// ```dart
  /// particleLifespan: DurationRange.between(Duration(seconds: 3), Duration(seconds: 5)),
  /// particleLifespan: DurationRange.single(Duration(seconds: 4)),
  /// ```
  final DurationRange particleLifespan;

  /// Creates a copy of this [EmissionProperties] with the given fields replaced with new values.
  EmissionProperties copyWith({
    Curve? emitCurve,
    Duration? emitDuration,
    int? particleCount,
    int? particlesPerEmit,
    Offset? origin,
    Offset? minOriginOffset,
    Offset? maxOriginOffset,
    DurationRange? particleLifespan,
  }) {
    return EmissionProperties(
      emitCurve: emitCurve ?? this.emitCurve,
      emitDuration: emitDuration ?? this.emitDuration,
      particleCount: particleCount ?? this.particleCount,
      particlesPerEmit: particlesPerEmit ?? this.particlesPerEmit,
      origin: origin ?? this.origin,
      minOriginOffset: minOriginOffset ?? this.minOriginOffset,
      maxOriginOffset: maxOriginOffset ?? this.maxOriginOffset,
      particleLifespan: particleLifespan ?? this.particleLifespan,
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
          particleLifespan == other.particleLifespan;

  @override
  int get hashCode =>
      emitCurve.hashCode ^
      emitDuration.hashCode ^
      particleCount.hashCode ^
      particlesPerEmit.hashCode ^
      origin.hashCode ^
      minOriginOffset.hashCode ^
      maxOriginOffset.hashCode ^
      particleLifespan.hashCode;

  @override
  String toString() =>
      'EmissionProperties(emitCurve: $emitCurve, emitDuration: $emitDuration, particleCount: $particleCount, particlesPerEmit: $particlesPerEmit, origin: $origin, minOriginOffset: $minOriginOffset, maxOriginOffset: $maxOriginOffset, particleLifespan: $particleLifespan)';
}
