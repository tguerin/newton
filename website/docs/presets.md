---
sidebar_position: 4
---

import Configurations from '@site/src/components/configurations';

# Effect Samples

Newton provides ready-to-use preset classes that make it easy to add common particle effects to your app. You can use these presets directly or customize them to fit your needs.

## Using Presets

Newton includes several preset classes that you can use out of the box:

- **[RainPreset](#rain-preset)** - Falling rain drops
- **[SnowPreset](#snow-preset)** - Falling snowflakes with wind drift
- **[FountainPreset](#fountain-preset)** - Water fountain effect
- **[ConfettiPreset](#confetti-preset)** - Celebration confetti
- **[ExplosionPreset](#explosion-preset)** - Explosion burst effect

### Quick Start with Presets

To use a preset, simply create an instance and call `toConfiguration()`:

```dart
Newton(
  effectConfigurations: [
    RainPreset().toConfiguration(),
  ],
)
```

You can also customize presets by passing parameters:

```dart
Newton(
  effectConfigurations: [
    RainPreset(
      color: Colors.blue,
      particlesPerEmit: 10,
      emitDuration: Duration(milliseconds: 50),
    ).toConfiguration(),
  ],
)
```

## Rain Preset

The `RainPreset` creates rain particles that fall straight down with gravity.

```dart
Newton(
  effectConfigurations: [
    RainPreset().toConfiguration(),
  ],
)
```

**Customizable options:**
- `color`: Color of the rain drops (default: light blue)
- `particleCount`: Total number of rain drops (default: 0 for infinite)
- `particlesPerEmit`: Number of drops per burst (default: 5)
- `emitDuration`: Duration between emissions (default: 100ms)
- `origin`: Origin point for emission (default: top center)
- `gravity`: Gravity applied to drops (default: earth gravity)

## Snow Preset

The `SnowPreset` creates snowflakes that fall slowly with slight horizontal drift.

```dart
Newton(
  effectConfigurations: [
    SnowPreset().toConfiguration(),
  ],
)
```

**Customizable options:**
- `color`: Color of the snowflakes (default: white)
- `particleCount`: Total number of snowflakes (default: 0 for infinite)
- `particlesPerEmit`: Number of flakes per burst (default: 3)
- `emitDuration`: Duration between emissions (default: 200ms)
- `origin`: Origin point for emission (default: top center)
- `windStrength`: Horizontal wind effect (default: 0.5)

## Fountain Preset

The `FountainPreset` creates particles that spray upward and fall back down.

```dart
Newton(
  effectConfigurations: [
    FountainPreset().toConfiguration(),
  ],
)
```

**Customizable options:**
- `color`: Color of the fountain particles (default: light blue)
- `particleCount`: Total number of particles (default: 0 for infinite)
- `particlesPerEmit`: Number of particles per burst (default: 8)
- `emitDuration`: Duration between emissions (default: 50ms)
- `origin`: Origin point for the fountain (default: bottom center)
- `gravity`: Gravity applied to particles (default: earth gravity)

## Confetti Preset

The `ConfettiPreset` creates colorful confetti particles that fall with gravity and bounce.

```dart
Newton(
  effectConfigurations: [
    ConfettiPreset().toConfiguration(),
  ],
)
```

**Customizable options:**
- `colors`: List of colors for confetti (default: rainbow colors)
- `particleCount`: Total number of particles (default: 50)
- `particlesPerEmit`: Number of particles per burst (default: 10)
- `emitDuration`: Duration between emissions (default: 50ms)
- `origin`: Origin point for emission (default: center top)
- `gravity`: Gravity applied to particles (default: earth gravity)

## Explosion Preset

The `ExplosionPreset` creates particles that burst outward in all directions.

```dart
Newton(
  effectConfigurations: [
    ExplosionPreset().toConfiguration(),
  ],
)
```

**Customizable options:**
- `colors`: List of colors for explosion (default: fire colors)
- `particleCount`: Total number of particles (default: 30)
- `particlesPerEmit`: Number of particles in burst (default: 30)
- `origin`: Origin point for explosion (default: center)
- `gravity`: Gravity applied to particles (default: zero)

---

## Manual Effect Creation

In the upcoming section, we will explore how to create animations manually using
Newtonian dynamics, such as simulating rain or pulse effects. These animations
can be constructed either deterministically or by applying physics-based
principles.

## Rain

<Configurations>
<>
<div>

To create a rain effect, particles are randomly emitted along the x-axis, with
their y offset initialized to zero (the origin is relative to the size of the
Newton widget). We set the origin to `Offset.zero`, and define the minimum and
maximum origin offsets as `Offset.zero` and `Offset(1, 0)`, respectively. The
minimum and maximum distances are set to the height of the screen (since our
Newton widget spans the entire screen). The particle angle is set to 90° to make
them fall downward. We introduce some randomness in fade-out times to ensure
that particles fade at different rates, and we also randomize the lifespan of
each particle to enhance the natural look of the rain.

```dart
DeterministicEffectConfiguration(
  deterministicProperties: DeterministicProperties(
    distance: NumRange.single(screenSize.height),
    angle: const NumRange.single(90),
  ),
  visualProperties: const VisualProperties(
    endScale: NumRange.single(1),
    fadeOutThreshold: NumRange.between(0.6, 0.8),
  ),
  emissionProperties: const EmissionProperties(
    origin: Offset.zero,
    maxOriginOffset: Offset(1, 0),
    particleLifespan: DurationRange.between(Duration(seconds: 4), Duration(seconds: 7)),
  ),
  particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
  ),
)
```

<video width="800" height="500" controls>
  <source src="/video/deterministic/rain_deterministic.mp4" type="video/mp4"/>
  Your browser does not support the video tag.
</video>
</div>
</>
<>

For the physics-based version, the process is similar. However, there is no need
to define the distance, as the effect relies solely on applying Earth's gravity
to the particles. This simplifies the setup, as the gravity will dictate the
motion and speed of the particles without explicitly setting a distance.

```dart
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
```

<video width="800" height="500" controls>
  <source src="/video/physics/rain_physics.mp4" type="video/mp4"/>
  Your browser does not support the video tag.
</video>
</>
</Configurations>

## Fountain

<Configurations>
<>
<div>
The deterministic fountain animation requires constructing a custom path using a quadratic Bézier curve. The process starts by defining a random horizontal displacement (`randomWidth`) and a vertical distance (`distance`).

- `moveTo()` sets the initial position of the particle.
- `relativeQuadraticBezierTo()` creates the curved path that simulates the
  fountain's trajectory. The first two parameters define the control point,
  giving the fountain its upward arc, while the last two define the end point,
  determining how far and wide the particle will travel.

The randomness in width and distance adds variability, making the fountain look
more natural by altering the particles' paths dynamically.

```dart
DeterministicEffectConfiguration(
  deterministicProperties: const DeterministicProperties(
    distance: NumRange.single(200),
  ),
  visualProperties: const VisualProperties(
    endScale: NumRange.single(1),
    fadeOutThreshold: NumRange.between(0.6, 0.8),
  ),
  emissionProperties: const EmissionProperties(
    particlesPerEmit: 10,
    particleLifespan: DurationRange.single(Duration(seconds: 4)),
  ),
  customPathBuilder: (effect, animatedParticle) {
    const width = 60;
    final path = Path();
    final randomWidth = random.nextDoubleRange(-width / 2, width / 2);
    final distance = effect.effectConfiguration.randomDistance();

    // Define the Bezier path to simulate the fountain trajectory
    return PathMetricsTransformation(
      path: path
        ..moveTo(animatedParticle.particle.initialPosition.dx, animatedParticle.particle.initialPosition.dy)
        ..relativeQuadraticBezierTo(
          randomWidth,
          -distance,
          randomWidth * 4,
          -distance / Random().nextIntRange(2, 6),
        ),
    );
  },
  particleConfiguration: const ParticleConfiguration(
    shape: CircleShape(),
    size: Size(5, 5),
  ),
)
```

<video width="800" height="500" controls>
  <source src="/video/deterministic/fountain_deterministic.mp4" type="video/mp4"/>
  Your browser does not support the video tag.
</video>
</div>
</>
<>

In the physics-based version of the fountain animation, particles are emitted at
angles between -80 and -100 degrees, causing them to move upward. The variation
in the emission angle is the key factor that alters the trajectory of each
particle, making them follow different paths. Additional randomness is applied
to further diversify the motion, resulting in a more dynamic and realistic
fountain effect.

```dart
PhysicsEffectConfiguration(
   physicsProperties: PhysicsProperties(
     gravity: Gravity.earthGravity,
     angle: const NumRange.between(-100, -80),
     velocity: NumRange.between(Velocity.custom(3), Velocity.custom(5)),
     onlyInteractWithEdges: true,
   ),
   visualProperties: const VisualProperties(
     endScale: NumRange.single(1),
     fadeOutThreshold: NumRange.between(0.6, 0.8),
   ),
   emissionProperties: const EmissionProperties(
     particlesPerEmit: 10,
     particleLifespan: DurationRange.between(Duration(seconds: 4), Duration(seconds: 6)),
   ),
   particleConfiguration: const ParticleConfiguration(
     shape: CircleShape(),
     size: Size(5, 5),
   ),
 )
```

<video width="800" height="500" controls>
  <source src="/video/physics/fountain_physics.mp4" type="video/mp4"/>
  Your browser does not support the video tag.
</video>
</>
</Configurations>

## Pulse

<Configurations>
<>
<div>

For the pulse animation, we use a `customPathBuilder` to compute the emission
angle for each particle. The angle is calculated based on the total number of
particles emitted per pulse and the count of particles already emitted. This
ensures that the particles are evenly distributed in a circular pattern. All
particles use the same animation duration, so they travel at the same pace,
creating a synchronized and cohesive pulse effect.

```dart
DeterministicEffectConfiguration(
  deterministicProperties: const DeterministicProperties(
    distance: NumRange.single(200),
  ),
  visualProperties: const VisualProperties(
    endScale: NumRange.single(1),
    fadeOutThreshold: NumRange.single(0.8),
  ),
  emissionProperties: const EmissionProperties(
    emitDuration: Duration(seconds: 1),
    particlesPerEmit: 15,
    particleLifespan: DurationRange.single(Duration(seconds: 4)),
  ),
  customPathBuilder: (effect, animatedParticle) {
    final particlesPerEmit = effect.effectConfiguration.particlesPerEmit;
    final angle = 360 / particlesPerEmit * (effect.activeParticles.length % particlesPerEmit);
    return StraightPathTransformation(distance: effect.effectConfiguration.randomDistance(), angle: angle);
  },
  particleConfiguration: const ParticleConfiguration(
    shape: CircleShape(),
    size: Size(5, 5),
  ),
)
```

<video width="800" height="500" controls>
  <source src="/video/deterministic/pulse_deterministic.mp4" type="video/mp4"/>
  Your browser does not support the video tag.
</video>
</div>
</>
<>
For the physics-based pulse animation, the process is similar, but we use the `configurationOverrider` to achieve the desired result (specific to physics-based animations). The key parameter here is `onlyInteractWithEdges`, which ensures that particles do not interact with each other, creating a clean pulse effect. Additionally, gravity is set to zero so that all particles maintain the same speed throughout the animation, enhancing the synchronized pulse motion.

```dart
PhysicsEffectConfiguration(
   configurationOverrider: (effect) {
     final particlesPerEmit = effect.effectConfiguration.particlesPerEmit;
     final angle = 360 / particlesPerEmit * (effect.activeParticles.length % particlesPerEmit);
     return effect.effectConfiguration.copyWith(
       physicsProperties: effect.effectConfiguration.physicsProperties.copyWith(
         angle: NumRange.single(angle),
       ),
     );
   },
   physicsProperties: const PhysicsProperties(
     gravity: Gravity.zero,
     angle: NumRange.single(0), // Angle is set dynamically in configurationOverrider
     velocity: NumRange.between(Velocity(.6), Velocity(.6)),
     onlyInteractWithEdges: true,
   ),
   visualProperties: const VisualProperties(
     endScale: NumRange.single(1),
     fadeOutThreshold: NumRange.single(0.8),
   ),
   emissionProperties: const EmissionProperties(
     emitDuration: Duration(seconds: 1),
     particlesPerEmit: 15,
     particleLifespan: DurationRange.single(Duration(seconds: 4)),
   ),
   particleConfiguration: const ParticleConfiguration(
     shape: CircleShape(),
     size: Size(5, 5),
   ),
 )
```

<video width="800" height="500" controls>
  <source src="/video/physics/pulse_physics.mp4" type="video/mp4"/>
  Your browser does not support the video tag.
</video>
</>
</Configurations>

## Smoke

<Configurations>
<>
<div>
For the smoke effect, particles are emitted upward with a small angle randomness to simulate natural dispersion. We adjust the `minOriginOffset` and `maxOriginOffset` so that particles are emitted from slightly different locations, adding variability to the source. Additionally, we introduce randomness in the animation duration, which causes some particles to move slower than others, enhancing the realistic appearance of the smoke.

```dart
DeterministicEffectConfiguration(
  deterministicProperties: const DeterministicProperties(
    angle: NumRange.between(-100, -80),
  ),
  visualProperties: const VisualProperties(
    endScale: NumRange.single(1),
    fadeOutThreshold: NumRange.between(0.6, 0.8),
  ),
  emissionProperties: const EmissionProperties(
    particlesPerEmit: 3,
    minOriginOffset: Offset(-.01, 0),
    maxOriginOffset: Offset(.01, 0),
    particleLifespan: DurationRange.between(Duration(seconds: 4), Duration(seconds: 7)),
  ),
  particleConfiguration: const ParticleConfiguration(
    shape: CircleShape(),
    size: Size(5, 5),
  ),
)
```

<video width="800" height="500" controls>
  <source src="/video/deterministic/smoke_deterministic.mp4" type="video/mp4"/>
  Your browser does not support the video tag.
</video>
</div>
</>
<>
<div>
The physics-based version is not available yet, as it requires buoyancy to be implemented first.
</div>
</>
</Configurations>

## Firework

<Configurations>
<>
<div>
The firework effect introduces a key concept: the `postEffectBuilder` in the particle configuration. This allows triggering a new effect when a particle's lifespan ends. For the firework, we emit particles upward with some randomness in their angle. In the `postEffectBuilder`, we create an explosion effect at the last particle's position, using that as the origin for the explosion. Additionally, we enable the trail effect to simulate the fire trail of the launching firework, making the animation more realistic.
> **Note:** You can mix both physics-based and deterministic effects, though particles from each effect will not interact with each other.
  ```dart
  DeterministicEffectConfiguration(
    deterministicProperties: const DeterministicProperties(
      angle: NumRange.between(-120, -60),
    ),
    visualProperties: const VisualProperties(
      endScale: NumRange.single(1),
      fadeOutThreshold: NumRange.between(0.6, 0.8),
    ),
    emissionProperties: const EmissionProperties(
      emitDuration: Duration(milliseconds: 500),
      particleLifespan: DurationRange.single(Duration(seconds: 2)),
    ),
    layerProperties: const LayerProperties(
      trail: StraightTrail(
        trailWidth: 3,
        trailProgress: .3,
      ),
    ),
    particleConfiguration: ParticleConfiguration(
      shape: const CircleShape(),
      size: const Size(5, 5),
      postEffectBuilder: (particle, effect) {
        final offset = Offset(
          particle.position.dx / effect.surfaceSize.width,
          particle.position.dy / effect.surfaceSize.height,
        );
        return DeterministicEffectConfiguration(
          deterministicProperties: const DeterministicProperties(
            angle: NumRange.between(-180, 180),
          ),
          emissionProperties: EmissionProperties(
            particleCount: 10,
            particlesPerEmit: 10,
            origin: offset,
          ),
          distanceCurve: Curves.decelerate,
          particleConfiguration: const ParticleConfiguration(
            shape: CircleShape(),
            size: Size(5, 5),
            color: SingleParticleColor(color: Colors.blue),
          ),
        );
      },
    ),
  )
  ```

<video width="800" height="500" controls>
  <source src="/video/deterministic/firework_deterministic.mp4" type="video/mp4"/>
  Your browser does not support the video tag.
</video>
</div>
</>
<>
For the physics-based version, the process is similar, but we remove solid edges by setting `SolidEdges.none`, allowing particles to travel without interacting with boundaries.

```dart
PhysicsEffectConfiguration(
   physicsProperties: const PhysicsProperties(
     gravity: Gravity.earthGravity,
     angle: NumRange.between(-100, -80),
     velocity: NumRange.between(Velocity(9), Velocity(10)),
     solidEdges: SolidEdges.none,
   ),
   visualProperties: const VisualProperties(
     endScale: NumRange.single(1),
     fadeOutThreshold: NumRange.between(0.6, 0.8),
   ),
   emissionProperties: const EmissionProperties(
     emitDuration: Duration(milliseconds: 500),
     origin: Offset(0.5, 1),
     particleLifespan: DurationRange.single(Duration(seconds: 1, milliseconds: 500)),
   ),
   particleConfiguration: ParticleConfiguration(
     shape: const CircleShape(),
     size: const Size(5, 5),
     postEffectBuilder: (particle, effect) {
       final offset = Offset(
         particle.position.dx / effect.surfaceSize.width,
         particle.position.dy / effect.surfaceSize.height,
       );
       return PhysicsEffectConfiguration(
         physicsProperties: const PhysicsProperties(
           gravity: Gravity.earthGravity,
           angle: NumRange.between(-180, 180),
           velocity: NumRange.between(Velocity(5), Velocity(5)),
           solidEdges: SolidEdges.none,
         ),
         emissionProperties: EmissionProperties(
           particleCount: 10,
           particlesPerEmit: 10,
           origin: offset,
         ),
         particleConfiguration: const ParticleConfiguration(
           shape: CircleShape(),
           size: Size(5, 5),
           color: SingleParticleColor(color: Colors.blue),
         ),
       );
     },
   ),
 )
```

<video width="800" height="500" controls>
  <source src="/video/physics/firework_physics.mp4" type="video/mp4"/>
  Your browser does not support the video tag.
</video>
</>
</Configurations>
