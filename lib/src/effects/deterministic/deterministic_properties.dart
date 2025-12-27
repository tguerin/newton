import 'package:flutter/foundation.dart';
import 'package:newton_particles/src/utils/range.dart';

/// Groups all deterministic-related properties for particle effects.
///
/// This class encapsulates distance and angle ranges with comprehensive validations
/// to ensure all values are within acceptable ranges.
///
/// Example usage:
///
/// ```dart
/// final properties = DeterministicProperties(
///   distance: Range.between(100.0, 200.0),
///   angle: Range.between(-180.0, 180.0),
/// );
/// ```
@immutable
class DeterministicProperties {
  /// Creates a [DeterministicProperties] instance with the specified deterministic properties.
  ///
  /// All ranges must have valid min/max values, and individual properties must
  /// satisfy their constraints:
  /// - Distance: > 0.0
  /// - Angle: -180.0 to 180.0 degrees
  const DeterministicProperties({
    this.distance = const Range.between(100, 200),
    this.angle = const Range.single(0),
  });

  /// Creates a [DeterministicProperties] for a radial explosion effect.
  ///
  /// Defaults:
  /// - Distance: 50.0 to 300.0 (varying distances)
  /// - Angle: -180.0 to 180.0 (all directions)
  ///
  /// All parameters are optional and can be overridden.
  factory DeterministicProperties.explosion({
    Range<double> distance = const Range.between(50, 300),
    Range<double> angle = const Range.between(-180, 180),
  }) {
    return DeterministicProperties(
      distance: distance,
      angle: angle,
    );
  }

  /// Creates a [DeterministicProperties] for a downward rain effect.
  ///
  /// Defaults:
  /// - Distance: 200.0 to 500.0 (falling distance)
  /// - Angle: 90.0 (straight down)
  ///
  /// All parameters are optional and can be overridden.
  factory DeterministicProperties.rain({
    Range<double> distance = const Range.between(200, 500),
    Range<double> angle = const Range.single(90),
  }) {
    return DeterministicProperties(
      distance: distance,
      angle: angle,
    );
  }

  /// The distance range for particles.
  final Range<double> distance;

  /// The angle range for particles.
  final Range<double> angle;

  /// Generates a random distance within the specified range.
  double randomDistance() {
    return distance.random();
  }

  /// Generates a random angle within the specified range.
  double randomAngle() {
    return angle.random();
  }

  /// Creates a copy of this [DeterministicProperties] with the given fields replaced with new values.
  DeterministicProperties copyWith({
    Range<double>? distance,
    Range<double>? angle,
  }) {
    return DeterministicProperties(
      distance: distance ?? this.distance,
      angle: angle ?? this.angle,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeterministicProperties &&
          runtimeType == other.runtimeType &&
          distance == other.distance &&
          angle == other.angle;

  @override
  int get hashCode => distance.hashCode ^ angle.hashCode;

  @override
  String toString() => 'DeterministicProperties(distance: $distance, angle: $angle)';
}
