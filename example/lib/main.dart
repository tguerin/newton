import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

void main() {
  runApp(const NewtonExampleApp());
}

class NewtonExampleApp extends StatelessWidget {
  const NewtonExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black, brightness: Brightness.dark),
        canvasColor: const Color(0xff1b1b1d),
      ),
      home: Newton(
        effectConfigurations: [
          // Emulate light balls falling
          PhysicsEffectConfiguration(
            physicsProperties: const PhysicsProperties(
              angle: Range.single(90),
            ),
            visualProperties: const VisualProperties(
              endScale: Range.single(1),
              fadeOutThreshold: Range.between(0.6, 0.8),
            ),
            emissionProperties: const EmissionProperties(
              origin: Offset.zero,
              maxOriginOffset: Offset(1, 0),
              minParticleLifespan: Duration(seconds: 4),
              maxParticleLifespan: Duration(seconds: 7),
            ),
            particleConfiguration: const ParticleConfiguration(
              shape: CircleShape(),
              size: Size(5, 5),
            ),
          ),
        ],
      ),
    );
  }
}
