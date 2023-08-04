import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:newton_particles/src/particles/gradient_orientation.dart';
import 'package:newton_particles/src/particles/particle.dart';
import 'package:newton_particles/src/utils/color_extensions.dart';

/// An abstract class representing the configuration of particle colors.
/// Subclasses of [ParticleColor] should implement the [configure] method.
sealed class ParticleColor {
  const ParticleColor();

  /// Configures the color of the given [particle] based on the [progress].
  /// The [progress] is typically a value between 0 and 1 representing the
  /// animation progress, and [particle] is the particle to be configured.
  void configure(double progress, Particle particle);
}

/// A [ParticleColor] subclass representing a single fixed color for particles.
class SingleParticleColor extends ParticleColor {
  /// The fixed color for particles.
  final Color color;

  const SingleParticleColor({required this.color});

  @override
  void configure(double progress, Particle particle) {
    particle.paint.shader = null;
    particle.paint.color = color;
  }
}

/// A [ParticleColor] subclass representing a linear gradient for particles.
class LinearGradientParticleColor extends ParticleColor {
  /// The starting color of the linear gradient.
  final Color startColor;

  /// The ending color of the linear gradient.
  final Color endColor;

  /// The orientation of the linear gradient. See [GradientOrientation]
  final GradientOrientation orientation;

  const LinearGradientParticleColor({
    required this.startColor,
    required this.endColor,
    this.orientation = GradientOrientation.leftRight,
  });

  @override
  void configure(double progress, Particle particle) {
    final (startOffset, endOffset) =
    orientation.computeOffsets(particle.position, particle.size);
    particle.paint.color = Colors.black;
    particle.paint.shader = ui.Gradient.linear(
      startOffset,
      endOffset,
      [
        startColor,
        endColor,
      ],
    );
  }
}

/// A [ParticleColor] subclass representing a linear interpolation of colors
/// for particles.
class LinearInterpolationParticleColor extends ParticleColor {
  /// The list of colors to be interpolated for particles.
  final List<Color> colors;

  const LinearInterpolationParticleColor({required this.colors});

  @override
  void configure(double progress, Particle particle) {
    particle.paint.shader = null;
    particle.paint.color = colors.lerp(progress);
  }
}
