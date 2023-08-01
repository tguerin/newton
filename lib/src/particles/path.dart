import 'dart:math';
import 'dart:ui';

import 'package:vector_math/vector_math_64.dart';

/// The `Path` class represents a path for calculating particle positions based on angles.
///
/// The `angleCos` and `angleSin` properties store the cosine and sine values of the `angle`,
/// respectively, to be used for trigonometric calculations.
sealed class Path {
  /// The cosine value of the angle used for trigonometric calculations.
  final double angleCos;

  /// The sine value of the angle used for trigonometric calculations.
  final double angleSin;

  /// Creates a `Path` with the specified `angle` (in degrees).
  ///
  /// The `angle` parameter is optional and represents the angle of the path in degrees.
  Path({double angle = 0})
      : angleCos = cos(radians(angle)),
        angleSin = sin(radians(angle));

  /// Computes the new position based on the `initialPosition` and `distance` along the path.
  ///
  /// The `initialPosition` parameter represents the starting position.
  /// The `distance` parameter represents the distance along the path.
  ///
  /// Returns the calculated [Offset] of the new position.
  Offset computePosition(Offset initialPosition, double distance);
}

/// The `StraightPath` class represents a straight path for calculating particle positions.
///
/// The `StraightPath` class extends the [Path] class and overrides the `computePosition` method
/// to calculate the position of particles in a straight line based on the angle of the path.
class StraightPath extends Path {
  /// Creates a `StraightPath` with the specified `angle` (in degrees).
  ///
  /// The `angle` parameter is optional and represents the angle of the straight path in degrees.
  StraightPath({double angle = 0}) : super(angle: angle);

  /// Computes the new position based on the `initialPosition` and `distance` along the straight path.
  ///
  /// The `initialPosition` parameter represents the starting position.
  /// The `distance` parameter represents the distance along the straight path.
  ///
  /// Returns the calculated [Offset] of the new position along the straight path.
  @override
  Offset computePosition(Offset initialPosition, double distance) {
    return Offset(
      initialPosition.dx + distance * angleCos,
      initialPosition.dy + distance * angleSin,
    );
  }
}
