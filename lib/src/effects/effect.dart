import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:newton_particles/src/particles/animated_particle.dart';
import 'package:newton_particles/src/particles/particle_configuration.dart';
import 'package:newton_particles/src/utils/random_extensions.dart';

abstract class Effect<T extends AnimatedParticle> {
  final List<AnimatedParticle> activeParticles = List.empty(growable: true);

  final random = Random();
  double totalElapsed = 0;
  double _lastInstantiation = 0;
  Size _surfaceSize = const Size(0, 0);

  final ParticleConfiguration particleConfiguration;
  final int emitDuration;
  final int particlesPerEmit;
  final Curve emitCurve;
  final Offset origin;
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

  Effect({
    required this.particleConfiguration,
    this.emitDuration = 100,
    this.emitCurve = Curves.decelerate,
    this.particlesPerEmit = 1,
    this.origin = const Offset(0, 0),
    this.minDistance = 100,
    this.maxDistance = 200,
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
  }) {
    assert(minDistance <= maxDistance,
        "Min distance can't be greater than max distance");
    assert(minDuration <= maxDuration,
        "Min duration can't be greater than max duration");
    assert(minBeginScale <= maxBeginScale,
        "Begin min scale can't be greater than begin max scale");
    assert(minEndScale <= maxEndScale,
        "End min scale can't be greater than end max scale");
    assert(minFadeOutThreshold <= maxFadeOutThreshold,
        "Min fadeOut threshold can't be greater than end max fadeOut threshold");
    assert(minFadeInLimit <= maxFadeInLimit,
        "Min fadeIn limit can't be greater than end max fadeIn threshold");
  }

  AnimatedParticle instantiateParticle(Size surfaceSize);

  @mustCallSuper
  forward(int elapsedMillis) {
    totalElapsed += elapsedMillis;
    if (totalElapsed - _lastInstantiation > emitDuration) {
      _lastInstantiation = totalElapsed;
      for (int i = 0; i < particlesPerEmit; i++) {
        activeParticles.add(instantiateParticle(_surfaceSize));
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

  double randomDistance() {
    return random.nextDoubleRange(minDistance, maxDistance);
  }

  int randomDuration() {
    return random.nextIntRange(minDuration, maxDuration);
  }

  Tween<double> randomScaleRange() {
    final beginScale = random.nextDoubleRange(minBeginScale, maxBeginScale);
    final endScale = (minEndScale < 0 || maxEndScale < 0)
        ? beginScale
        : random.nextDoubleRange(minEndScale, maxEndScale);
    return Tween(begin: beginScale, end: endScale);
  }

  double randomFadeOutThreshold() {
    return random.nextDoubleRange(minFadeOutThreshold, maxFadeOutThreshold);
  }

  double randomFadeInLimit() {
    return random.nextDoubleRange(minFadeInLimit, maxFadeInLimit);
  }
}
