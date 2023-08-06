import 'package:flutter/animation.dart';

/// Configuration class for defining particle emission properties in Newton effects.
///
/// The `EffectConfiguration` class provides customizable properties to control particle emission
/// in Newton effects. It allows you to fine-tune various parameters, such as emission duration,
/// particle count per emission, emission curve, origin, distance, duration, scale, and fade animation.
class EffectConfiguration {
  /// Total number of particles to emit. Default: `0` means infinite count.
  final int particleCount;

  /// Duration between particle emissions in milliseconds. Default: `100`.
  final int emitDuration;

  /// Number of particles emitted per emission. Default: `1`.
  final int particlesPerEmit;

  // TODO Not used for now, will be once we can set a global effect duration
  /// Curve to control the emission timing. Default: [Curves.decelerate].
  final Curve emitCurve;

  /// Origin point for particle emission. Default: `Offset(0, 0)`.
  final Offset origin;

  /// Minimum angle in degrees for particle trajectory. Default: `0`.
  final double minAngle;

  /// Maximum angle in degrees for particle trajectory. Default: `0`.
  final double maxAngle;

  /// Minimum distance traveled by particles. Default: `100`.
  final double minDistance;

  /// Maximum distance traveled by particles. Default: `200`.
  final double maxDistance;

  /// Curve to control particle travel distance. Default: [Curves.linear].
  final Curve distanceCurve;

  /// Minimum particle animation duration in milliseconds. Default: `1000`.
  final int minDuration;

  /// Maximum particle animation duration in milliseconds. Default: `1000`.
  final int maxDuration;

  /// Minimum initial particle scale. Default: `1`.
  final double minBeginScale;

  /// Maximum initial particle scale. Default: `1`.
  final double maxBeginScale;

  /// Minimum final particle scale. Default: `-1`.
  final double minEndScale;

  /// Maximum final particle scale. Default: `-1`.
  final double maxEndScale;

  /// Curve to control particle scaling animation. Default: [Curves.linear].
  final Curve scaleCurve;

  /// Minimum opacity threshold for particle fade-out. Default: `1`.
  final double minFadeOutThreshold;

  /// Maximum opacity threshold for particle fade-out. Default: `1`.
  final double maxFadeOutThreshold;

  /// Curve to control particle fade-out animation. Default: [Curves.linear].
  final Curve fadeOutCurve;

  /// Minimum opacity limit for particle fade-in. Default: `0`.
  final double minFadeInLimit;

  /// Maximum opacity limit for particle fade-in. Default: `0`.
  final double maxFadeInLimit;

  /// Curve to control particle fade-in animation. Default: [Curves.linear].
  final Curve fadeInCurve;

  /// Creates an instance of `EffectConfiguration` with the specified parameters.
  ///
  /// All parameters have default values that can be overridden during object creation.
  const EffectConfiguration({
    this.particleCount = 0,
    this.emitDuration = 100,
    this.emitCurve = Curves.decelerate,
    this.particlesPerEmit = 1,
    this.origin = const Offset(0, 0),
    this.minDistance = 100,
    this.maxDistance = 200,
    this.minAngle = 0,
    this.maxAngle = 0,
    this.distanceCurve = Curves.linear,
    this.minDuration = 1000,
    this.maxDuration = 1000,
    this.minBeginScale = 1,
    this.maxBeginScale = 1,
    this.minEndScale = -1,
    this.maxEndScale = -1,
    this.scaleCurve = Curves.linear,
    this.minFadeOutThreshold = 1,
    this.maxFadeOutThreshold = 1,
    this.fadeOutCurve = Curves.linear,
    this.minFadeInLimit = 0,
    this.maxFadeInLimit = 0,
    this.fadeInCurve = Curves.linear,
  })  : assert(minDistance <= maxDistance,
            "Min distance can't be greater than max distance"),
        assert(
            minAngle <= maxAngle, "Min angle can't be greater than max angle"),
        assert(minDuration <= maxDuration,
            "Min duration can't be greater than max duration"),
        assert(minBeginScale <= maxBeginScale,
            "Begin min scale can't be greater than begin max scale"),
        assert(minEndScale <= maxEndScale,
            "End min scale can't be greater than end max scale"),
        assert(minFadeOutThreshold <= maxFadeOutThreshold,
            "Min fadeOut threshold can't be greater than end max fadeOut threshold"),
        assert(minFadeInLimit <= maxFadeInLimit,
            "Min fadeIn limit can't be greater than end max fadeIn threshold");

  EffectConfiguration copyWith({
    int? particleCount,
    int? emitDuration,
    int? particlesPerEmit,
    Curve? emitCurve,
    Offset? origin,
    double? minAngle,
    double? maxAngle,
    double? minDistance,
    double? maxDistance,
    Curve? distanceCurve,
    int? minDuration,
    int? maxDuration,
    double? minBeginScale,
    double? maxBeginScale,
    double? minEndScale,
    double? maxEndScale,
    Curve? scaleCurve,
    double? minFadeOutThreshold,
    double? maxFadeOutThreshold,
    Curve? fadeOutCurve,
    double? minFadeInLimit,
    double? maxFadeInLimit,
    Curve? fadeInCurve,
  }) {
    return EffectConfiguration(
      particleCount: particleCount ?? this.particleCount,
      emitDuration: emitDuration ?? this.emitDuration,
      particlesPerEmit: particlesPerEmit ?? this.particlesPerEmit,
      emitCurve: emitCurve ?? this.emitCurve,
      origin: origin ?? this.origin,
      minAngle: minAngle ?? this.minAngle,
      maxAngle: maxAngle ?? this.maxAngle,
      minDistance: minDistance ?? this.minDistance,
      maxDistance: maxDistance ?? this.maxDistance,
      distanceCurve: distanceCurve ?? this.distanceCurve,
      minDuration: minDuration ?? this.minDuration,
      maxDuration: maxDuration ?? this.maxDuration,
      minBeginScale: minBeginScale ?? this.minBeginScale,
      maxBeginScale: maxBeginScale ?? this.maxBeginScale,
      minEndScale: minEndScale ?? this.minEndScale,
      maxEndScale: maxEndScale ?? this.maxEndScale,
      scaleCurve: scaleCurve ?? this.scaleCurve,
      minFadeOutThreshold: minFadeOutThreshold ?? this.minFadeOutThreshold,
      maxFadeOutThreshold: maxFadeOutThreshold ?? this.maxFadeOutThreshold,
      fadeOutCurve: fadeOutCurve ?? this.fadeOutCurve,
      minFadeInLimit: minFadeInLimit ?? this.minFadeInLimit,
      maxFadeInLimit: maxFadeInLimit ?? this.maxFadeInLimit,
      fadeInCurve: fadeInCurve ?? this.fadeInCurve,
    );
  }
}
