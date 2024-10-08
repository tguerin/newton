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
          RelativisticEffectConfiguration(
            gravity: Gravity.earthGravity,
            origin: Offset.zero,
            maxOriginOffset: const Offset(1, 0),
            maxAngle: 90,
            maxEndScale: 1,
            maxFadeOutThreshold: 0.8,
            maxParticleLifespan: const Duration(seconds: 7),
            minAngle: 90,
            minEndScale: 1,
            minFadeOutThreshold: 0.6,
            minParticleLifespan: const Duration(seconds: 4),
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
