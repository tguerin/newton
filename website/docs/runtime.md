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
              PhysicsEffectConfiguration(
              physicsProperties: const PhysicsProperties(
                gravity: Gravity.earthGravity,
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
            );
        },
        child: const Text('Add Particle Effect'),
      ),
    );
  }
}
```
