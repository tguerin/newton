
<picture>
    <source srcset="https://raw.github.com/tguerin/newton/main/graphics/newton-dark.png" media="(prefers-color-scheme: dark)">
    <img
        src=""
        alt=""
      />
</picture>

[![Newton logo](https://raw.github.com/tguerin/newton/main/graphics/newton-light.png#gh-light-mode-only)](https://github.com/tguerin/newton/blob/main/graphics/newton-light.png#gh-light-mode-only)

<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>

## Particle Emitter for Flutter

Newton is a highly configurable particle emitter package for Flutter that allows you to create captivating animations such as rain, smoke, explosions, and more. With Newton, you can easily add visually stunning effects to your Flutter applications.

|                                  Rain                                   |                                   Smoke                                   |                                   Pulse                                   |                                    Explode                                    |                                    Fountain                                     |
|:-----------------------------------------------------------------------:|:-------------------------------------------------------------------------:|:-------------------------------------------------------------------------:|:-----------------------------------------------------------------------------:|:-------------------------------------------------------------------------------:|
|  ![Rain](https://raw.github.com/tguerin/newton/main/graphics/rain.gif)  |  ![Smoke](https://raw.github.com/tguerin/newton/main/graphics/smoke.gif)  |  ![Pulse](https://raw.github.com/tguerin/newton/main/graphics/pulse.gif)  |  ![Explode](https://raw.github.com/tguerin/newton/main/graphics/explode.gif)  |  ![Fountain](https://raw.github.com/tguerin/newton/main/graphics/fountain.gif)  |

## Features

- **Highly Configurable:** Newton provides a wide range of options to tweak your particle animations to your liking. You can adjust particle appearance, movement, behavior, and more.

- **Ready-to-Use Presets:** Get started quickly with our collection of pre-built presets for common particle effects like rain, smoke, and explosions.

- **Custom Particle Design:** Tailor your particle effects to match your app's aesthetic. Use custom shapes, colors, and sizes to create unique animations.

- **Efficient Performance:** Newton is designed with performance in mind, ensuring smooth animations even on less powerful devices.

## Installation

To use Newton, simply add it as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  newton_particles: ^0.1.4
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
                color: const SingleParticleColor(color: Colors.black),
            ),
        )
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
            RainEffect(
                particleConfiguration: ParticleConfiguration(
                    shape: CircleShape(),
                    size: const Size(5, 5),
                    color: const SingleParticleColor(color: Colors.black),
                ),
            )
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
