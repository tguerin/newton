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
  AvailableEffect.scratch: PhysicsEffectConfiguration(
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
  ),
  AvailableEffect.rain: PhysicsEffectConfiguration(
    physicsProperties: const PhysicsProperties(
      angle: NumRange.single(90),
      velocity: NumRange.between(Velocity.stationary, Velocity.stationary),
    ),
    visualProperties: const VisualProperties(
      endScale: NumRange.single(1),
      fadeOutThreshold: NumRange.between(0.6, 0.8),
    ),
    emissionProperties: const EmissionProperties(
      origin: Offset.zero,
      maxOriginOffset: Offset(1, 0),
      particleLifespan: DurationRange.between(Duration(seconds: 7), Duration(seconds: 10)),
    ),
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
  ),
  AvailableEffect.explode: PhysicsEffectConfiguration(
    physicsProperties: const PhysicsProperties(
      gravity: Gravity.zero,
      angle: NumRange.between(-180, 180),
      velocity: NumRange.between(Velocity(.02), Velocity(.3)),
    ),
    visualProperties: const VisualProperties(
      endScale: NumRange.single(1),
      fadeOutThreshold: NumRange.between(0.6, 0.8),
    ),
    emissionProperties: const EmissionProperties(
      particleLifespan: DurationRange.between(Duration(seconds: 4), Duration(seconds: 7)),
    ),
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
  ),
  AvailableEffect.pulse: PhysicsEffectConfiguration(
    configurationOverrider: (effect) {
      final particlesPerEmit = effect.effectConfiguration.particlesPerEmit;
      final angle = 360 / particlesPerEmit * (effect.activeParticles.length % particlesPerEmit);
      return effect.effectConfiguration.copyWith(
        physicsProperties: effect.effectConfiguration.physicsProperties.copyWith(
          angle: NumRange.single(angle),
        ),
      );
    },
    physicsProperties: const PhysicsProperties(
      gravity: Gravity.zero,
      velocity: NumRange.between(Velocity(.6), Velocity(.6)),
      onlyInteractWithEdges: true,
    ),
    visualProperties: const VisualProperties(
      endScale: NumRange.single(1),
      fadeOutThreshold: NumRange.single(0.8),
    ),
    emissionProperties: const EmissionProperties(
      emitDuration: Duration(seconds: 1),
      particlesPerEmit: 15,
      particleLifespan: DurationRange.single(Duration(seconds: 4)),
    ),
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
  ),
  AvailableEffect.fountain: PhysicsEffectConfiguration(
    physicsProperties: PhysicsProperties(
      angle: const NumRange.between(-100, -80),
      velocity: NumRange.between(Velocity.custom(3), Velocity.custom(5)),
      onlyInteractWithEdges: true,
    ),
    visualProperties: const VisualProperties(
      endScale: NumRange.single(1),
      fadeOutThreshold: NumRange.between(0.6, 0.8),
    ),
    emissionProperties: const EmissionProperties(
      particlesPerEmit: 10,
      particleLifespan: DurationRange.single(Duration(seconds: 4)),
    ),
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
  ),
  AvailableEffect.firework: PhysicsEffectConfiguration(
    physicsProperties: const PhysicsProperties(
      angle: NumRange.between(-100, -80),
      velocity: NumRange.between(Velocity(9), Velocity(10)),
      solidEdges: SolidEdges.none,
    ),
    visualProperties: const VisualProperties(
      endScale: NumRange.single(1),
      fadeOutThreshold: NumRange.between(0.6, 0.8),
    ),
    emissionProperties: const EmissionProperties(
      emitDuration: Duration(milliseconds: 500),
      origin: Offset(0.5, 1),
      particleLifespan: DurationRange.single(Duration(seconds: 1, milliseconds: 500)),
    ),
    particleConfiguration: ParticleConfiguration(
      shape: const CircleShape(),
      size: const Size(5, 5),
      postEffectBuilder: (particle, effect) {
        final offset = Offset(
          particle.position.dx / effect.surfaceSize.width,
          particle.position.dy / effect.surfaceSize.height,
        );
        return PhysicsEffectConfiguration(
          physicsProperties: const PhysicsProperties(
            angle: NumRange.between(-180, 180),
            velocity: NumRange.between(Velocity(5), Velocity(5)),
            solidEdges: SolidEdges.none,
          ),
          emissionProperties: EmissionProperties(
            particleCount: 10,
            particlesPerEmit: 10,
            origin: offset,
          ),
          particleConfiguration: const ParticleConfiguration(
            shape: CircleShape(),
            size: Size(5, 5),
            color: SingleParticleColor(color: Colors.blue),
          ),
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
        deterministicProperties: DeterministicProperties(
          distance: NumRange.single(screenSize.height),
          angle: const NumRange.single(90),
        ),
        visualProperties: const VisualProperties(
          endScale: NumRange.single(1),
          fadeOutThreshold: NumRange.between(0.6, 0.8),
        ),
        emissionProperties: const EmissionProperties(
          origin: Offset.zero,
          maxOriginOffset: Offset(1, 0),
          particleLifespan: DurationRange.between(Duration(seconds: 4), Duration(seconds: 7)),
        ),
        particleConfiguration: const ParticleConfiguration(
          shape: CircleShape(),
          size: Size(5, 5),
        ),
      ),
      AvailableEffect.explode: DeterministicEffectConfiguration(
        deterministicProperties: const DeterministicProperties(
          angle: NumRange.between(-180, 180),
        ),
        visualProperties: const VisualProperties(
          endScale: NumRange.single(1),
          fadeOutThreshold: NumRange.between(0.6, 0.8),
        ),
        emissionProperties: const EmissionProperties(
          particleLifespan: DurationRange.between(Duration(seconds: 4), Duration(seconds: 7)),
        ),
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
        deterministicProperties: const DeterministicProperties(
          distance: NumRange.single(200),
        ),
        visualProperties: const VisualProperties(
          endScale: NumRange.single(1),
          fadeOutThreshold: NumRange.single(0.8),
        ),
        emissionProperties: const EmissionProperties(
          emitDuration: Duration(seconds: 1),
          particlesPerEmit: 15,
          particleLifespan: DurationRange.single(Duration(seconds: 4)),
        ),
        particleConfiguration: const ParticleConfiguration(
          shape: CircleShape(),
          size: Size(5, 5),
        ),
      ),
      AvailableEffect.smoke: DeterministicEffectConfiguration(
        deterministicProperties: const DeterministicProperties(
          angle: NumRange.between(-100, -80),
        ),
        visualProperties: const VisualProperties(
          endScale: NumRange.single(1),
          fadeOutThreshold: NumRange.between(0.6, 0.8),
        ),
        emissionProperties: const EmissionProperties(
          particlesPerEmit: 3,
          minOriginOffset: Offset(-.01, 0),
          maxOriginOffset: Offset(.01, 0),
          particleLifespan: DurationRange.between(Duration(seconds: 4), Duration(seconds: 7)),
        ),
        particleConfiguration: const ParticleConfiguration(
          shape: CircleShape(),
          size: Size(5, 5),
        ),
      ),
      AvailableEffect.fountain: DeterministicEffectConfiguration(
        deterministicProperties: const DeterministicProperties(
          distance: NumRange.single(200),
        ),
        visualProperties: const VisualProperties(
          endScale: NumRange.single(1),
          fadeOutThreshold: NumRange.between(0.6, 0.8),
        ),
        emissionProperties: const EmissionProperties(
          particlesPerEmit: 10,
          particleLifespan: DurationRange.single(Duration(seconds: 4)),
        ),
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
        particleConfiguration: const ParticleConfiguration(
          shape: CircleShape(),
          size: Size(5, 5),
        ),
      ),
      AvailableEffect.firework: DeterministicEffectConfiguration(
        deterministicProperties: const DeterministicProperties(
          angle: NumRange.between(-120, -60),
        ),
        visualProperties: const VisualProperties(
          endScale: NumRange.single(1),
          fadeOutThreshold: NumRange.between(0.6, 0.8),
        ),
        emissionProperties: const EmissionProperties(
          emitDuration: Duration(milliseconds: 500),
          particleLifespan: DurationRange.single(Duration(seconds: 2)),
        ),
        layerProperties: const LayerProperties(
          trail: StraightTrail(
            trailWidth: 3,
            trailProgress: .3,
          ),
        ),
        particleConfiguration: ParticleConfiguration(
          shape: const CircleShape(),
          size: const Size(5, 5),
          postEffectBuilder: (particle, effect) {
            final offset = Offset(
              particle.position.dx / effect.surfaceSize.width,
              particle.position.dy / effect.surfaceSize.height,
            );
            return DeterministicEffectConfiguration(
              deterministicProperties: const DeterministicProperties(
                angle: NumRange.between(-180, 180),
              ),
              emissionProperties: EmissionProperties(
                particleCount: 10,
                particlesPerEmit: 10,
                origin: offset,
              ),
              distanceCurve: Curves.decelerate,
              particleConfiguration: const ParticleConfiguration(
                shape: CircleShape(),
                size: Size(5, 5),
                color: SingleParticleColor(color: Colors.blue),
              ),
            );
          },
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
