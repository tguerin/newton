import 'dart:ui';

/// Defines the orientation of a gradient in 2D space.
enum GradientOrientation {
  /// Gradient from the bottom-left to the top-right.
  bottomLeftTopRight,

  /// Gradient from the bottom to the top.
  bottomTop,

  /// Gradient from the bottom-right to the top-left.
  bottomRightTopLeft,

  /// Gradient from the left to the right.
  leftRight,

  /// Gradient from the right to the left.
  rightLeft,

  /// Gradient from the top-left to the bottom-right.
  topLeftBottomRight,

  /// Gradient from the top to the bottom.
  topBottom,

  /// Gradient from the top-right to the bottom-left.
  topRightBottomLeft,
}

/// Extension on [GradientOrientation] to compute start and end offsets
/// for a gradient based on its orientation.
extension OffsetFromGradientOrientation on GradientOrientation {
  /// Computes the start and end [Offset]s for the gradient based on the
  /// [position] and [size] of the canvas.
  ///
  /// This method returns a tuple containing the start and end offsets
  /// calculated according to the orientation of the gradient.
  ///
  /// - [position]: The central [Offset] of the gradient.
  /// - [size]: The [Size] of the area over which the gradient is applied.
  ///
  /// Returns a tuple `(Offset start, Offset end)` where `start` and `end`
  /// are the computed offsets for the gradient's direction.
  (Offset, Offset) computeOffsets(Offset position, Size size) {
    switch (this) {
      case GradientOrientation.topBottom:
        return (
          Offset(
            position.dx - size.width / 2,
            position.dy - size.height / 2,
          ),
          Offset(
            position.dx - size.width / 2,
            position.dy + size.height / 2,
          )
        );
      case GradientOrientation.topRightBottomLeft:
        return (
          Offset(
            position.dx + size.width / 2,
            position.dy - size.height / 2,
          ),
          Offset(
            position.dx - size.width / 2,
            position.dy + size.height / 2,
          )
        );
      case GradientOrientation.rightLeft:
        return (
          Offset(
            position.dx + size.width / 2,
            position.dy - size.height / 2,
          ),
          Offset(
            position.dx - size.width / 2,
            position.dy - size.height / 2,
          )
        );
      case GradientOrientation.bottomRightTopLeft:
        return (
          Offset(
            position.dx + size.width / 2,
            position.dy + size.height / 2,
          ),
          Offset(
            position.dx - size.width / 2,
            position.dy - size.height / 2,
          )
        );
      case GradientOrientation.bottomTop:
        return (
          Offset(
            position.dx - size.width / 2,
            position.dy + size.height / 2,
          ),
          Offset(
            position.dx - size.width / 2,
            position.dy - size.height / 2,
          )
        );
      case GradientOrientation.bottomLeftTopRight:
        return (
          Offset(
            position.dx - size.width / 2,
            position.dy + size.height / 2,
          ),
          Offset(
            position.dx + size.width / 2,
            position.dy - size.height / 2,
          )
        );
      case GradientOrientation.leftRight:
        return (
          Offset(
            position.dx - size.width / 2,
            position.dy - size.height / 2,
          ),
          Offset(
            position.dx + size.width / 2,
            position.dy - size.height / 2,
          )
        );
      case GradientOrientation.topLeftBottomRight:
        return (
          Offset(
            position.dx - size.width / 2,
            position.dy - size.height / 2,
          ),
          Offset(
            position.dx + size.width / 2,
            position.dy + size.height / 2,
          )
        );
    }
  }
}
