import 'dart:ui';

/// Extension on `List<Color>` providing a method for interpolating colors
/// based on a progress value.
///
/// This extension adds the ability to interpolate between a sequence of colors
/// using a given `progress` value, which should be between 0 and 1 (inclusive).
/// It calculates the appropriate color by dividing the progress range into segments
/// defined by the number of colors in the list.
///
/// Example usage:
/// ```dart
/// List<Color> colors = [Colors.red, Colors.green, Colors.blue];
/// Color interpolatedColor = colors.lerp(0.5); // Interpolates halfway between red and green.
/// ```
///
/// Throws an [AssertionError] if `progress` is greater than 1 or less than 0,
/// or if the list is empty.
extension ColorsInterpolation on List<Color> {
  /// Interpolates between the colors in the list based on the given [progress].
  ///
  /// The [progress] is a double value between 0 and 1, indicating the interpolation
  /// progress between the first and last color in the list.
  ///
  /// If the list contains only one color or the progress is 0, the first color is returned.
  /// If the progress is 1, the last color is returned.
  ///
  /// The interpolation divides the progress range into segments corresponding to
  /// the number of colors. The method then computes the start and end color indices
  /// for interpolation and calculates the interpolation fraction within the segment.
  ///
  /// - [progress]: A double between 0 and 1 representing the interpolation progress.
  ///
  /// Returns the interpolated [Color] for the given progress.
  ///
  /// Example:
  /// ```dart
  /// List<Color> colors = [Colors.red, Colors.green, Colors.blue];
  /// Color interpolatedColor = colors.lerp(0.5); // Interpolates halfway between red and green.
  /// ```
  ///
  /// Throws:
  /// - [AssertionError] if `progress` is greater than 1 or less than 0.
  /// - [AssertionError] if the list is empty.
  Color lerp(double progress) {
    assert(progress <= 1, 'Progress can’t be greater than 1');
    assert(progress >= 0, 'Progress can’t be lower than 0');
    assert(isNotEmpty, 'The colors array must not be empty');

    if (length == 1 || progress <= 0) {
      return first;
    } else if (progress >= 1) {
      return last;
    }

    final segment = 1.0 / (length - 1);
    final startColorIndex = (progress / segment).floor();
    final endColorIndex = (startColorIndex + 1).clamp(0, length - 1);
    final interpolationFraction = (progress - startColorIndex * segment) / segment;

    return Color.lerp(
      this[startColorIndex],
      this[endColorIndex],
      interpolationFraction,
    )!;
  }
}
