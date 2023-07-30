import 'dart:ui';

import 'package:newton_particles/src/particles/particle_configuration.dart';
import 'package:vector_math/vector_math_64.dart';

class Particle {
  final ParticleConfiguration configuration;

  final Matrix4 _transform = Matrix4.identity();
  final paint = Paint();
  final Offset initialPosition;

  Offset position;
  Size size;

  Particle({
    required this.configuration,
    required this.position,
    Vector2? rotation,
  })  : size = configuration.size,
        initialPosition = position {
    if (rotation != null) {
      _transform.setRotationX(radians(rotation.x));
      _transform.setRotationY(radians(rotation.y));
    }
    paint.color = configuration.color;
  }

  Size get initialSize => configuration.size;

  draw(Canvas canvas) => configuration.shape.draw(
        canvas,
        position,
        size,
        _transform,
        paint,
      );
}
