import 'package:flutter/animation.dart';
import 'package:newton_particles/src/effects/trail.dart';

/// Configuration class for defining particle emission properties in Newton effects.
///
/// The `EffectConfiguration` class provides customizable properties to control particle emission
/// in Newton effects. It allows you to fine-tune various parameters, such as emission duration,
/// particle count per emission, emission curve, origin, distance, duration, scale, and fade animation.
class EffectConfiguration {

  /// Creates an instance of `EffectConfiguration` with the specified parameters.
  ///
  /// All parameters have default values that can be overridden during object creation.
  const EffectConfiguration({
    this.distanceCurve = Curves.linear,
    this.emitCurve = Curves.decelerate,
    this.emitDuration = const Duration(milliseconds: 100),
    this.fadeInCurve = Curves.linear,
    this.fadeOutCurve = Curves.linear,
    this.foreground = false,
    this.maxAngle = 0,
    this.maxBeginScale = 1,
    this.maxDistance = 200,
    this.maxDuration = const Duration(seconds: 1),
    this.maxEndScale = -1,
    this.maxFadeInLimit = 0,
    this.maxFadeOutThreshold = 1,
    this.minAngle = 0,
    this.minBeginScale = 1,
    this.minDistance = 100,
    this.minDuration = const Duration(seconds: 1),
    this.minEndScale = -1,
    this.minFadeInLimit = 0,
    this.minFadeOutThreshold = 1,
    this.origin = Offset.zero,
    this.particleCount = 0,
    this.particlesPerEmit = 1,
    this.scaleCurve = Curves.linear,
    this.startDelay = Duration.zero,
    this.trail = const NoTrail(),
  })  : assert(
          minAngle <= maxAngle,
          'Min angle can’t be greater than max angle',
        ),
        assert(
          minBeginScale <= maxBeginScale,
          'Begin min scale can’t be greater than begin max scale',
        ),
        assert(
          minDistance <= maxDistance,
          'Min distance can’t be greater than max distance',
        ),
        assert(
          minDuration <= maxDuration,
          'Min duration can’t be greater than max duration',
        ),
        assert(
          minEndScale <= maxEndScale,
          'End min scale can’t be greater than end max scale',
        ),
        assert(
          minFadeInLimit <= maxFadeInLimit,
          'Min fadeIn limit can’t be greater than end max fadeIn threshold',
        ),
        assert(
          minFadeOutThreshold <= maxFadeOutThreshold,
          'Min fadeOut threshold can’t be greater than end max fadeOut threshold',
        );

  /// Curve to control particle travel distance. Default: [Curves.linear].
  final Curve distanceCurve;

  /// Curve to control the emission timing. Default: [Curves.decelerate].
  final Curve emitCurve;

  /// Duration between particle emissions. Default: `100ms`.
  final Duration emitDuration;

  /// Curve to control particle fade-in animation. Default: [Curves.linear].
  final Curve fadeInCurve;

  /// Curve to control particle fade-out animation. Default: [Curves.linear].
  final Curve fadeOutCurve;

  /// Indicates whether the effect should be played in the foreground. Default: `false`.
  final bool foreground;

  /// Maximum angle in degrees for particle trajectory. Default: `0`.
  final double maxAngle;

  /// Maximum initial particle scale. Default: `1`.
  final double maxBeginScale;

  /// Maximum distance traveled by particles. Default: `200`.
  final double maxDistance;

  /// Maximum particle animation duration. Default: `1s`.
  final Duration maxDuration;

  /// Maximum final particle scale. Default: `-1`.
  final double maxEndScale;

  /// Maximum opacity limit for particle fade-in. Default: `0`.
  final double maxFadeInLimit;

  /// Maximum opacity threshold for particle fade-out. Default: `1`.
  final double maxFadeOutThreshold;

  /// Minimum angle in degrees for particle trajectory. Default: `0`.
  final double minAngle;

  /// Minimum initial particle scale. Default: `1`.
  final double minBeginScale;

  /// Minimum distance traveled by particles. Default: `100`.
  final double minDistance;

  /// Minimum particle animation duration. Default: `1s`.
  final Duration minDuration;

  /// Minimum opacity limit for particle fade-in. Default: `0`.
  final double minFadeInLimit;

  /// Minimum opacity threshold for particle fade-out. Default: `1`.
  final double minFadeOutThreshold;

  /// Minimum final particle scale. Default: `-1`.
  final double minEndScale;

  /// Origin point for particle emission. Default: `Offset(0, 0)`.
  final Offset origin;

  /// Total number of particles to emit. Default: `0` means infinite count.
  final int particleCount;

  /// Number of particles emitted per emission. Default: `1`.
  final int particlesPerEmit;

  /// Curve to control particle scaling animation. Default: [Curves.linear].
  final Curve scaleCurve;

  /// Delay to wait before starting effect. Default: [Duration.zero].
  final Duration startDelay;

  /// The trail effect associated with emitted particles. Default: [NoTrail].
  final Trail trail;

  /// Returns a copy of this configuration with the given fields replaced with the new values.
  ///
  /// This method allows for creating modified copies of the configuration by overriding specific parameters.
  EffectConfiguration copyWith({
    Curve? distanceCurve,
    Curve? emitCurve,
    Duration? emitDuration,
    Curve? fadeInCurve,
    Curve? fadeOutCurve,
    bool? foreground,
    double? maxAngle,
    double? maxBeginScale,
    double? maxDistance,
    Duration? maxDuration,
    double? maxEndScale,
    double? maxFadeInLimit,
    double? maxFadeOutThreshold,
    double? minAngle,
    double? minBeginScale,
    double? minDistance,
    Duration? minDuration,
    double? minEndScale,
    double? minFadeInLimit,
    double? minFadeOutThreshold,
    Offset? origin,
    int? particleCount,
    int? particlesPerEmit,
    Curve? scaleCurve,
    Duration? startDelay,
    Trail? trail,
  }) {
    return EffectConfiguration(
      distanceCurve: distanceCurve ?? this.distanceCurve,
      emitCurve: emitCurve ?? this.emitCurve,
      emitDuration: emitDuration ?? this.emitDuration,
      fadeInCurve: fadeInCurve ?? this.fadeInCurve,
      fadeOutCurve: fadeOutCurve ?? this.fadeOutCurve,
      foreground: foreground ?? this.foreground,
      maxAngle: maxAngle ?? this.maxAngle,
      maxBeginScale: maxBeginScale ?? this.maxBeginScale,
      maxDistance: maxDistance ?? this.maxDistance,
      maxDuration: maxDuration ?? this.maxDuration,
      maxEndScale: maxEndScale ?? this.maxEndScale,
      maxFadeInLimit: maxFadeInLimit ?? this.maxFadeInLimit,
      maxFadeOutThreshold: maxFadeOutThreshold ?? this.maxFadeOutThreshold,
      minAngle: minAngle ?? this.minAngle,
      minBeginScale: minBeginScale ?? this.minBeginScale,
      minDistance: minDistance ?? this.minDistance,
      minDuration: minDuration ?? this.minDuration,
      minEndScale: minEndScale ?? this.minEndScale,
      minFadeInLimit: minFadeInLimit ?? this.minFadeInLimit,
      minFadeOutThreshold: minFadeOutThreshold ?? this.minFadeOutThreshold,
      origin: origin ?? this.origin,
      particleCount: particleCount ?? this.particleCount,
      particlesPerEmit: particlesPerEmit ?? this.particlesPerEmit,
      scaleCurve: scaleCurve ?? this.scaleCurve,
      startDelay: startDelay ?? this.startDelay,
      trail: trail ?? this.trail,
    );
  }
}
