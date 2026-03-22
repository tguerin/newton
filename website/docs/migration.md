---
sidebar_position: 7
---

# Migration Guide

## Migration Guide: 0.3.x to 0.4.x

### Overview

Version 0.4.0 migrates the physics engine from Forge2D (Box2D) to Chipmunk2D.
The public API remains compatible, so most users won't need to make any code
changes. However, there are a few important points to be aware of.

### What Changed

- **Physics Engine**: The underlying physics engine has been changed from
  Forge2D to Chipmunk2D
- **Dependency**: The package no longer depends on `forge2d` and now uses
  `chipmunk2d_physics_ffi` instead
- **API Compatibility**: The public API remains the same - your existing code
  should work without changes

### Migration Steps

1. **Update your dependency**:
   ```yaml
   dependencies:
     newton_particles: ^0.4.1
   ```

2. **Remove any direct `forge2d` dependencies** (if you have any): If your
   project directly depends on `forge2d`, you'll need to remove it as it's no
   longer used by Newton.

3. **Run `flutter pub get`**:
   ```bash
   flutter pub get
   ```

4. **Initialize Newton** (Required on web for physics effects):

   On web, you must initialize Newton before using any physics-based effects. On
   other platforms, this is optional (no-op). Add the initialization to your
   app's `main()` function for cross-platform compatibility:

   ```dart
   import 'package:flutter/material.dart';
   import 'package:newton_particles/newton_particles.dart';

   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await initializeNewton();
     runApp(MyApp());
   }
   ```

   **Note**:
   - On web, this initialization is required if you're using
     `PhysicsEffectConfiguration`.
   - On other platforms (iOS, Android, macOS, Linux, Windows), this is a no-op
     and can be safely called or omitted.
   - If you're only using `DeterministicEffectConfiguration`, you can skip this
     step on all platforms.

5. **Add dynamic import helper for web** (Required for WASM on web):

   If you're building for web with WASM and using physics effects, you need to
   add a helper script to your `web/index.html` file. Add this script **before**
   the `flutter_bootstrap.js` script:

   ```html
   <body>
     <script>
       window._dynamicImport = (path) => import(path);
     </script>
     <script src="flutter_bootstrap.js" async></script>
   </body>
   ```

   This helper is required for Chipmunk2D's WASM module to load properly on web.

6. **Test your physics effects**: While the API is compatible, the underlying
   physics engine behaves slightly differently. Test your physics-based effects
   to ensure they behave as expected.

### What to Expect

- **Better Performance**: Chipmunk2D generally provides better performance,
  especially for large numbers of particles
- **Same Behavior**: Physics simulations should behave similarly, though there
  may be minor differences due to different physics engines
- **All Features Preserved**: All existing features (collisions, gravity,
  density, friction, restitution, etc.) continue to work as before

### Breaking Changes

- If you were directly importing or using Forge2D classes from the Newton
  package, those are no longer available
- The internal physics world implementation has changed, but this shouldn't
  affect your code unless you were accessing internal classes

### Need Help?

If you encounter any issues during migration:

