import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

enum AvailableEffect {
  rain(
    "Rain",
    supportedParameters: [
      AnimationParameter.color,
      AnimationParameter.fadeout,
      AnimationParameter.scale,
    ],
  ),
  explode(
    "Explode",
    defaultEffectConfiguration: EffectConfiguration(
      minAngle: -180,
      maxAngle: 180,
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
      AnimationParameter.color,
      AnimationParameter.distance,
      AnimationParameter.fadeout,
      AnimationParameter.scale
    ],
  ),
  firework(
    "Firework",
    defaultEffectConfiguration: EffectConfiguration(
      minAngle: -120,
      maxAngle: -60,
      minDuration: 1000,
      maxDuration: 2000,
      minFadeOutThreshold: 0.6,
      maxFadeOutThreshold: 0.8,
      minBeginScale: 1,
      maxBeginScale: 1,
      minEndScale: 1,
      maxEndScale: 1,
      trail: StraightTrail(
        trailWidth: 3,
        trailProgress: 0.3,
      ),
    ),
    supportedParameters: [
      AnimationParameter.angle,
      AnimationParameter.color,
      AnimationParameter.distance,
      AnimationParameter.fadeout,
      AnimationParameter.scale,
      AnimationParameter.trail,
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
        AnimationParameter.color,
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
        AnimationParameter.color,
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
        AnimationParameter.color,
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
    required ParticleColor color,
    required EffectConfiguration effectConfiguration,
  }) {
    switch (this) {
      case AvailableEffect.rain:
        return RainEffect(
          particleConfiguration: ParticleConfiguration(
            shape: CircleShape(),
            size: const Size(5, 5),
            color: color,
          ),
          effectConfiguration: effectConfiguration,
        );
      case AvailableEffect.explode:
        return ExplodeEffect(
          particleConfiguration: ParticleConfiguration(
            shape: CircleShape(),
            size: const Size(5, 5),
            color: color,
          ),
          effectConfiguration: effectConfiguration.copyWith(
            origin: Offset(size.width / 2, size.height / 2),
          ),
        );
      case AvailableEffect.firework:
        return ExplodeEffect(
          particleConfiguration: ParticleConfiguration(
              shape: CircleShape(),
              size: const Size(5, 5),
              color: color,
              postEffectBuilder: (particle) => ExplodeEffect(
                  particleConfiguration: ParticleConfiguration(
                    shape: CircleShape(),
                    size: const Size(5, 5),
                    color: const SingleParticleColor(color: Colors.blue),
                  ),
                  effectConfiguration: effectConfiguration.copyWith(
                    maxAngle: 180,
                    minAngle: -180,
                    particleCount: 10,
                    particlesPerEmit: 10,
                    distanceCurve: Curves.decelerate,
                    origin: particle.position,
                  ))),
          effectConfiguration: effectConfiguration.copyWith(
            emitDuration: 600,
            distanceCurve: Curves.decelerate,
            origin: Offset(size.width / 2, size.height / 2),
          ),
        );
      case AvailableEffect.smoke:
        return SmokeEffect(
          particleConfiguration: ParticleConfiguration(
              shape: CircleShape(), size: const Size(5, 5), color: color),
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
            color: color,
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
            color: color,
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
  color,
  distance,
  fadeout,
  scale,
  trail,
}
