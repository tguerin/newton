import 'package:flutter/animation.dart';

class EffectConfiguration {
  final int emitDuration;
  final int particlesPerEmit;
  final Curve emitCurve;
  final Offset origin;
  final double minAngle;
  final double maxAngle;
  final double minDistance;
  final double maxDistance;
  final Curve distanceCurve;
  final int minDuration;
  final int maxDuration;
  final double minBeginScale;
  final double maxBeginScale;
  final double minEndScale;
  final double maxEndScale;
  final Curve scaleCurve;
  final double minFadeOutThreshold;
  final double maxFadeOutThreshold;
  final Curve fadeOutCurve;
  final double minFadeInLimit;
  final double maxFadeInLimit;
  final Curve fadeInCurve;

  const EffectConfiguration({
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
