import 'package:flutter/cupertino.dart';
import 'package:newton_particles/src/effects/effect.dart';

class NewtonPainter extends CustomPainter {
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
