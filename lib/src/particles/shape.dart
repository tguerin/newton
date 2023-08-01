import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math_64.dart';

/// The `Shape` class represents a drawable shape that can be rendered on a canvas.
///
/// The `Shape` class is an abstract class with a `draw` method that handles drawing the shape
/// on the provided canvas. The `draw` method applies the specified `transform` and `paint`
/// to the shape and then calls the `applyDraw` method to perform the actual drawing.
/// Subclasses of `Shape` must implement the `applyDraw` method to define how the shape is drawn.
sealed class Shape {
  /// Draws the shape on the given canvas at the specified position and size.
  ///
  /// The `draw` method handles applying the `transform` matrix and the `paint` to the shape
  /// before calling the `applyDraw` method to perform the actual drawing of the shape.
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

  /// Applies the actual drawing of the shape on the provided canvas.
  ///
  /// The `applyDraw` method must be implemented by subclasses to define how the shape
  /// is drawn on the canvas. The `position`, `size`, and `paint` parameters are used
  /// to determine the position, size, and style of the shape when drawn.
  @protected
  applyDraw(Canvas canvas, Offset position, Size size, Paint paint);
}

/// The `CircleShape` class represents a circular shape that can be drawn on a canvas.
///
/// The `CircleShape` class extends the `Shape` class and implements the `applyDraw` method
/// to draw a circle on the canvas with the specified position, size, and paint.
class CircleShape extends Shape {
  @override
  applyDraw(Canvas canvas, Offset position, Size size, Paint paint) {
    if (size.width != size.height) {
      throw ArgumentError("width and height must be the same for a circle");
    }
    canvas.drawCircle(position, size.width / 2, paint);
  }
}

/// The `SquareShape` class represents a square shape that can be drawn on a canvas.
///
/// The `SquareShape` class extends the `Shape` class and implements the `applyDraw` method
/// to draw a square on the canvas with the specified position, size, and paint.
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

/// The `ImageShape` class represents an image shape that can be drawn on a canvas.
///
/// The `ImageShape` class extends the `Shape` class and implements the `applyDraw` method
/// to draw an image on the canvas with the specified position, size, and paint.
class ImageShape extends Shape {
  final Image image;

  ImageShape(this.image);

  @override
  applyDraw(Canvas canvas, Offset position, Size size, Paint paint) {
    canvas.drawImage(image, position, paint);
  }
}
