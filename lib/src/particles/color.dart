import 'package:flutter/material.dart';
import 'package:newton_particles/src/particles/particle.dart';
import 'package:newton_particles/src/utils/color_extensions.dart';

/// An abstract class representing the configuration of particle colors.
/// Subclasses of [ParticleColor] should implement the [configure] method.
sealed class ParticleColor {
  const ParticleColor();

  /// Computes the color based on the [progress].
  /// The [progress] is typically a value between 0 and 1 representing the
  /// animation progress, and [particle] is the particle to be configured.
  ///
  /// Returns the computed color base on the current [progress]
  Color computeColor(double progress);
}

/// A [ParticleColor] subclass representing a single fixed color for particles.
class SingleParticleColor extends ParticleColor {
  /// The fixed color for particles.
  final Color color;

  const SingleParticleColor({required this.color});

  @override
  Color computeColor(double progress) {
    return color;
  }
}

/// A [ParticleColor] subclass representing a linear interpolation of colors
/// for particles.
class LinearInterpolationParticleColor extends ParticleColor {
  /// The list of colors to be interpolated for particles.
  final List<Color> colors;

  const LinearInterpolationParticleColor({required this.colors});

  @override
  Color computeColor(double progress) {
    return colors.lerp(progress);
  }
}
