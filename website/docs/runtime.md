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
        appBar: AppBar(title: const Text('Newton Rain Example')),
        body: Newton(
            key: newtonKey,
            child: TextButton(
              onPressed: () {
                newtonKey.currentState?.addEffect(RainEffect(
                    particleConfiguration: ParticleConfiguration(
                      color: const SingleParticleColor(color: Colors.black),
                      shape: CircleShape(),
                      size: const Size(5, 5),
                    ),
                    effectConfiguration: const EffectConfiguration()));
              },
              child: const Text('Add Effect'),
            )),
      ),
    );
  }
}
```
