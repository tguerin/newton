import 'dart:ui';

import 'package:newton_particles/src/utils/color_extensions.dart';

/// An abstract class representing the configuration of particle colors.
///
/// Subclasses of [ParticleColor] should implement the [computeColor] method
/// to define how the color is computed based on animation progress.
sealed class ParticleColor {
  /// Constructs a [ParticleColor] instance.
  const ParticleColor();

  /// Computes the color based on the [progress].
  ///
  /// The [progress] parameter is typically a value between 0 and 1 representing
  /// the animation progress. The implementation should return the computed color
  /// based on the current [progress].
  ///
  /// - [progress]: A double value indicating the progress of the animation.
  ///
  /// Returns the computed [Color].
  Color computeColor(double progress);
}

/// A [ParticleColor] subclass representing a single fixed color for particles.
///
/// This class provides a constant color regardless of the animation progress.
class SingleParticleColor extends ParticleColor {
  /// Constructs a [SingleParticleColor] with the specified [color].
  ///
  /// - [color]: The fixed color to be used for the particles.
  const SingleParticleColor({required this.color});

  /// The fixed color for particles.
  final Color color;

  @override
  Color computeColor(double progress) {
    // Returns the fixed color, ignoring progress.
    return color;
  }
}

/// A [ParticleColor] subclass representing a linear interpolation of colors
/// for particles based on animation progress.
class LinearInterpolationParticleColor extends ParticleColor {
  /// Constructs a [LinearInterpolationParticleColor] with a list of [colors].
  ///
  /// - [colors]: The list of colors to be interpolated for the particles.
  ///   The interpolation will compute intermediate colors between these based
  ///   on the animation progress.
  const LinearInterpolationParticleColor({required this.colors});

  /// The list of colors to be interpolated for particles.
  final List<Color> colors;

  @override
  Color computeColor(double progress) {
    // Interpolates the color based on progress using the colors list.
    return colors.lerp(progress);
  }
}
