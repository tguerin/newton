import 'package:flutter/material.dart';
import 'package:newton/effects/effect.dart';
import 'package:newton/effects/explode_effect.dart';
import 'package:newton/effects/rain_effect.dart';
import 'package:newton/effects/smoke_effect.dart';
import 'package:newton/particles/particle_configuration.dart';
import 'package:newton/shape.dart';

enum AvailableEffect {
  rain("Rain", supportedParameters: [
    AnimationParameter.fadeout,
    AnimationParameter.scale
  ]),
  explode("Explode", supportedParameters: [
    AnimationParameter.distance,
    AnimationParameter.fadeout,
    AnimationParameter.scale
  ]),
  smoke("Smoke", supportedParameters: [
    AnimationParameter.distance,
    AnimationParameter.fadeout,
    AnimationParameter.scale,
  ]);

  const AvailableEffect(this.label, {this.supportedParameters = const []});

  final String label;
  final List<AnimationParameter> supportedParameters;

  bool supportParameter(AnimationParameter parameter) {
    return supportedParameters.contains(parameter);
  }

  static AvailableEffect of(String label) {
    return AvailableEffect.values.firstWhere((effect) => effect.label == label);
  }
}

extension AvailableEffectExtension on AvailableEffect {
  Effect instantiate({
    required Size size,
    required int particlesPerEmit,
    required int emitDuration,
    required int particleMinDuration,
    required int particleMaxDuration,
    required double particleMinDistance,
    required double particleMaxDistance,
    required double particleMinFadeOutThreshold,
    required double particleMaxFadeOutThreshold,
    required double particleMinBeginScale,
    required double particleMinEndScale,
    required double particleMaxBeginScale,
    required double particleMaxEndScale,
  }) {
    switch (this) {
      case AvailableEffect.rain:
        return RainEffect(
          particleConfiguration: ParticleConfiguration(
            shape: CircleShape(),
            size: const Size(5, 5),
            color: Colors.blue,
          ),
          emitDuration: emitDuration,
          particlesPerEmit: particlesPerEmit,
          minDuration: particleMinDuration,
          maxDuration: particleMaxDuration,
          minBeginScale: particleMinBeginScale,
          maxBeginScale: particleMaxBeginScale,
          minEndScale: particleMinEndScale,
          maxEndScale: particleMaxEndScale,
          minFadeOutThreshold: particleMinFadeOutThreshold,
          maxFadeOutThreshold: particleMaxFadeOutThreshold,
        );
      case AvailableEffect.explode:
        return ExplodeEffect(
          particleConfiguration: ParticleConfiguration(
            shape: CircleShape(),
            size: const Size(5, 5),
            color: Colors.blue,
          ),
          emitDuration: emitDuration,
          particlesPerEmit: particlesPerEmit,
          origin: Offset(size.width / 2, size.height / 2),
          minDistance: particleMinDistance,
          maxDistance: particleMaxDistance,
          minDuration: particleMinDuration,
          maxDuration: particleMaxDuration,
          minBeginScale: particleMinBeginScale,
          maxBeginScale: particleMaxBeginScale,
          minEndScale: particleMinEndScale,
          maxEndScale: particleMaxEndScale,
          minFadeOutThreshold: particleMinFadeOutThreshold,
          maxFadeOutThreshold: particleMaxFadeOutThreshold,
        );
      case AvailableEffect.smoke:
        return SmokeEffect(
          particleConfiguration: ParticleConfiguration(
            shape: CircleShape(),
            size: const Size(5, 5),
            color: Colors.blue,
          ),
          emitDuration: emitDuration,
          particlesPerEmit: particlesPerEmit,
          origin: Offset(size.width / 2, size.height / 2),
          minDistance: particleMinDistance,
          maxDistance: particleMaxDistance,
          minDuration: particleMinDuration,
          maxDuration: particleMaxDuration,
          minBeginScale: particleMinBeginScale,
          maxBeginScale: particleMaxBeginScale,
          minEndScale: particleMinEndScale,
          maxEndScale: particleMaxEndScale,
          minFadeOutThreshold: particleMinFadeOutThreshold,
          maxFadeOutThreshold: particleMaxFadeOutThreshold,
        );
    }
  }
}

enum AnimationParameter {
  distance,
  fadeout,
  scale,
}
