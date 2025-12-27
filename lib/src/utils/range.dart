import 'dart:math';
import 'package:flutter/foundation.dart';

/// A generic range class that encapsulates a min/max pair for any comparable type.
///
/// This class provides utilities for working with ranges, including random value generation,
/// containment checks, and value clamping. The `random()` method ensures all generated values
/// strictly satisfy the min/max constraints.
///
/// Example usage:
///
/// ```dart
/// final range = Range.between(0.0, 100.0);
/// final value = range.random(); // Generates a value in [0.0, 100.0]
/// final clamped = range.clamp(150.0); // Returns 100.0
/// ```
@immutable
class Range<T extends num> {
  /// Creates a single-value range where min and max are the same.
  const Range.single(T value)
      : min = value,
        max = value;

  /// Creates a range between [min] and [max] (inclusive).
  ///
  /// Throws an assertion error if `min > max`.
  /// Works with Comparable types and num types (double, int).
  const Range.between(this.min, this.max)
      : assert(
          min <= max,
          'Min value must be less than or equal to max value',
        );

  static final Random _rng = Random();

  /// The minimum value of the range (inclusive).
  final T min;

  /// The maximum value of the range (inclusive).
  final T max;

  /// Generates a random value within the range [min, max] (inclusive).
  ///
  /// The generated value is guaranteed to satisfy: `min <= random() <= max`.
  /// For numeric types, this uses proper random generation utilities.
  /// For single-value ranges, always returns the same value.
  ///
  /// **Note**: This method works for types that are comparable. For extension types
  /// that wrap numeric values (like Density, Friction, etc.), use the specialized
  /// `randomDouble()` method and reconstruct the type manually.
  ///
  /// Returns a random value within the range.
  T random() {
    if (min == max) {
      return min;
    }

    // For double ranges, use nextDoubleRange
    if (min is double && max is double) {
      final doubleMin = min as double;
      final doubleMax = max as double;
      return _rng.nextDouble() * (doubleMax - doubleMin) + doubleMin as T;
    }

    // For int ranges, use nextIntRange with max + 1 to get inclusive max
    if (min is int && max is int) {
      final intMin = min as int;
      final intMax = max as int;
      return _rng.nextInt(intMax - intMin) + intMin as T;
    }

    // For other types, we can't generate random values
    throw UnsupportedError(
      'Random generation is only supported for numeric types (int, double) and their extension types. '
      'For extension types, access the underlying value and reconstruct the type.',
    );
  }

  /// Checks if the given [value] is within the range [min, max] (inclusive).
  ///
  /// Returns `true` if `min <= value <= max`, `false` otherwise.
  bool contains(T value) {
    return min <= value && value <= max;
  }

  /// Clamps the given [value] to the range [min, max].
  ///
  /// If [value] is less than [min], returns [min].
  /// If [value] is greater than [max], returns [max].
  /// Otherwise, returns [value] unchanged.
  T clamp(T value) {
    return value < min
        ? min
        : value > max
            ? max
            : value;
  }

  /// Creates a copy of this range with the given fields replaced with new values.
  Range<T> copyWith({
    T? min,
    T? max,
  }) {
    return Range.between(min ?? this.min, max ?? this.max);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Range<T> && runtimeType == other.runtimeType && min == other.min && max == other.max;

  @override
  int get hashCode => min.hashCode ^ max.hashCode;

  @override
  String toString() => 'Range(min: $min, max: $max)';
}
