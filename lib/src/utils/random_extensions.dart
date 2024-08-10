import 'dart:math';

/// An extension on the `Random` class to provide utility methods for generating random numbers within a specified range.
///
/// This extension adds methods to generate random integers and doubles between a minimum and maximum value, inclusive of the minimum and exclusive of the maximum.
extension RandomRange on Random {
  /// Generates a random integer within the specified range `[min, max)`.
  ///
  /// - [min]: The inclusive minimum bound.
  /// - [max]: The exclusive maximum bound.
  ///
  /// Returns a random integer between `min` and `max`. If `min` equals `max`, the method returns `min`.
  int nextIntRange(int min, int max) {
    if (min == max) {
      return min;
    } else {
      return min + nextInt(max - min);
    }
  }

  /// Generates a random double within the specified range `[min, max)`.
  ///
  /// - [min]: The inclusive minimum bound.
  /// - [max]: The exclusive maximum bound.
  ///
  /// Returns a random double between `min` and `max`. If `min` equals `max`, the method returns `min`.
  double nextDoubleRange(double min, double max) {
    if (min == max) {
      return min;
    } else {
      return min + nextDouble() * (max - min);
    }
  }
}
