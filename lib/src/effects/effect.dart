import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:newton_particles/src/effects/effect_configuration.dart';
import 'package:newton_particles/src/particles/animated_particle.dart';
import 'package:newton_particles/src/particles/particle_configuration.dart';
import 'package:newton_particles/src/utils/random_extensions.dart';

abstract class Effect<T extends AnimatedParticle> {
  final List<AnimatedParticle> activeParticles = List.empty(growable: true);

  final random = Random();
  double totalElapsed = 0;
  double _lastInstantiation = 0;
  Size _surfaceSize = const Size(0, 0);

  bool _stopEmission = false;

  final EffectConfiguration effectConfiguration;

  final ParticleConfiguration particleConfiguration;

  Effect({
    required this.particleConfiguration,
    required this.effectConfiguration,
  });

  AnimatedParticle instantiateParticle(Size surfaceSize);

  @mustCallSuper
  forward(int elapsedMillis) {
    totalElapsed += elapsedMillis;
    if (totalElapsed - _lastInstantiation > effectConfiguration.emitDuration) {
      _lastInstantiation = totalElapsed;
      if (!_stopEmission) {
        for (int i = 0; i < effectConfiguration.particlesPerEmit; i++) {
          activeParticles.add(instantiateParticle(_surfaceSize));
        }
      }
    }
    activeParticles.removeWhere((activeParticle) {
      return activeParticle.animationDuration <
          totalElapsed - activeParticle.startTime;
    });
    for (var element in activeParticles) {
      element.onAnimationUpdate(
          (totalElapsed - element.startTime) / element.animationDuration);
    }
  }

  set surfaceSize(Size value) {
    for (var particle in activeParticles) {
      particle.onSurfaceSizeChanged(_surfaceSize, value);
    }
    _surfaceSize = value;
  }

  start() {
    _stopEmission = false;
  }

  stop({bool cancel = false}) {
    _stopEmission = true;
    if (cancel) {
      activeParticles.clear();
    }
  }

  bool get isStopped => _stopEmission;

  double randomDistance() {
    return random.nextDoubleRange(
      effectConfiguration.minDistance,
      effectConfiguration.maxDistance,
    );
  }

  double randomAngle() {
    return random.nextDoubleRange(
      effectConfiguration.minAngle,
      effectConfiguration.maxAngle,
    );
  }

  int randomDuration() {
    return random.nextIntRange(
      effectConfiguration.minDuration,
      effectConfiguration.maxDuration,
    );
  }

  Tween<double> randomScaleRange() {
    final beginScale = random.nextDoubleRange(
      effectConfiguration.minBeginScale,
      effectConfiguration.maxBeginScale,
    );
    final endScale = (effectConfiguration.minEndScale < 0 ||
            effectConfiguration.maxEndScale < 0)
        ? beginScale
        : random.nextDoubleRange(
            effectConfiguration.minEndScale, effectConfiguration.maxEndScale);
    return Tween(begin: beginScale, end: endScale);
  }

  double randomFadeOutThreshold() {
    return random.nextDoubleRange(
      effectConfiguration.minFadeOutThreshold,
      effectConfiguration.maxFadeOutThreshold,
    );
  }

  double randomFadeInLimit() {
    return random.nextDoubleRange(
      effectConfiguration.minFadeInLimit,
      effectConfiguration.maxFadeInLimit,
    );
  }
}
