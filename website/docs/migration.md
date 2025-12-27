---
sidebar_position: 7
---

# Migration Guide: 0.2.x to 0.3.x

This guide will help you migrate your Newton particle effects from version 0.2.x to 0.3.x. The new version introduces a more organized API using grouped properties, which provides better type safety and code organization.

## Overview of Changes

### Breaking Changes

1. **`RelativisticEffectConfiguration` renamed to `PhysicsEffectConfiguration`**
   - The class name has been changed to better reflect its purpose.

2. **`activeEffects` parameter renamed to `effectConfigurations`**
   - The `Newton` widget now uses `effectConfigurations` instead of `activeEffects`.

3. **Properties are now grouped into dedicated classes**
   - Individual properties are now organized into grouped property classes for better organization and validation.

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

The biggest change is that properties are now organized into grouped classes. Here's how to migrate:

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
    angle: Range.single(90),
    velocity: Range.between(Velocity.stationary, Velocity.stationary),
  ),
  visualProperties: VisualProperties(
    endScale: Range.single(1),
    fadeOutThreshold: Range.between(0.6, 0.8),
  ),
  emissionProperties: EmissionProperties(
    origin: Offset.zero,
    maxOriginOffset: Offset(1, 0),
    minParticleLifespan: Duration(seconds: 7),
    maxParticleLifespan: Duration(seconds: 10),
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
    angle: Range.single(90),
    distance: Range.single(200),
  ),
  visualProperties: VisualProperties(
    endScale: Range.single(1),
    fadeOutThreshold: Range.between(0.6, 0.8),
  ),
  emissionProperties: EmissionProperties(
    origin: Offset.zero,
    maxOriginOffset: Offset(1, 0),
    minParticleLifespan: Duration(seconds: 4),
    maxParticleLifespan: Duration(seconds: 7),
  ),
  particleConfiguration: ParticleConfiguration(...),
)
```

## Property Group Mapping

### PhysicsProperties

Groups all physics-related properties:
- `gravity` → `physicsProperties.gravity`
- `minAngle` / `maxAngle` → `physicsProperties.angle: Range.between(min, max)` or `Range.single(value)`
- `minVelocity` / `maxVelocity` → `physicsProperties.velocity: Range.between(min, max)`
- `minDensity` / `maxDensity` → `physicsProperties.density: Range.between(min, max)`
- `minFriction` / `maxFriction` → `physicsProperties.friction: Range.between(min, max)`
- `minRestitution` / `maxRestitution` → `physicsProperties.restitution: Range.between(min, max)`
- `onlyInteractWithEdges` → `physicsProperties.onlyInteractWithEdges`
- `solidEdges` → `physicsProperties.solidEdges`

### VisualProperties

Groups all visual appearance properties:
- `minEndScale` / `maxEndScale` → `visualProperties.endScale: Range.between(min, max)` or `Range.single(value)`
- `minFadeInThreshold` / `maxFadeInThreshold` → `visualProperties.fadeInThreshold: Range.between(min, max)`
- `minFadeOutThreshold` / `maxFadeOutThreshold` → `visualProperties.fadeOutThreshold: Range.between(min, max)`
- `scaleCurve` → `visualProperties.scaleCurve`
- `fadeInCurve` → `visualProperties.fadeInCurve`
- `fadeOutCurve` → `visualProperties.fadeOutCurve`

### EmissionProperties

Groups all emission-related properties. **Note:** `EmissionProperties` is now part of the base `EffectConfiguration` class, making it available to both `PhysicsEffectConfiguration` and `DeterministicEffectConfiguration`:

- `origin` → `emissionProperties.origin`
- `minOriginOffset` / `maxOriginOffset` → `emissionProperties.minOriginOffset` / `maxOriginOffset`
- `particleCount` → `emissionProperties.particleCount`
- `particlesPerEmit` → `emissionProperties.particlesPerEmit`
- `emitDuration` → `emissionProperties.emitDuration`
- `emitCurve` → `emissionProperties.emitCurve`
- `minParticleLifespan` / `maxParticleLifespan` → `emissionProperties.minParticleLifespan` / `maxParticleLifespan`

### DeterministicProperties

Groups deterministic-specific properties:
- `minAngle` / `maxAngle` → `deterministicProperties.angle: Range.between(min, max)`
- `minDistance` / `maxDistance` → `deterministicProperties.distance: Range.between(min, max)`

### AnimationProperties

Groups animation timing properties:
- `startDelay` → `animationProperties.startDelay`

### LayerProperties

Groups layer and trail properties:
- `particleLayer` → `layerProperties.particleLayer`
- `trail` → `layerProperties.trail`

## Using Range Helpers

The new API uses `Range` objects for min/max values. Use these helpers:

- `Range.single(value)` - For a single value (no variation)
- `Range.between(min, max)` - For a range between min and max

Example:
```dart
// Single value
endScale: Range.single(1)

// Range
fadeOutThreshold: Range.between(0.6, 0.8)
velocity: Range.between(Velocity.custom(3), Velocity.custom(5))
```

## Configuration Overrider Changes

If you're using `configurationOverrider` (formerly `effectOverrider`), update the copyWith call:

**Before (0.2.x):**
```dart
configurationOverrider: (effect) {
  return effect.effectConfiguration.copyWith(
    physicsProperties: effect.effectConfiguration.physicsProperties.copyWith(
      angle: Range.single(angle),
    ),
  );
}
```

**After (0.3.x):**
```dart
configurationOverrider: (effect) {
  return effect.effectConfiguration.copyWith(
    physicsProperties: effect.effectConfiguration.physicsProperties.copyWith(
      angle: Range.single(angle),
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
            angle: Range.between(-180, 180),
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
      angle: Range.between(-180, 180),
    ),
    // ... other grouped properties
  );
}
```

## Benefits of the New API

1. **Better Organization**: Properties are logically grouped, making configurations easier to understand and maintain.

2. **Type Safety**: Grouped properties provide better validation and type checking.

3. **Consistency**: Both physics and deterministic effects use similar property grouping patterns.

4. **Extensibility**: New properties can be added to appropriate groups without cluttering the main configuration class.

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
    angle: Range.single(90),
    velocity: Range.between(Velocity.stationary, Velocity.stationary),
  ),
  emissionProperties: const EmissionProperties(
    origin: Offset.zero,
    maxOriginOffset: Offset(1, 0),
    minParticleLifespan: Duration(seconds: 7),
    maxParticleLifespan: Duration(seconds: 10),
  ),
  particleConfiguration: ParticleConfiguration(...),
)
```

## Need Help?

If you encounter issues during migration, please:
1. Check the [updated documentation](/docs/intro)
2. Review the [effect samples](/docs/presets) for examples
3. Open an issue on [GitHub](https://github.com/tguerin/newton/issues)

