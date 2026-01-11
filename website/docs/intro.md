---
sidebar_position: 1
---

# Getting Started

## Installation

To use Newton, simply add it as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  newton_particles: ^0.4.0
```

Then, run `flutter pub get` to fetch the package.

## Usage

1. **Initialize Newton** (Required on web for physics effects):

   If you're using `PhysicsEffectConfiguration`, you should initialize Newton in your app's `main()` function:

   ```dart
   import 'package:newton_particles/newton_particles.dart';
   
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await initializeNewton();
     runApp(MyApp());
   }
   ```

   **Note**: 
   - On web, this initialization is required for physics-based effects.
   - On other platforms (iOS, Android, macOS, Linux, Windows), this is a no-op and can be safely called or omitted.
   - If you're only using `DeterministicEffectConfiguration`, you can skip this step on all platforms.

2. **Add dynamic import helper for web** (Required for WASM on web):

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

3. Import the Newton package:

```dart
import 'package:newton_particles/newton_particles.dart';
```

4. Create a `Newton` widget and add it to your Flutter UI with the desired
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
        )
    ],
)
```

Try our [effect configurator](https://newton.7omtech.fr/docs/configurator) to
tweak your effect and copy the generated code directly into your project.

## Widget Collisions

Newton supports collision detection between particles and Flutter widgets. Wrap any widget with `NewtonCollider` to make particles bounce off it:

```dart
Newton(
  effectConfigurations: [physicsEffectConfig],
  child: Stack(
    children: [
      NewtonCollider(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 200,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    ],
  ),
)
```

See the [Widget Collisions documentation](widget-collisions) for more details.

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
