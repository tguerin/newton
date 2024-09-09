import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

enum AvailableEffect {
  rain(
    'Rain',
    supportedParameters: [
      AnimationParameter.color,
      AnimationParameter.fadeout,
      AnimationParameter.scale,
    ],
  ),
  explode(
    'Explode',
    supportedParameters: [
      AnimationParameter.angle,
      AnimationParameter.color,
      AnimationParameter.distance,
      AnimationParameter.fadeout,
      AnimationParameter.scale,
    ],
  ),
  firework(
    'Firework',
    supportedParameters: [
      AnimationParameter.angle,
      AnimationParameter.color,
      AnimationParameter.distance,
      AnimationParameter.fadeout,
      AnimationParameter.scale,
      AnimationParameter.trail,
    ],
  ),
  smoke(
    'Smoke',
    supportedParameters: [
      AnimationParameter.color,
      AnimationParameter.angle,
      AnimationParameter.distance,
      AnimationParameter.fadeout,
      AnimationParameter.scale,
    ],
  ),
  fountain(
    'Fountain',
    supportedParameters: [
      AnimationParameter.color,
      AnimationParameter.distance,
      AnimationParameter.fadeout,
      AnimationParameter.scale,
    ],
  ),
  pulse(
    'Pulse',
    supportedParameters: [
      AnimationParameter.color,
      AnimationParameter.distance,
      AnimationParameter.fadeout,
      AnimationParameter.scale,
    ],
  );

  const AvailableEffect(
    this.label, {
    this.supportedParameters = const [],
  });

  final String label;
  final List<AnimationParameter> supportedParameters;

  bool supportParameter(AnimationParameter parameter) {
    return supportedParameters.contains(parameter);
  }

  static AvailableEffect of(String label) {
    return AvailableEffect.values.firstWhere((effect) => effect.label == label);
  }
}

final defaultEffectConfiguration = EffectConfiguration(
  minDuration: const Duration(seconds: 4),
  maxDuration: const Duration(seconds: 7),
  minFadeOutThreshold: 0.6,
  maxFadeOutThreshold: 0.8,
  minEndScale: 1,
  maxEndScale: 1,
);

Map<AvailableEffect, EffectConfiguration> defaultEffectConfigurationsPerAnimation = {
  AvailableEffect.explode: EffectConfiguration(
    minAngle: -180,
    maxAngle: 180,
    minDuration: const Duration(seconds: 4),
    maxDuration: const Duration(seconds: 7),
    minFadeOutThreshold: 0.6,
    maxFadeOutThreshold: 0.8,
    minEndScale: 1,
    maxEndScale: 1,
  ),
  AvailableEffect.firework: EffectConfiguration(
    minAngle: -120,
    maxAngle: -60,
    maxDuration: const Duration(seconds: 2),
    minFadeOutThreshold: 0.6,
    maxFadeOutThreshold: 0.8,
    minEndScale: 1,
    maxEndScale: 1,
    trail: const StraightTrail(
      trailWidth: 3,
      trailProgress: 0.3,
    ),
  ),
  AvailableEffect.fountain: EffectConfiguration(
    particlesPerEmit: 10,
    minDuration: const Duration(seconds: 4),
    maxDuration: const Duration(seconds: 4),
    minDistance: 200,
    minFadeOutThreshold: 0.6,
    maxFadeOutThreshold: 0.8,
    minEndScale: 1,
    maxEndScale: 1,
  ),
  AvailableEffect.pulse: EffectConfiguration(
    particlesPerEmit: 15,
    emitDuration: const Duration(seconds: 1),
    minDuration: const Duration(seconds: 4),
    maxDuration: const Duration(seconds: 4),
    minDistance: 200,
    minFadeOutThreshold: 0.8,
    maxFadeOutThreshold: 0.8,
    minEndScale: 1,
    maxEndScale: 1,
  ),
  AvailableEffect.smoke: EffectConfiguration(
    particlesPerEmit: 3,
    minAngle: -5,
    maxAngle: 5,
    minDuration: const Duration(seconds: 4),
    maxDuration: const Duration(seconds: 7),
    minFadeOutThreshold: 0.6,
    maxFadeOutThreshold: 0.8,
    minEndScale: 1,
    maxEndScale: 1,
  ),
};

extension AvailableEffectExtension on AvailableEffect {
  Effect instantiate({
    required Size size,
    required ParticleColor color,
    required EffectConfiguration effectConfiguration,
  }) {
    switch (this) {
      case AvailableEffect.rain:
        return RainEffect(
          particleConfiguration: ParticleConfiguration(
            shape: const CircleShape(),
            size: const Size(5, 5),
            color: color,
          ),
          effectConfiguration: effectConfiguration,
        );
      case AvailableEffect.explode:
        return ExplodeEffect(
          particleConfiguration: ParticleConfiguration(
            shape: const CircleShape(),
            size: const Size(5, 5),
            color: color,
          ),
          effectConfiguration: effectConfiguration.copyWith(
            origin: const Offset(0.5, 0.5),
          ),
        );
      case AvailableEffect.firework:
        return ExplodeEffect(
          particleConfiguration: ParticleConfiguration(
            shape: const CircleShape(),
            size: const Size(5, 5),
            color: color,
            postEffectBuilder: (particle, surfaceSize) {
              final offset = Offset(
                  particle.position.dx / surfaceSize.width,
                  particle.position.dy / surfaceSize.height,
                );
              return ExplodeEffect(
              particleConfiguration: const ParticleConfiguration(
                shape: CircleShape(),
                size: Size(5, 5),
                color: SingleParticleColor(color: Colors.blue),
              ),
              effectConfiguration: effectConfiguration.copyWith(
                maxAngle: 180,
                minAngle: -180,
                particleCount: 10,
                particlesPerEmit: 10,
                distanceCurve: Curves.decelerate,
                origin: offset,
              ),
            );},
          ),
          effectConfiguration: effectConfiguration.copyWith(
            emitDuration: const Duration(milliseconds: 600),
            distanceCurve: Curves.decelerate,
            origin: const Offset(0.5, 0.5),
          ),
        );
      case AvailableEffect.smoke:
        return SmokeEffect(
          particleConfiguration: ParticleConfiguration(shape: const CircleShape(), size: const Size(5, 5), color: color),
          effectConfiguration: effectConfiguration.copyWith(
            origin: const Offset(
              0.5,
              0.5,
            ),
          ),
        );
      case AvailableEffect.fountain:
        return FountainEffect(
          particleConfiguration: ParticleConfiguration(
            shape: const CircleShape(),
            size: const Size(5, 5),
            color: color,
          ),
          effectConfiguration: effectConfiguration.copyWith(
            distanceCurve: Curves.decelerate,
            origin: const Offset(
              0.5,
              0.5,
            ),
          ),
          width: 60,
        );
      case AvailableEffect.pulse:
        return PulseEffect(
          particleConfiguration: ParticleConfiguration(
            shape: const CircleShape(),
            size: const Size(5, 5),
            color: color,
          ),
          effectConfiguration: effectConfiguration.copyWith(
            origin: const Offset(
              0.5,
              0.5,
            ),
          ),
        );
    }
  }
}

enum AnimationParameter {
  angle,
  color,
  distance,
  fadeout,
  scale,
  trail,
}
