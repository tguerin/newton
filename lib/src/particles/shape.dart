import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math_64.dart';

sealed class Shape {
  @nonVirtual
  draw(Canvas canvas, Offset position, Size size, Matrix4 transform,
      Paint paint) {
    var isCanvasTransformed = !transform.isIdentity();
    if (isCanvasTransformed) {
      canvas.save();
      canvas.transform(transform.storage);
    }
    applyDraw(canvas, position, size, paint);
    if (isCanvasTransformed) {
      canvas.restore();
    }
  }

  @protected
  applyDraw(Canvas canvas, Offset position, Size size, Paint paint);
}

class CircleShape extends Shape {
  @override
  applyDraw(Canvas canvas, Offset position, Size size, Paint paint) {
    if (size.width != size.height) {
      throw ArgumentError("width and height must be the same for a circle");
    }
    canvas.drawCircle(position, size.width / 2, paint);
  }
}

class SquareShape extends Shape {
  @override
  applyDraw(Canvas canvas, Offset position, Size size, Paint paint) {
    canvas.drawRect(
      Rect.fromLTWH(
        position.dx - size.width / 2,
        position.dy - size.height / 2,
        size.width,
        size.height,
      ),
      paint,
    );
  }
}

class ImageShape extends Shape {
  final Image image;

  ImageShape(this.image);

  @override
  applyDraw(Canvas canvas, Offset position, Size size, Paint paint) {
    canvas.drawImage(image, position, paint);
  }
}
