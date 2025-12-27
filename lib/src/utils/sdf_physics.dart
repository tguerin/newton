import 'dart:math' as math;
import 'dart:ui';

/// Utility class for Signed Distance Field (SDF) calculations for rounded rectangles.
///
/// This class provides methods to calculate distances and normals for RRect shapes,
/// which are used for accurate collision detection with rounded corners.
class SDFPhysics {
  /// Calculates the Signed Distance from point [p] to [rrect].
  ///
  /// - [p]: The point to check.
  /// - [rrect]: The rounded rectangle to check distance against.
  ///
  /// Returns:
  /// - Negative value if point is inside the RRect
  /// - Positive value if point is outside the RRect
  /// - Zero if point is exactly on the surface
  static double getDistanceToRRect(Offset p, RRect rrect) {
    // For simplicity, use the maximum radius (assuming uniform radius)
    // In practice, you might want to handle different corner radii
    final radius = math.max(
      math.max(rrect.tlRadiusX, rrect.trRadiusX),
      math.max(rrect.blRadiusX, rrect.brRadiusX),
    );

    // Position relative to center
    final dx = (p.dx - rrect.center.dx).abs() - (rrect.width / 2 - radius);
    final dy = (p.dy - rrect.center.dy).abs() - (rrect.height / 2 - radius);

    final externalDist = Offset(
      dx > 0 ? dx : 0,
      dy > 0 ? dy : 0,
    ).distance;

    final internalDist = (dx < dy ? dy : dx).clamp(-double.infinity, 0.0);

    return externalDist + internalDist - radius;
  }

  /// Calculates the surface normal (direction) at point [p] relative to [rrect].
  ///
  /// The normal points outward from the RRect surface.
  ///
  /// - [p]: The point to calculate the normal at.
  /// - [rrect]: The rounded rectangle.
  ///
  /// Returns a normalized offset representing the surface normal.
  static Offset getNormal(Offset p, RRect rrect) {
    const eps = 0.1;
    final dX =
        getDistanceToRRect(p + const Offset(eps, 0), rrect) - getDistanceToRRect(p - const Offset(eps, 0), rrect);
    final dY =
        getDistanceToRRect(p + const Offset(0, eps), rrect) - getDistanceToRRect(p - const Offset(0, eps), rrect);

    final normal = Offset(dX, dY);
    final length = normal.distance;
    if (length < 1e-10) {
      return Offset.zero;
    }
    return normal / length;
  }

  /// Calculates the reflection of a velocity vector off a surface.
  ///
  /// Uses the standard reflection formula: v' = v - 2 * (v · n) * n
  ///
  /// - [velocity]: The incoming velocity vector.
  /// - [normal]: The surface normal (should be normalized).
  ///
  /// Returns the reflected velocity vector.
  static Offset reflect(Offset velocity, Offset normal) {
    final dot = velocity.dx * normal.dx + velocity.dy * normal.dy;
    return velocity - normal * (2 * dot);
  }
}