1. Check that you've updated to `^0.4.1`
2. Ensure you've run `flutter pub get`
3. Review the
   [changelog](https://github.com/tguerin/newton/blob/main/CHANGELOG.md) for
   detailed changes
4. Open an issue on [GitHub](https://github.com/tguerin/newton/issues)

---

## Migration Guide: 0.2.x to 0.3.x

This guide will help you migrate your Newton particle effects from version 0.2.x
to 0.3.x. The new version introduces a more organized API using grouped
properties, which provides better type safety and code organization.

## Overview of Changes

### Breaking Changes

1. **`RelativisticEffectConfiguration` renamed to `PhysicsEffectConfiguration`**
   - The class name has been changed to better reflect its purpose.

2. **`activeEffects` parameter renamed to `effectConfigurations`**
   - The `Newton` widget now uses `effectConfigurations` instead of
     `activeEffects`.

3. **Properties are now grouped into dedicated classes**
   - Individual properties are now organized into grouped property classes for
     better organization and validation.

## Step-by-Step Migration

### 1. Update Newton Widget Parameter

**Before (0.2.x):**

```dart
Newton(
  activeEffects: [
    // effects...
  ],
)
```

**After (0.3.x):**

```dart
Newton(
  effectConfigurations: [
    // effects...
  ],
)
```

### 2. Rename RelativisticEffectConfiguration

**Before (0.2.x):**

```dart
RelativisticEffectConfiguration(
  // properties...
)
```

**After (0.3.x):**

```dart
PhysicsEffectConfiguration(
  // properties...
)
```

### 3. Migrate Properties to Grouped Classes

The biggest change is that properties are now organized into grouped classes.
Here's how to migrate:

#### Physics-Based Effects

**Before (0.2.x):**

```dart
RelativisticEffectConfiguration(
  gravity: Gravity.earthGravity,
  minAngle: 90,
  maxAngle: 90,
  minVelocity: Velocity.stationary,
  maxVelocity: Velocity.stationary,
  minEndScale: 1,
  maxEndScale: 1,
  minFadeOutThreshold: 0.6,
  maxFadeOutThreshold: 0.8,
  origin: Offset.zero,
  maxOriginOffset: Offset(1, 0),
  minParticleLifespan: Duration(seconds: 7),
  maxParticleLifespan: Duration(seconds: 10),
  particleConfiguration: ParticleConfiguration(...),
)
```

**After (0.3.x):**

```dart
PhysicsEffectConfiguration(
  physicsProperties: PhysicsProperties(
    gravity: Gravity.earthGravity,
    angle: NumRange.single(90),
    velocity: NumRange.between(Velocity.stationary, Velocity.stationary),
  ),
  visualProperties: VisualProperties(
    endScale: NumRange.single(1),
    fadeOutThreshold: NumRange.between(0.6, 0.8),
  ),
  emissionProperties: EmissionProperties(
    origin: Offset.zero,
    maxOriginOffset: Offset(1, 0),
    particleLifespan: DurationRange.between(Duration(seconds: 7), Duration(seconds: 10)),
  ),
  particleConfiguration: ParticleConfiguration(...),
)
```

#### Deterministic Effects

**Before (0.2.x):**

```dart
DeterministicEffectConfiguration(
  minAngle: 90,
  maxAngle: 90,
  minDistance: 200,
  maxDistance: 200,
  minEndScale: 1,
  maxEndScale: 1,
  minFadeOutThreshold: 0.6,
  maxFadeOutThreshold: 0.8,
  origin: Offset.zero,
  maxOriginOffset: Offset(1, 0),
  minParticleLifespan: Duration(seconds: 4),
  maxParticleLifespan: Duration(seconds: 7),
  particleConfiguration: ParticleConfiguration(...),
)
```

**After (0.3.x):**

```dart
DeterministicEffectConfiguration(
  deterministicProperties: DeterministicProperties(
    angle: NumRange.single(90),
    distance: NumRange.single(200),
  ),
  visualProperties: VisualProperties(
    endScale: NumRange.single(1),
    fadeOutThreshold: NumRange.between(0.6, 0.8),
  ),
  emissionProperties: EmissionProperties(
    origin: Offset.zero,
    maxOriginOffset: Offset(1, 0),
    particleLifespan: DurationRange.between(Duration(seconds: 4), Duration(seconds: 7)),
  ),
  particleConfiguration: ParticleConfiguration(...),
)
```

## Property Group Mapping

### PhysicsProperties

Groups all physics-related properties:

- `gravity` → `physicsProperties.gravity`
- `minAngle` / `maxAngle` →
  `physicsProperties.angle: NumRange.between(min, max)` or
  `NumRange.single(value)`
- `minVelocity` / `maxVelocity` →
  `physicsProperties.velocity: NumRange.between(min, max)`
- `minDensity` / `maxDensity` →
  `physicsProperties.density: NumRange.between(min, max)`
- `minFriction` / `maxFriction` →
  `physicsProperties.friction: NumRange.between(min, max)`
- `minRestitution` / `maxRestitution` →
  `physicsProperties.restitution: NumRange.between(min, max)`
- `onlyInteractWithEdges` → `physicsProperties.onlyInteractWithEdges`
- `solidEdges` → `physicsProperties.solidEdges`

### VisualProperties

Groups all visual appearance properties:

- `minEndScale` / `maxEndScale` →
  `visualProperties.endScale: NumRange.between(min, max)` or
  `NumRange.single(value)`
- `minFadeInThreshold` / `maxFadeInThreshold` →
  `visualProperties.fadeInThreshold: NumRange.between(min, max)`
- `minFadeOutThreshold` / `maxFadeOutThreshold` →
  `visualProperties.fadeOutThreshold: NumRange.between(min, max)`
- `scaleCurve` → `visualProperties.scaleCurve`
- `fadeInCurve` → `visualProperties.fadeInCurve`
- `fadeOutCurve` → `visualProperties.fadeOutCurve`

### EmissionProperties

Groups all emission-related properties. **Note:** `EmissionProperties` is now
part of the base `EffectConfiguration` class, making it available to both
`PhysicsEffectConfiguration` and `DeterministicEffectConfiguration`:

- `origin` → `emissionProperties.origin`
- `minOriginOffset` / `maxOriginOffset` → `emissionProperties.minOriginOffset` /
  `maxOriginOffset`
- `particleCount` → `emissionProperties.particleCount`
- `particlesPerEmit` → `emissionProperties.particlesPerEmit`
- `emitDuration` → `emissionProperties.emitDuration`
- `emitCurve` → `emissionProperties.emitCurve`
- `minParticleLifespan` / `maxParticleLifespan` →
  `emissionProperties.particleLifespan: DurationRange.between(min, max)`

### DeterministicProperties

Groups deterministic-specific properties:

- `minAngle` / `maxAngle` →
  `deterministicProperties.angle: NumRange.between(min, max)`
- `minDistance` / `maxDistance` →
  `deterministicProperties.distance: NumRange.between(min, max)`

### AnimationProperties

Groups animation timing properties:

- `startDelay` → `animationProperties.startDelay`

### LayerProperties

Groups layer and trail properties:

- `particleLayer` → `layerProperties.particleLayer`
- `trail` → `layerProperties.trail`

## Using Range Helpers

The new API uses `NumRange` and `DurationRange` objects for min/max values. Use
these helpers:

- `NumRange.single(value)` - For a single numeric value (no variation)
- `NumRange.between(min, max)` - For a numeric range between min and max
- `DurationRange.single(Duration(...))` - For a single duration value
- `DurationRange.between(Duration(...), Duration(...))` - For a duration range

Example:

```dart
// Single numeric value
endScale: NumRange.single(1)

// Numeric range
fadeOutThreshold: NumRange.between(0.6, 0.8)
velocity: NumRange.between(Velocity.custom(3), Velocity.custom(5))

// Duration range
particleLifespan: DurationRange.between(Duration(seconds: 3), Duration(seconds: 5))
```

## Configuration Overrider Changes

If you're using `configurationOverrider` (formerly `effectOverrider`), update
the copyWith call:

**Before (0.2.x):**

```dart
configurationOverrider: (effect) {
  return effect.effectConfiguration.copyWith(
    physicsProperties: effect.effectConfiguration.physicsProperties.copyWith(
      angle: NumRange.single(angle),
    ),
  );
}
```

**After (0.3.x):**

```dart
configurationOverrider: (effect) {
  return effect.effectConfiguration.copyWith(
    physicsProperties: effect.effectConfiguration.physicsProperties.copyWith(
      angle: NumRange.single(angle),
    ),
  );
}
```

## Post Effect Builder Changes

When creating post effects in `postEffectBuilder`, use the new API:

**Before (0.2.x):**

```dart
postEffectBuilder: (particle, effect) {
        return PhysicsEffectConfiguration(
          physicsProperties: const PhysicsProperties(
            gravity: Gravity.earthGravity,
            angle: NumRange.between(-180, 180),
    // ... other properties
  );
}
```

**After (0.3.x):**

```dart
postEffectBuilder: (particle, effect) {
  return PhysicsEffectConfiguration(
    physicsProperties: const PhysicsProperties(
      gravity: Gravity.earthGravity,
      angle: NumRange.between(-180, 180),
    ),
    // ... other grouped properties
  );
}
```

## Benefits of the New API

1. **Better Organization**: Properties are logically grouped, making
   configurations easier to understand and maintain.

2. **Type Safety**: Grouped properties provide better validation and type
   checking.

3. **Consistency**: Both physics and deterministic effects use similar property
   grouping patterns.

4. **Extensibility**: New properties can be added to appropriate groups without
   cluttering the main configuration class.

## Common Patterns

### Rain Effect Migration

**Before:**

```dart
RelativisticEffectConfiguration(
  gravity: Gravity.earthGravity,
  minAngle: 90,
  maxAngle: 90,
  minVelocity: Velocity.stationary,
  maxVelocity: Velocity.stationary,
  origin: Offset.zero,
  maxOriginOffset: Offset(1, 0),
  minParticleLifespan: Duration(seconds: 7),
  maxParticleLifespan: Duration(seconds: 10),
  particleConfiguration: ParticleConfiguration(...),
)
```

**After:**

```dart
PhysicsEffectConfiguration(
  physicsProperties: const PhysicsProperties(
    gravity: Gravity.earthGravity,
    angle: NumRange.single(90),
    velocity: NumRange.between(Velocity.stationary, Velocity.stationary),
  ),
  emissionProperties: const EmissionProperties(
    origin: Offset.zero,
    maxOriginOffset: Offset(1, 0),
    particleLifespan: DurationRange.between(Duration(seconds: 7), Duration(seconds: 10)),
  ),
  particleConfiguration: ParticleConfiguration(...),
)
```

## Need Help?

If you encounter issues during migration, please:

1. Check the [updated documentation](/docs/intro)
2. Review the [effect samples](/docs/presets) for examples
3. Open an issue on [GitHub](https://github.com/tguerin/newton/issues)
