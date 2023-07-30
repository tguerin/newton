import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:newton_particles/src/particles/particle.dart';
import 'package:vector_math/vector_math.dart';

class AnimatedParticle {
  final Particle particle;
  final int animationDuration;
  final double startTime;
  final double distance;
  final Curve distanceCurve;
  final double angle;
  final double fadeOutThreshold;
  final Curve fadeOutCurve;
  final double fadeInLimit;
  final Curve fadeInCurve;
  final Tween<double> scaleRange;
  final Curve scaleCurve;

  final double _angleCos;
  final double _angleSin;

  AnimatedParticle({
    required this.particle,
    required this.startTime,
    required this.animationDuration,
    required this.distance,
    required this.distanceCurve,
    required this.angle,
    required this.fadeInLimit,
    required this.fadeInCurve,
    required this.fadeOutThreshold,
    required this.fadeOutCurve,
    required Tween<double>? scaleRange,
    required this.scaleCurve,
  })  : _angleCos = cos(radians(angle)),
        _angleSin = sin(radians(angle)),
        scaleRange = scaleRange ?? Tween<double>(begin: 1, end: 1);

  onAnimationUpdate(double progress) {
    if (progress <= fadeInLimit && fadeInLimit != 0) {
      final fadeInProgress = progress / fadeInLimit;
      final opacity = fadeInCurve.transform(fadeInProgress);
      particle.paint.color = particle.configuration.color.withOpacity(opacity);
    }

    if (progress >= fadeOutThreshold && fadeOutThreshold != 1) {
      var fadeOutProgress =
          (progress - fadeOutThreshold) / (1 - fadeOutThreshold);
      final opacity = 1 - fadeOutCurve.transform(fadeOutProgress);
      particle.paint.color = particle.configuration.color.withOpacity(opacity);
    }

    final currentScale = scaleRange.transform(scaleCurve.transform(progress));
    particle.size = Size(
      particle.initialSize.width * currentScale,
      particle.initialSize.height * currentScale,
    );

    var distanceProgress = distanceCurve.transform(progress);
    particle.position = Offset(
      particle.initialPosition.dx + (distance * distanceProgress) * _angleCos,
      particle.initialPosition.dy + (distance * distanceProgress) * _angleSin,
    );
  }

  onSurfaceSizeChanged(Size oldSize, Size newSize) {}
}
