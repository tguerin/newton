import 'package:flutter/cupertino.dart';
import 'package:newton_particles/src/effects/effect.dart';

/// A custom painter that renders particle effects on a canvas in Newton.
///
/// The `NewtonPainter` class extends `CustomPainter` and is responsible for painting
/// the active particles of the specified effects onto the provided canvas.
class NewtonPainter extends CustomPainter {
  /// The list of particle effects to be rendered on the canvas.
  final List<Effect> effects;

  NewtonPainter({required this.effects});

  @override
  void paint(Canvas canvas, Size size) {
    effects
        .expand((effect) => effect.activeParticles.map((e) => e.particle))
        .forEach((particle) {
      particle.draw(canvas);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return effects.isNotEmpty;
  }
}
