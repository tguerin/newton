import 'dart:ui';

enum GradientOrientation {
  bottomLeftTopRight,
  bottomTop,
  bottomRightTopLeft,
  leftRight,
  rightLeft,
  topLeftBottomRight,
  topBottom,
  topRightBottomLeft,
}

extension OffsetFromGradientOrientation on GradientOrientation {
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
      default:
        /* topLeftBottomRight */
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
