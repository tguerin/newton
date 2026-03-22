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

Newton is a highly configurable particle emitter package for Flutter, now with
advanced support for both deterministic and physics-based animations. With
Newton, you can create captivating animations such as rain, smoke, explosions,
and more, along with realistic physics-driven effects like gravity and
collisions. This allows you to easily add both visually stunning and physically
accurate effects to your Flutter applications, enhancing the user experience
with dynamic and interactive animations.

![ezgif-2-55326df4fb](https://github.com/user-attachments/assets/4a59ba88-6741-4495-b87d-31ab2e7cad76)

### Features

- **Highly Configurable:** Newton offers an extensive range of options to
  fine-tune your particle animations. You can adjust particle appearance,
  behavior, movement, and physics properties, providing complete control over
  your animations.

- **[Interactive Animation Configurator](https://newton.7omtech.fr/docs/configurator):**
  Create your particle animations visually using the included app configurator.
  Experiment with different settings, preview animations in real-time, and copy
  the generated code directly into your project.

- **Custom Particle Design:** Design your particle effects to seamlessly
  integrate with your app’s aesthetic. Use custom shapes, colors, and sizes to
  craft truly unique animations that suit your needs.

- **Comprehensive Documentation:** Detailed guides and examples are available to
  help you easily create popular particle effects like rain, smoke, and
  explosions.

- **Widget Collisions:** Particles can interact with Flutter widgets using
  `NewtonCollider`, creating engaging interactive effects with accurate physics
  including support for rounded corners.

- **Efficient Performance:** Newton is optimized for performance, ensuring
  smooth animations even on lower-end devices without compromising on visual
  quality.

## Installation

To use Newton, simply add it as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  newton_particles: ^0.4.1
```

Then, run `flutter pub get` to fetch the package.

### Web Setup (Required for WASM with Physics Effects)

If you're building for web with WASM and using physics effects, you need to add a helper script to your `web/index.html` file. Add this script **before** the `flutter_bootstrap.js` script:

```html
<body>
  <script>
    window._dynamicImport = (path) => import(path);
  </script>
  <script src="flutter_bootstrap.js" async></script>
</body>
```

This helper is required for Chipmunk2D's WASM module to load properly on web.

## What's New in 0.4.1

### Fixes

- **chipmunk2d_physics_ffi 1.0.4**: Bumps the Chipmunk2D FFI dependency to fix Android builds for Google Play’s 16 KB page size requirement and Windows `build_runner` when prebuilt native libraries were missing. See [issue #51](https://github.com/tguerin/newton/issues/51) and [issue #52](https://github.com/tguerin/newton/issues/52).

## What's New in 0.4.0

### Breaking Changes
- **Physics Engine Migration**: Migrated from Forge2D (Box2D) to Chipmunk2D for improved performance and stability. The public API remains compatible, but the underlying physics engine has changed. If you have direct dependencies on `forge2d`, you'll need to update your code.

### Major Updates
- **Chipmunk2D Integration**: Full integration with Chipmunk2D physics engine, providing better performance for physics-based particle effects.
- **Enhanced Performance**: Improved physics simulation performance, especially for large numbers of active particles (now supports up to 3000 particles with warnings).

## What's New in 0.3.0

### Breaking Changes
- **Renamed Physics Effects**: `RelativisticEffect` is now `PhysicsEffect` and `RelativisticEffectConfiguration` is now `PhysicsEffectConfiguration` for better clarity. The old names are deprecated.
- **Revamped Configuration API**: Configuration properties are now organized into logical groups (`PhysicsProperties`, `VisualProperties`, `EmissionProperties`, etc.) for better type safety and code organization. See the [Migration Guide](https://newton.7omtech.fr/docs/migration) for upgrade instructions.

### Major Features
- **Widget Collisions**: New `NewtonCollider` widget allows particles to collide with Flutter widgets! Create interactive effects where particles bounce off UI elements with accurate physics, including support for rounded corners, friction, and restitution.
- **Effect Presets**: Quick-start presets for common effects including confetti, rain, snow, explosions, and fountains. Perfect for rapid prototyping or production use.
- **Code Generator**: Enhanced configurator now allows you to copy generated code directly! Configure your effects visually and get ready-to-use Dart code with a single click.
- **Particle Pool**: Memory-efficient particle reuse system that reduces allocations and improves performance.
- **Debug Data Stream**: Real-time monitoring of particle effects with `debugDataStream` for tracking active particles and performance metrics.

### Performance Improvements
- **Viewport Culling**: Particles outside the visible area are now automatically culled, dramatically improving performance for large particle counts.
- **Optimized Rendering**: Improved particle sorting and fixture caching for smoother animations.
- **Optimized Collider Reporting**: Reduced unnecessary work in collider position reporting.

### Bug Fixes
- Fixed `clearEffects()` not triggering widget rebuilds
- Fixed colliders stopping to work when configuration properties change
- Improved collider stability and preservation during widget rebuilds
- Enhanced collider syncing to physics effects

## Usage

1. Import the Newton package:

```dart
import 'package:newton_particles/newton_particles.dart';
```

2. Create a `Newton` widget and add it to your Flutter UI with the desired
   effects:

```dart
Newton(
    // Add any kind of effects to your UI
    // For example:
    effectConfigurations: [
        PhysicsEffectConfiguration(
            physicsProperties: const PhysicsProperties(
                gravity: Gravity.earthGravity,
                angle: NumRange.single(90),
                velocity: NumRange.between(Velocity.stationary, Velocity.stationary),
            ),
            visualProperties: const VisualProperties(
                endScale: NumRange.single(1),
                fadeOutThreshold: NumRange.between(0.6, 0.8),
            ),
            emissionProperties: const EmissionProperties(
                origin: Offset.zero,
                maxOriginOffset: Offset(1, 0),
                particleLifespan: DurationRange.between(Duration(seconds: 7), Duration(seconds: 10)),
            ),
            particleConfiguration: const ParticleConfiguration(
                shape: CircleShape(),
                size: Size(5, 5),
            ),
        ),
    ],
)
```

Try our [effect configurator](https://newton.7omtech.fr/docs/configurator) to
tweak your effect and copy the generated code directly into your project.

## Example

For a quick start, here's an example of creating a simple rain effect using
Newton:

```dart
import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNewton();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Newton Rain Example')),
        body: Newton(
          effectConfigurations: [
            PhysicsEffectConfiguration(
              physicsProperties: const PhysicsProperties(
                gravity: Gravity.earthGravity,
                angle: NumRange.single(90),
                velocity: NumRange.between(Velocity.stationary, Velocity.stationary),
              ),
              visualProperties: const VisualProperties(
                endScale: NumRange.single(1),
                fadeOutThreshold: NumRange.between(0.6, 0.8),
              ),
              emissionProperties: const EmissionProperties(
                origin: Offset.zero,
                maxOriginOffset: Offset(1, 0),
                particleLifespan: DurationRange.between(Duration(seconds: 7), Duration(seconds: 10)),
              ),
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

For detailed documentation and examples, visit the
[Newton Documentation](https://newton.7omtech.fr).

## Contributing

We welcome contributions from the community! If you find any issues or have
ideas for improvements, feel free to open an issue or submit a pull request on
GitHub.

## License

This project is licensed under the
[MIT License](https://github.com/tguerin/newton/blob/main/LICENSE).

---

**Note:** This package is under active development, and breaking changes might
be introduced in future versions until a stable 1.0.0 release. Please review the
[changelog](CHANGELOG.md) when updating versions.
