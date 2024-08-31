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
            gravity: const Gravity(0, 9.807),
            origin: Offset.zero,
            maxOriginOffset: const Offset(1, 0),
            maxAngle: 90,
            maxDuration: const Duration(seconds: 7),
            maxEndScale: 1,
            maxFadeOutThreshold: 0.8,
            minAngle: 90,
            minDuration: const Duration(seconds: 4),
            minEndScale: 1,
            minFadeOutThreshold: 0.6,
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
