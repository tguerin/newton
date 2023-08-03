import 'dart:math';
import 'dart:ui';

import 'package:vector_math/vector_math_64.dart';

/// A sealed class representing a transformation applied to a path.
sealed class PathTransformation {
  /// Transforms the initial position based on the progress of the transformation.
  ///
  /// The [initialPosition] is the starting position of the transformation.
  /// The [progress] is a value between 0 and 1 representing the progress of the transformation.
  /// Returns the new position after applying the transformation.
  Offset transform(Offset initialPosition, double progress);
}

/// A path transformation that moves the initial position along a straight line.
class StraightPathTransformation extends PathTransformation {
  final double _angleCos;
  final double _angleSin;
  final double distance;

  /// Creates a [StraightPathTransformation] with the given [distance] and an optional [angle].
  /// The [angle] parameter allows specifying the angle of the straight line in degrees.
  /// The [distance] parameter specifies how far the position moves along the straight line.
  StraightPathTransformation({required this.distance, double angle = 0})
      : _angleCos = cos(radians(angle)),
        _angleSin = sin(radians(angle));

  @override
  Offset transform(Offset initialPosition, double progress) {
    return Offset(
      initialPosition.dx + distance * progress * _angleCos,
      initialPosition.dy + distance * progress * _angleSin,
    );
  }
}

/// A path transformation that moves the initial position along a path based on metrics.
class PathMetricsTransformation extends PathTransformation {
  final Path path;

  /// Creates a [PathMetricsTransformation] with the given [path].
  PathMetricsTransformation({required this.path});

  @override
  Offset transform(Offset initialPosition, double progress) {
    final pathMetrics = path.computeMetrics();
    final pathMetric = pathMetrics.elementAt(0);
    final value = pathMetric.length * progress;
    final tangent = pathMetric.getTangentForOffset(value)!;
    return tangent.position;
  }
}
