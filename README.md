
<picture>
    <source srcset="https://raw.github.com/tguerin/newton/main/graphics/newton-dark.png" media="(prefers-color-scheme: dark)">
    <img
        src=""
        alt=""
      />
</picture>

[![Newton logo](https://raw.github.com/tguerin/newton/main/graphics/newton-light.png#gh-light-mode-only)](https://github.com/tguerin/newton/blob/main/graphics/newton-light.png#gh-light-mode-only)

<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
[![pub package](https://img.shields.io/pub/v/newton_particles.svg)](https://pub.dev/packages/newton_particles)

## Particle Emitter for Flutter

Newton is a highly configurable particle emitter package for Flutter, now with advanced support for both deterministic and physics-based animations. With Newton, you can create captivating animations such as rain, smoke, explosions, and more, along with realistic physics-driven effects like gravity and collisions. This allows you to easily add both visually stunning and physically accurate effects to your Flutter applications, enhancing the user experience with dynamic and interactive animations.

<video width="795" height="599" controls>
  <source src="https://github.com/user-attachments/assets/2ee8bce1-1df6-4f23-b704-a488afe82000" type="video/mp4">
</video>

https://github.com/user-attachments/assets/2ee8bce1-1df6-4f23-b704-a488afe82000

### Features

- **Highly Configurable:** Newton offers an extensive range of options to fine-tune your particle animations. You can adjust particle appearance, behavior, movement, and physics properties, providing complete control over your animations.

- **[Interactive Animation Configurator](https://newton.7omtech.fr/docs/configurator):** Create your particle animations visually using the included app configurator. Experiment with different settings, preview animations in real-time.

- **Custom Particle Design:** Design your particle effects to seamlessly integrate with your app’s aesthetic. Use custom shapes, colors, and sizes to craft truly unique animations that suit your needs.

- **Comprehensive Documentation:** Detailed guides and examples are available to help you easily create popular particle effects like rain, smoke, and explosions.

- **Efficient Performance:** Newton is optimized for performance, ensuring smooth animations even on lower-end devices without compromising on visual quality.


## Installation

To use Newton, simply add it as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  newton_particles: ^0.2.2
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
        RelativisticEffectConfiguration(
            gravity: Gravity.earthGravity,
            maxAngle: 90,
            maxEndScale: 1,
            maxFadeOutThreshold: .8,
            maxOriginOffset: const Offset(1, 0),
            maxParticleLifespan: const Duration(seconds: 10),
            minVelocity: Velocity.stationary,
            maxVelocity: Velocity.stationary,
            minAngle: 90,
            minParticleLifespan: const Duration(seconds: 7),
            minEndScale: 1,
            minFadeOutThreshold: .6,
            origin: Offset.zero,
            particleConfiguration: const ParticleConfiguration(
                shape: CircleShape(),
                size: Size(5, 5),
            ),
        ),
    ],
)
```

Try our [effect configurator](https://newton.7omtech.fr/docs/configurator) to tweak your effect.

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
            RelativisticEffectConfiguration(
              gravity: Gravity.earthGravity,
              maxAngle: 90,
              maxEndScale: 1,
              maxFadeOutThreshold: .8,
              maxOriginOffset: const Offset(1, 0),
              maxParticleLifespan: const Duration(seconds: 10),
              minVelocity: Velocity.stationary,
              maxVelocity: Velocity.stationary,
              minAngle: 90,
              minParticleLifespan: const Duration(seconds: 7),
              minEndScale: 1,
              minFadeOutThreshold: .6,
              origin: Offset.zero,
              particleConfiguration: const ParticleConfiguration(
                shape: CircleShape(),
                size: Size(5, 5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Documentation

For detailed documentation and examples, visit the [Newton Documentation](https://newton.7omtech.fr).

## Contributing

We welcome contributions from the community! If you find any issues or have ideas for improvements, feel free to open an issue or submit a pull request on GitHub.

## License

This project is licensed under the [MIT License](https://github.com/tguerin/newton/blob/main/LICENSE).

---

**Note:** This package is under active development, and breaking changes might be introduced in future versions until a stable 1.0.0 release. Please review the [changelog](CHANGELOG.md) when updating versions.
