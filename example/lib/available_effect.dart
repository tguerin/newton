import 'dart:math';

import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

enum AvailableEffect {
  scratch(
    'From scratch',
  ),
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
  fountain(
    'Fountain',
    supportedParameters: [
      AnimationParameter.color,
      AnimationParameter.distance,
      AnimationParameter.fadeout,
      AnimationParameter.scale,
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

Map<AvailableEffect, EffectConfiguration> defaultEffectConfigurationsPerAnimation = {
  AvailableEffect.scratch: DeterministicEffectConfiguration(
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
  ),
  AvailableEffect.rain: RelativisticEffectConfiguration(
    gravity: const Gravity(0, 9.807),
    origin: Offset.zero,
    maxOriginOffset: const Offset(1, 0),
    maxAngle: 90,
    maxDuration: const Duration(seconds: 7),
    maxEndScale: 1,
    maxFadeOutThreshold: 0.8,
    minAngle: 90,
    minDuration: const Duration(seconds: 4),
    minEndScale: 1,
    minFadeOutThreshold: 0.6,
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
  ),
  AvailableEffect.explode: DeterministicEffectConfiguration(
    maxAngle: 180,
    maxDuration: const Duration(seconds: 7),
    maxEndScale: 1,
    maxFadeOutThreshold: 0.8,
    minAngle: -180,
    minDuration: const Duration(seconds: 4),
    minEndScale: 1,
    minFadeOutThreshold: 0.6,
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
  ),
  AvailableEffect.pulse: DeterministicEffectConfiguration(
    customPathBuilder: (effect, animatedParticle) {
      final particlesPerEmit = effect.effectConfiguration.particlesPerEmit;
      final angle = 360 / particlesPerEmit * (effect.activeParticles.length % particlesPerEmit);
      return StraightPathTransformation(distance: effect.effectConfiguration.randomDistance(), angle: angle);
    },
    emitDuration: const Duration(seconds: 1),
    maxDuration: const Duration(seconds: 4),
    maxEndScale: 1,
    maxFadeOutThreshold: 0.8,
    minDistance: 200,
    minEndScale: 1,
    minDuration: const Duration(seconds: 4),
    minFadeOutThreshold: 0.8,
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
    particlesPerEmit: 15,
  ),
  AvailableEffect.smoke: DeterministicEffectConfiguration(
    minAngle: -100,
    maxAngle: -80,
    minOriginOffset: const Offset(-0.01, 0),
    minDuration: const Duration(seconds: 4),
    maxDuration: const Duration(seconds: 7),
    minFadeOutThreshold: 0.6,
    maxFadeOutThreshold: 0.8,
    maxOriginOffset: const Offset(0.01, 0),
    minEndScale: 1,
    maxEndScale: 1,
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
    particlesPerEmit: 3,
  ),
  AvailableEffect.fountain: DeterministicEffectConfiguration(
    minDuration: const Duration(seconds: 4),
    maxDuration: const Duration(seconds: 4),
    customPathBuilder: (effect, animatedParticle) {
      const width = 60;
      final path = Path();
      final randomWidth = random.nextDoubleRange(-width / 2, width / 2);
      final distance = effect.effectConfiguration.randomDistance();

      // Define the Bezier path to simulate the fountain trajectory
      return PathMetricsTransformation(
        path: path
          ..moveTo(animatedParticle.particle.initialPosition.dx, animatedParticle.particle.initialPosition.dy)
          ..relativeQuadraticBezierTo(
            randomWidth,
            -distance,
            randomWidth * 4,
            -distance / Random().nextIntRange(2, 6),
          ),
      );
    },
    minDistance: 200,
    minFadeOutThreshold: 0.6,
    maxFadeOutThreshold: 0.8,
    minEndScale: 1,
    maxEndScale: 1,
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
    particlesPerEmit: 10,
  ),
  AvailableEffect.firework: DeterministicEffectConfiguration(
    minAngle: -120,
    maxAngle: -60,
    maxDuration: const Duration(seconds: 2),
    minFadeOutThreshold: 0.6,
    maxFadeOutThreshold: 0.8,
    emitDuration: const Duration(milliseconds: 500),
    minEndScale: 1,
    maxEndScale: 1,
    particleConfiguration: ParticleConfiguration(
      shape: const CircleShape(),
      size: const Size(5, 5),
      postEffectBuilder: (particle, effect) {
        final offset = Offset(
          particle.position.dx / effect.surfaceSize.width,
          particle.position.dy / effect.surfaceSize.height,
        );
        return DeterministicEffectConfiguration(
          maxAngle: 180,
          minAngle: -180,
          particleCount: 10,
          particleConfiguration: const ParticleConfiguration(
            shape: CircleShape(),
            size: Size(5, 5),
            color: SingleParticleColor(color: Colors.blue),
          ),
          particlesPerEmit: 10,
          distanceCurve: Curves.decelerate,
          origin: offset,
        );
      },
    ),
    trail: const StraightTrail(
      trailWidth: 3,
      trailProgress: 0.3,
    ),
  ),
};

enum AnimationParameter {
  angle,
  color,
  distance,
  fadeout,
  scale,
  trail,
}
