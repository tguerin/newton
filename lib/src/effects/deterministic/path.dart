import 'dart:math';
import 'dart:ui';

import 'package:newton_particles/newton_particles.dart';
import 'package:vector_math/vector_math_64.dart';

/// A sealed class representing a transformation applied to a path.
///
/// This class provides an interface for transforming an initial position
/// along a path based on the progress of the transformation. It is intended
/// to be extended by subclasses that define specific transformation behaviors.
sealed class DeterministicPathTransformation {
  /// Transforms the initial position based on the progress of the transformation.
  ///
  /// The [initialPosition] is the starting position of the transformation.
  /// The [progress] is a value between 0 and 1 representing the progress of the transformation.
  ///
  /// Returns the new position after applying the transformation.
  Offset positionFor(Particle particle, double progress);
}

/// A path transformation that moves the initial position along a straight line.
///
/// This transformation moves the position in a straight line defined by a distance
/// and an optional angle. The movement is linear and calculated using trigonometric
/// functions based on the angle.
class StraightPathTransformation extends DeterministicPathTransformation {
  /// Creates a [StraightPathTransformation] with the given [distance] and an optional [angle].
  ///
  /// The [angle] parameter allows specifying the angle of the straight line in degrees.
  /// The [distance] parameter specifies how far the position moves along the straight line.
  StraightPathTransformation({required this.distance, this.angle = 0})
      : _angleCos = cos(radians(angle)),
        _angleSin = sin(radians(angle));

  /// The angle of the straight path in degrees.
  final double angle;

  /// The cosine of the angle, used for calculating horizontal movement.
  final double _angleCos;

  /// The sine of the angle, used for calculating vertical movement.
  final double _angleSin;

  /// The total distance the position moves along the straight line.
  final double distance;

  @override
  Offset positionFor(Particle particle, double progress) {
    return Offset(
      particle.initialPosition.dx + distance * progress * _angleCos,
      particle.initialPosition.dy + distance * progress * _angleSin,
    );
  }
}

/// A path transformation that moves the initial position along a path based on metrics.
///
/// This transformation uses the metrics of a defined [Path] to calculate the position
/// along the path. The position is determined by the progress of the transformation
/// along the path's length.
class PathMetricsTransformation extends DeterministicPathTransformation {
  /// Creates a [PathMetricsTransformation] with the given [path].
  ///
  /// The [path] is used to compute the metrics that guide the transformation along
  /// its length based on the progress.
  PathMetricsTransformation({required this.path});

  /// The path used to compute metrics for the transformation.
  final Path path;

  @override
  Offset positionFor(Particle particle, double progress) {
    final pathMetrics = path.computeMetrics();
    final pathMetric = pathMetrics.elementAt(0);
    final value = pathMetric.length * progress;
    final tangent = pathMetric.getTangentForOffset(value)!;
    return tangent.position;
  }
}
