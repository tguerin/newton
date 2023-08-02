---
sidebar_position: 1
---

# Getting Started

## Installation

To use Newton, simply add it as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  newton_particles: ^0.0.9
```

Then, run `flutter pub get` to fetch the package.

## Usage

1. Import the Newton package:

```dart
import 'package:newton_particles/newton_particles.dart';
```

2. Create a `Newton` widget and add it to your Flutter UI with the desired effects:

```dart
Newton(
    // Add any kind of effects to your UI
    // For example:
    activeEffects: [
        RainEffect(
            particleConfiguration: ParticleConfiguration(
                shape: CircleShape(),
                size: const Size(5, 5),
                color: Colors.black,
            ),
        )
    ],
)
```

Try our [effect configurator](https:://newton.7omtech.fr/configure) to tweak your effect.

## Example

For a quick start, here's an example of creating a simple rain effect using Newton:

```dart
import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Newton Rain Example')),
        body: Newton(
          activeEffects: [
            RainEffect(
                particleConfiguration: ParticleConfiguration(
                    shape: CircleShape(),
                    size: const Size(5, 5),
                    color: Colors.black,
                ),
            )
          ],
        ),
      ),
    );
  }
}
```
