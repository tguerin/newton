import 'dart:ui';

extension ColorsInterpolation on List<Color> {
  /// Extension on `List<Color>` providing a method for interpolating colors based on a progress value.
  ///
  /// Interpolates between a list of colors based on the given `progress` value.
  /// The `progress` value should be a double between 0 and 1 (inclusive).
  /// It represents the interpolation progress between the first and last color in the list.
  ///
  /// The method returns the interpolated color for the given progress value.
  ///
  /// Throws an [AssertionError] if `progress` is greater than 1 or lower than 0.
  /// Throws an [AssertionError] if the list is empty.
  ///
  /// The interpolation is done by dividing the `progress` range into segments based on the number of colors in the list.
  /// The method then calculates the start and end color indices for the interpolation and the interpolation fraction within the segment.
  ///
  /// Example usage:
  /// ```dart
  /// List<Color> colors = [Colors.red, Colors.green, Colors.blue];
  /// Color interpolatedColor = colors.lerp(0.5); // Interpolates halfway between red and green.
  /// ```
  Color lerp(double progress) {
    assert(progress <= 1, "Progress can't be greater than 1");
    assert(progress >= 0, "Progress can't be lower than 0");
    assert(isNotEmpty, "The colors array must not be empty");

    if (length == 1 || progress <= 0) {
      return first;
    } else if (progress >= 1) {
      return last;
    }

    final segment = 1.0 / (length - 1);
    final startColorIndex = (progress / segment).floor();
    final endColorIndex = (startColorIndex + 1).clamp(0, length - 1);
    final double interpolationFraction =
        (progress - startColorIndex * segment) / segment;

    return Color.lerp(
      this[startColorIndex],
      this[endColorIndex],
      interpolationFraction,
    )!;
  }
}
