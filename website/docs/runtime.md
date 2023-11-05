---
sidebar_position: 5
---

# Runtime effects

Adding/Removing effects at runtime is quite easy:

```dart
import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

final newtonKey = GlobalKey<NewtonState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Newton Rain Example')),
        body: Newton(
          key: newtonKey,
        ),
        TextButton(
          onPressed: () {
            newtonKey.currentState?.addEffect(
              RainEffect(
                  particleConfiguration: ParticleConfiguration(
                    shape: CircleShape(),
                    size: const Size(5, 5),
                    color: const SingleParticleColor(color: Colors.black),
                  ),
                  effectConfiguration: const EffectConfiguration()
              )
            );
          },
          child: const Text('Add Effect'),
        )
      ),
    );
  }
}
```