---
sidebar_position: 5
---

# Runtime effects

Adding/Removing effects at runtime is quite easy. The `Newton` widget internally uses an `InheritedWidget` to provide access to its state via `Newton.of(context)`.
The only constraint is that the `Newton` widget must be a parent of the widget from which you want to add or remove effects.

```dart
import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Newton Particle Effects Example')),
        body: Newton(
          child: HomeScreen(),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
            Newton.of(context).addEffect(
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
            );
        },
        child: const Text('Add Particle Effect'),
      ),
    );
  }
}
```
