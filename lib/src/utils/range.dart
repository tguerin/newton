import 'dart:math';
import 'package:flutter/foundation.dart';

/// A sealed base class for ranges that encapsulates a min/max pair.
///
/// This sealed class provides a type-safe way to work with ranges of different types.
/// Use [NumRange] for numeric ranges (int, double) and [DurationRange] for Duration ranges.
///
/// Example usage:
///
/// ```dart
/// final numRange = NumRange.between(0.0, 100.0);
/// final durationRange = DurationRange.between(Duration(seconds: 3), Duration(seconds: 5));
/// ```
sealed class Range<T> {
  /// The minimum value of the range (inclusive).
  T get min;

  /// The maximum value of the range (inclusive).
  T get max;

  /// Checks if the given [value] is within the range [min, max] (inclusive).
  ///
  /// Returns `true` if `min <= value <= max`, `false` otherwise.
  bool contains(T value);

  /// Clamps the given [value] to the range [min, max].
  ///
  /// If [value] is less than [min], returns [min].
  /// If [value] is greater than [max], returns [max].
  /// Otherwise, returns [value] unchanged.
  T clamp(T value);

  /// Creates a copy of this range with the given fields replaced with new values.
  Range<T> copyWith({T? min, T? max});
}

/// A range for numeric types (int, double).
///
/// This class provides utilities for working with numeric ranges, including random value generation.
///
/// Example usage:
///
/// ```dart
/// final range = NumRange.between(0.0, 100.0);
/// final value = range.random(); // Generates a value in [0.0, 100.0]
/// final clamped = range.clamp(150.0); // Returns 100.0
/// ```
@immutable
class NumRange<T extends num> implements Range<T> {
  /// Creates a single-value range where min and max are the same.
  const NumRange.single(T value)
      : min = value,
        max = value;

  /// Creates a range between [min] and [max] (inclusive).
  ///
  /// Throws an assertion error if `min > max`.
  const NumRange.between(this.min, this.max)
      : assert(
          min <= max,
          'Min value must be less than or equal to max value',
        );

  static final Random _rng = Random();

  @override
  final T min;

  @override
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
      return _rng.nextInt(intMax - intMin + 1) + intMin as T;
    }

    // For other types, we can't generate random values
    throw UnsupportedError(
      'Random generation is only supported for numeric types (int, double) and their extension types. '
      'For extension types, access the underlying value and reconstruct the type.',
    );
  }

  @override
  bool contains(T value) {
    return min <= value && value <= max;
  }

  @override
  T clamp(T value) {
    return value < min
        ? min
        : value > max
            ? max
            : value;
  }

  @override
  NumRange<T> copyWith({
    T? min,
    T? max,
  }) {
    return NumRange.between(min ?? this.min, max ?? this.max);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumRange<T> && runtimeType == other.runtimeType && min == other.min && max == other.max;

  @override
  int get hashCode => min.hashCode ^ max.hashCode;

  @override
  String toString() => 'NumRange(min: $min, max: $max)';
}

/// A range for Duration values.
///
/// This class provides utilities for working with Duration ranges, including random value generation.
///
/// Example usage:
///
/// ```dart
/// final range = DurationRange.between(Duration(seconds: 3), Duration(seconds: 5));
/// final value = range.random(); // Generates a Duration in [3s, 5s]
/// final clamped = range.clamp(Duration(seconds: 10)); // Returns Duration(seconds: 5)
/// ```
@immutable
class DurationRange implements Range<Duration> {
  /// Creates a single-value range where min and max are the same.
  const DurationRange.single(Duration value)
      : min = value,
        max = value;

  /// Creates a range between [min] and [max] (inclusive).
  const DurationRange.between(this.min, this.max);

  static final Random _rng = Random();

  @override
  final Duration min;

  @override
  final Duration max;

  /// Generates a random Duration within the range [min, max] (inclusive).
  ///
  /// The generated value is guaranteed to satisfy: `min <= random() <= max`.
  /// For single-value ranges, always returns the same value.
  ///
  /// Returns a random Duration within the range.
  Duration random() {
    if (min == max) {
      return min;
    }

    final minMs = min.inMilliseconds;
    final maxMs = max.inMilliseconds;
    final randomMs = _rng.nextInt(maxMs - minMs + 1) + minMs;
    return Duration(milliseconds: randomMs);
  }

  @override
  bool contains(Duration value) {
    return min <= value && value <= max;
  }

  @override
  Duration clamp(Duration value) {
    return value < min
        ? min
        : value > max
            ? max
            : value;
  }

  @override
  DurationRange copyWith({
    Duration? min,
    Duration? max,
  }) {
    return DurationRange.between(min ?? this.min, max ?? this.max);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DurationRange && min == other.min && max == other.max;

  @override
  int get hashCode => min.hashCode ^ max.hashCode;

  @override
  String toString() => 'DurationRange(min: $min, max: $max)';
}
