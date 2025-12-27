import 'package:flutter/foundation.dart';

/// The `Gravity` class represents a gravitational force in the 2D plane.
///
/// This class encapsulates gravitational forces along the x-axis (`dx`) and y-axis (`dy`), allowing
/// for customized gravity in particle systems or physics simulations. The class also provides some
/// predefined constants, such as `zero` (no gravity) and `earthGravity` (standard Earth gravity).
///
/// Example usage:
///
/// ```dart
/// final gravity = Gravity.earthGravity;
/// print(gravity.dy); // Output: 9.807
/// ```
@immutable
class Gravity {
  /// Creates a `Gravity` instance with the specified gravitational forces along the x and y axes.
  const Gravity(this.dx, this.dy);

  /// The gravitational force along the x-axis.
  final double dx;

  /// The gravitational force along the y-axis.
  final double dy;

  /// Represents no gravity, with `dx = 0` and `dy = 0`.
  static const zero = Gravity(0, 0);

  /// Represents standard Earth gravity, with `dx = 0` and `dy = 9.807 m/s²`.
  static const earthGravity = Gravity(0, 9.807);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Gravity && runtimeType == other.runtimeType && dx == other.dx && dy == other.dy;

  @override
  int get hashCode => dx.hashCode ^ dy.hashCode;

  @override
  String toString() {
    return 'Gravity{dx: $dx, dy: $dy}';
  }
}

/// The `SolidEdges` class is used to specify which edges of a 2D boundary are solid, meaning that
/// particles or objects will interact with them as impenetrable boundaries.
///
/// This class provides constructors to define solid edges on specific sides (`left`, `top`, `right`, `bottom`)
/// and predefined constants such as `none` (no solid edges) and `all` (all edges are solid).
///
/// Example usage:
///
/// ```dart
/// final edges = SolidEdges.only(left: true, top: false);
/// print(edges.left); // Output: true
/// ```
class SolidEdges {
  /// Creates a `SolidEdges` instance with specific edges set to solid.
  ///
  /// By default, all edges are set to `false` (not solid).
  const SolidEdges.only({
    this.left = false,
    this.top = false,
    this.right = false,
    this.bottom = false,
  });

  /// Creates a `SolidEdges` instance where all edges are set to solid.
  const SolidEdges.all()
      : left = true,
        top = true,
        right = true,
        bottom = true;

  /// Represents no solid edges, where all edges are set to `false`.
  static const none = SolidEdges.only();

  /// Indicates if the left edge is solid.
  final bool left;

  /// Indicates if the top edge is solid.
  final bool top;

  /// Indicates if the right edge is solid.
  final bool right;

  /// Indicates if the bottom edge is solid.
  final bool bottom;
}
