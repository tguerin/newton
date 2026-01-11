---
sidebar_position: 5
---

# Widget Collisions

Newton supports collision detection between particles and Flutter widgets using
the `NewtonCollider` widget. This allows particles to interact with UI elements
as if they were solid boundaries, creating engaging and interactive particle
effects.

## Overview

The widget collision system uses **Signed Distance Fields (SDF)** to accurately
detect collisions with rounded rectangles, providing precise physics
interactions including:

- Accurate collision detection for both circular and rectangular particles
- Support for rounded corners with proper physics
- Automatic position and shape updates when widgets move or resize
- Respect for particle properties like friction and restitution (bounciness)
- Smooth rolling motion along edges

## Basic Usage

Wrap any widget with `NewtonCollider` to make it act as a collision boundary:

```dart
import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

Newton(
  effectConfigurations: [
    PhysicsEffectConfiguration(
      // ... your physics effect configuration
    ),
  ],
  child: Stack(
    children: [
      // Your UI elements
      NewtonCollider(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 200,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Text('Collider'),
          ),
        ),
      ),
    ],
  ),
)
```

## How It Works

### Notification System

`NewtonCollider` uses Flutter's notification system to communicate with the
`Newton` widget:

1. **Registration**: When a `NewtonCollider` is built, it sends a
   `NewtonCollisionNotification` with its geometry (position, size, border
   radius)
2. **Updates**: The collider automatically updates when its position or size
   changes
3. **Removal**: When the collider is disposed, it sends a removal notification

### SDF Physics

The collision detection uses **Signed Distance Fields (SDF)** for accurate
rounded rectangle collision:

- **Distance Calculation**: Computes the signed distance from particle center to
  the RRect surface
- **Normal Calculation**: Calculates the surface normal for proper reflection
- **Rounded Corners**: Accurately handles collisions with rounded corners using
  mathematical formulas

### Integration with Chipmunk2D

The SDF collision system works alongside Chipmunk2D's physics engine:

- Chipmunk2D handles the main physics simulation (gravity, velocity, etc.)
- SDF provides accurate collision detection for widget boundaries
- Collision corrections are applied after each physics step
- Particle properties (friction, restitution) are respected

## Examples

### Button Collider

Create an interactive button that particles bounce off:

```dart
Newton(
  effectConfigurations: [
    PhysicsEffectConfiguration(
      physicsProperties: const PhysicsProperties(
        gravity: Gravity.earthGravity,
        // ... other properties
      ),
      // ... other configuration
    ),
  ],
  child: Center(
    child: NewtonCollider(
      borderRadius: BorderRadius.circular(12),
      child: ElevatedButton(
        onPressed: () {
          // Button action
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Bounce Here'),
      ),
    ),
  ),
)
```

### Multiple Colliders

Create multiple collision boundaries:

```dart
Newton(
  effectConfigurations: [/* ... */],
  child: Stack(
    children: [
      // Top collider
      Positioned(
        top: 50,
        left: 50,
        child: NewtonCollider(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ),
      // Bottom collider
      Positioned(
        bottom: 50,
        right: 50,
        child: NewtonCollider(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 150,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    ],
  ),
)
```

## API Reference

### NewtonCollider

A widget that marks its child as a collision boundary for Newton particles.

#### Properties

- **`child`** (required): The widget that will act as a collision boundary
- **`id`** (optional): Unique identifier for this collider. If not provided, a
  hash-based ID will be used
- **`borderRadius`** (optional): The border radius of the collider. If not
  provided, will attempt to extract from child's decoration

#### Example

```dart
NewtonCollider(
  id: 'my-button',
  borderRadius: BorderRadius.circular(20),
  child: YourWidget(),
)
```

### NewtonCollisionNotification

A notification sent by `NewtonCollider` to the `Newton` root widget.

This is an internal class used by the collision system. You typically don't need
to interact with it directly.

## Best Practices

### Border Radius

Always specify `borderRadius` if your widget has rounded corners:

```dart
NewtonCollider(
  borderRadius: BorderRadius.circular(20), // Match your widget's radius
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      // ...
    ),
  ),
)
```

### Performance

- Colliders automatically update when widgets move or resize
- The system is optimized to handle multiple colliders efficiently
- Avoid creating colliders for widgets that change position very frequently
  (consider throttling)

### Particle Properties

Colliders respect particle properties:

- **Friction**: Particles will slide or roll along collider edges based on
  friction
- **Restitution**: Bounciness is properly applied when particles hit colliders
- **Shape**: Both circular and rectangular particles are supported

### Coordinate System

The collision system automatically handles coordinate transformations:

- Widget positions are converted from global screen coordinates to the Newton
  canvas coordinate space
- This ensures collisions work correctly regardless of where widgets are
  positioned in your widget tree

## Limitations

1. **Shape Support**: Currently supports rectangular widgets with optional
   rounded corners. Complex shapes (paths, images) are approximated as bounding
   boxes with rounded corners.

2. **Performance**: Very large numbers of colliders (100+) may impact
   performance. Consider using fewer, larger colliders when possible.

3. **Dynamic Updates**: Colliders update automatically, but rapid position
   changes may cause brief visual artifacts.

4. **Particle Shapes**: All particle shapes are supported, but collision
   detection uses a conservative radius (for squares, uses half the diagonal).

## Troubleshooting

### Particles Not Bouncing

- Ensure your effect is a `PhysicsEffectConfiguration` (not a deterministic
  effect)
- Check that particles have sufficient velocity to trigger collisions
- Verify the collider is positioned correctly in the widget tree

### Jittering or Vibration

- This is usually resolved by the built-in collision threshold
- If particles vibrate when at rest, they may be too close to the collider
  surface

### Friction Not Working

- Ensure particles have appropriate friction values set
- Rolling motion is preserved automatically - friction should work naturally

### Rounded Corners Not Accurate

- Make sure to specify `borderRadius` that matches your widget's decoration
- The system will attempt to extract border radius from decorations, but
  explicit specification is more reliable
