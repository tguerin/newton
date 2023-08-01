import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

enum AvailableEffect {
  rain(
    "Rain",
    supportedParameters: [AnimationParameter.fadeout, AnimationParameter.scale],
  ),
  explode(
    "Explode",
    supportedParameters: [
      AnimationParameter.distance,
      AnimationParameter.fadeout,
      AnimationParameter.scale
    ],
  ),
  smoke("Smoke",
      defaultEffectConfiguration: EffectConfiguration(
        minAngle: -5,
        maxAngle: 5,
        minDuration: 4000,
        maxDuration: 7000,
        minFadeOutThreshold: 0.6,
        maxFadeOutThreshold: 0.8,
        minBeginScale: 1,
        maxBeginScale: 1,
        minEndScale: 1,
        maxEndScale: 1,
      ),
      supportedParameters: [
        AnimationParameter.angle,
        AnimationParameter.distance,
        AnimationParameter.fadeout,
        AnimationParameter.scale,
      ]),
  fountain("Fountain",
      defaultEffectConfiguration: EffectConfiguration(
        particlesPerEmit: 10,
        minDuration: 4000,
        maxDuration: 4000,
        minDistance: 200,
        maxDistance: 200,
        minFadeOutThreshold: 0.6,
        maxFadeOutThreshold: 0.8,
        minBeginScale: 1,
        maxBeginScale: 1,
        minEndScale: 1,
        maxEndScale: 1,
      ),
      supportedParameters: [
        AnimationParameter.distance,
        AnimationParameter.fadeout,
        AnimationParameter.scale,
      ]),
  pulse("Pulse",
      defaultEffectConfiguration: EffectConfiguration(
        particlesPerEmit: 15,
        emitDuration: 1000,
        minDuration: 4000,
        maxDuration: 4000,
        minDistance: 200,
        maxDistance: 200,
        minFadeOutThreshold: 0.8,
        maxFadeOutThreshold: 0.8,
        minBeginScale: 1,
        maxBeginScale: 1,
        minEndScale: 1,
        maxEndScale: 1,
      ),
      supportedParameters: [
        AnimationParameter.distance,
        AnimationParameter.fadeout,
        AnimationParameter.scale,
      ]);

  const AvailableEffect(
    this.label, {
    this.defaultEffectConfiguration = const EffectConfiguration(
      particlesPerEmit: 1,
      minDuration: 4000,
      maxDuration: 7000,
      minDistance: 100,
      maxDistance: 200,
      minFadeOutThreshold: 0.6,
      maxFadeOutThreshold: 0.8,
      minBeginScale: 1,
      maxBeginScale: 1,
      minEndScale: 1,
      maxEndScale: 1,
    ),
    this.supportedParameters = const [],
  });

  final String label;
  final EffectConfiguration defaultEffectConfiguration;
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
    required EffectConfiguration effectConfiguration,
  }) {
    switch (this) {
      case AvailableEffect.rain:
        return RainEffect(
          particleConfiguration: ParticleConfiguration(
            shape: CircleShape(),
            size: const Size(5, 5),
            color: Colors.white,
          ),
          effectConfiguration: effectConfiguration,
        );
      case AvailableEffect.explode:
        return ExplodeEffect(
          particleConfiguration: ParticleConfiguration(
            shape: CircleShape(),
            size: const Size(5, 5),
            color: Colors.white,
          ),
          effectConfiguration: effectConfiguration.copyWith(
            origin: Offset(size.width / 2, size.height / 2),
          ),
        );
      case AvailableEffect.smoke:
        return SmokeEffect(
          particleConfiguration: ParticleConfiguration(
            shape: CircleShape(),
            size: const Size(5, 5),
            color: Colors.white,
          ),
          effectConfiguration: effectConfiguration.copyWith(
            origin: Offset(
              size.width / 2,
              size.height / 2,
            ),
          ),
        );
      case AvailableEffect.fountain:
        return FountainEffect(
          particleConfiguration: ParticleConfiguration(
            shape: CircleShape(),
            size: const Size(5, 5),
            color: Colors.white,
          ),
          effectConfiguration: effectConfiguration.copyWith(
            distanceCurve: Curves.decelerate,
            origin: Offset(
              size.width / 2,
              size.height / 2,
            ),
          ),
          width: 60.0,
        );
      case AvailableEffect.pulse:
        return PulseEffect(
          particleConfiguration: ParticleConfiguration(
            shape: CircleShape(),
            size: const Size(5, 5),
            color: Colors.white,
          ),
          effectConfiguration: effectConfiguration.copyWith(
            origin: Offset(
              size.width / 2,
              size.height / 2,
            ),
          ),
        );
    }
  }
}

enum AnimationParameter {
  angle,
  distance,
  fadeout,
  scale,
}
