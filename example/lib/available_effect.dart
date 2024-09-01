import 'dart:math';

import 'package:flutter/material.dart' hide Velocity;
import 'package:newton_particles/newton_particles.dart';

enum AvailableEffect {
  scratch('From scratch'),
  rain('Rain'),
  explode('Explode'),
  firework('Firework'),
  fountain('Fountain'),
  smoke('Smoke'),
  pulse('Pulse');

  const AvailableEffect(this.label);

  final String label;

  static AvailableEffect of(String label) {
    return AvailableEffect.values.firstWhere((effect) => effect.label == label);
  }
}

Map<AvailableEffect, EffectConfiguration> defaultRelativisticEffectConfigurationsPerAnimation = {
  AvailableEffect.scratch: RelativisticEffectConfiguration(
    gravity: Gravity.earthGravity,
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
  ),
  AvailableEffect.rain: RelativisticEffectConfiguration(
    gravity: Gravity.earthGravity,
    origin: Offset.zero,
    maxOriginOffset: const Offset(1, 0),
    maxAngle: 90,
    maxDuration: const Duration(seconds: 7),
    maxEndScale: 1,
    maxFadeOutThreshold: .8,
    minAngle: 90,
    minDuration: const Duration(seconds: 4),
    minEndScale: 1,
    minFadeOutThreshold: .6,
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
  ),
  AvailableEffect.explode: RelativisticEffectConfiguration(
    gravity: Gravity.zero,
    maxAngle: 180,
    maxDuration: const Duration(seconds: 7),
    maxEndScale: 1,
    maxFadeOutThreshold: .8,
    minAngle: -180,
    minDuration: const Duration(seconds: 4),
    minEndScale: 1,
    minFadeOutThreshold: .6,
    minVelocity: const Velocity(.02),
    maxVelocity: const Velocity(.3),
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
  ),
  AvailableEffect.pulse: RelativisticEffectConfiguration(
    configurationOverrider: (effect) {
      final particlesPerEmit = effect.effectConfiguration.particlesPerEmit;
      final angle = 360 / particlesPerEmit * (effect.activeParticles.length % particlesPerEmit);
      return effect.effectConfiguration.copyWith(maxAngle: angle, minAngle: angle);
    },
    gravity: Gravity.zero,
    emitDuration: const Duration(seconds: 1),
    maxDuration: const Duration(seconds: 4),
    maxEndScale: 1,
    maxFadeOutThreshold: .8,
    maxVelocity: const Velocity(.6),
    minEndScale: 1,
    minDuration: const Duration(seconds: 4),
    minVelocity: const Velocity(.6),
    minFadeOutThreshold: .8,
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
    particlesPerEmit: 15,
  ),
  AvailableEffect.smoke: DeterministicEffectConfiguration(
    minAngle: -100,
    maxAngle: -80,
    minOriginOffset: const Offset(-.01, 0),
    minDuration: const Duration(seconds: 4),
    maxDuration: const Duration(seconds: 7),
    minFadeOutThreshold: .6,
    maxFadeOutThreshold: .8,
    maxOriginOffset: const Offset(.01, 0),
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
    minFadeOutThreshold: .6,
    maxFadeOutThreshold: .8,
    minEndScale: 1,
    maxEndScale: 1,
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
    particlesPerEmit: 10,
  ),
  AvailableEffect.firework: RelativisticEffectConfiguration(
    gravity: Gravity.earthGravity,
    minAngle: -100,
    maxAngle: -80,
    maxDuration: const Duration(seconds: 1, milliseconds: 500),
    minFadeOutThreshold: .6,
    maxFadeOutThreshold: .8,
    emitDuration: const Duration(milliseconds: 500),
    minEndScale: 1,
    maxEndScale: 1,
    minVelocity: const Velocity(10),
    maxVelocity: const Velocity(12),
    origin: const Offset(0.5, 1),
    hardEdges: HardEdges.none,
    particleConfiguration: ParticleConfiguration(
      shape: const CircleShape(),
      size: const Size(5, 5),
      postEffectBuilder: (particle, effect) {
        final offset = Offset(
          particle.position.dx / effect.surfaceSize.width,
          particle.position.dy / effect.surfaceSize.height,
        );
        return RelativisticEffectConfiguration(
          gravity: Gravity.earthGravity,
          maxAngle: 180,
          minAngle: -180,
          particleCount: 10,
          hardEdges: HardEdges.none,
          minVelocity: const Velocity(5),
          maxVelocity: const Velocity(5),
          particleConfiguration: const ParticleConfiguration(
            shape: CircleShape(),
            size: Size(5, 5),
            color: SingleParticleColor(color: Colors.blue),
          ),
          particlesPerEmit: 10,
          origin: offset,
        );
      },
    ),
  ),
};

Map<AvailableEffect, EffectConfiguration> defaultDeterministicEffectConfigurationsPerAnimation(Size screenSize) => {
      AvailableEffect.scratch: DeterministicEffectConfiguration(
        particleConfiguration: const ParticleConfiguration(
          shape: CircleShape(),
          size: Size(5, 5),
        ),
      ),
      AvailableEffect.rain: DeterministicEffectConfiguration(
        minDistance: screenSize.height,
        maxDistance: screenSize.height,
        origin: Offset.zero,
        maxOriginOffset: const Offset(1, 0),
        maxAngle: 90,
        maxDuration: const Duration(seconds: 7),
        maxEndScale: 1,
        maxFadeOutThreshold: .8,
        minAngle: 90,
        minDuration: const Duration(seconds: 4),
        minEndScale: 1,
        minFadeOutThreshold: .6,
        particleConfiguration: const ParticleConfiguration(
          shape: CircleShape(),
          size: Size(5, 5),
        ),
      ),
      AvailableEffect.explode: DeterministicEffectConfiguration(
        maxAngle: 180,
        maxDuration: const Duration(seconds: 7),
        maxEndScale: 1,
        maxFadeOutThreshold: .8,
        minAngle: -180,
        minDuration: const Duration(seconds: 4),
        minEndScale: 1,
        minFadeOutThreshold: .6,
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
        maxFadeOutThreshold: .8,
        minDistance: 200,
        minEndScale: 1,
        minDuration: const Duration(seconds: 4),
        minFadeOutThreshold: .8,
        particleConfiguration: const ParticleConfiguration(
          shape: CircleShape(),
          size: Size(5, 5),
        ),
        particlesPerEmit: 15,
      ),
      AvailableEffect.smoke: DeterministicEffectConfiguration(
        minAngle: -100,
        maxAngle: -80,
        minOriginOffset: const Offset(-.01, 0),
        minDuration: const Duration(seconds: 4),
        maxDuration: const Duration(seconds: 7),
        minFadeOutThreshold: .6,
        maxFadeOutThreshold: .8,
        maxOriginOffset: const Offset(.01, 0),
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
        minFadeOutThreshold: .6,
        maxFadeOutThreshold: .8,
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
        minFadeOutThreshold: .6,
        maxFadeOutThreshold: .8,
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
          trailProgress: .3,
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
