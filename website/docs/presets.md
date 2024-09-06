---
sidebar_position: 4
---
import Configurations from '@site/src/components/configurations';

# Effect Samples

In the upcoming section, we will explore how to create animations using Newtonian dynamics, such as simulating rain or pulse effects. These animations can be constructed either deterministically or by applying relativistic principles.

## Rain

<Configurations>
<>
<div>

To create a rain effect, particles are randomly emitted along the x-axis, with their y offset initialized to zero (the origin is relative to the size of the Newton widget). We set the origin to `Offset.zero`, and define the minimum and maximum origin offsets as `Offset.zero` and `Offset(1, 0)`, respectively. The minimum and maximum distances are set to the height of the screen (since our Newton widget spans the entire screen). The particle angle is set to 90° to make them fall downward. We introduce some randomness in fade-out times to ensure that particles fade at different rates, and we also randomize the lifespan of each particle to enhance the natural look of the rain.

  ```dart
  DeterministicEffectConfiguration(
    minDistance: screenSize.height,
    maxDistance: screenSize.height,
    origin: Offset.zero,
    maxOriginOffset: const Offset(1, 0),
    maxAngle: 90,
    maxParticleLifespan: const Duration(seconds: 7),
    maxEndScale: 1,
    maxFadeOutThreshold: .8,
    minAngle: 90,
    minParticleLifespan: const Duration(seconds: 4),
    minEndScale: 1,
    minFadeOutThreshold: .6,
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

For the relativistic version, the process is similar. However, there is no need to define the distance, as the effect relies solely on applying Earth's gravity to the particles. This simplifies the setup, as the gravity will dictate the motion and speed of the particles without explicitly setting a distance.

```dart
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
- `relativeQuadraticBezierTo()` creates the curved path that simulates the fountain's trajectory. The first two parameters define the control point, giving the fountain its upward arc, while the last two define the end point, determining how far and wide the particle will travel.

The randomness in width and distance adds variability, making the fountain look more natural by altering the particles' paths dynamically.


  ```dart
  DeterministicEffectConfiguration(
    minParticleLifespan: const Duration(seconds: 4),
    maxParticleLifespan: const Duration(seconds: 4),
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
    minDistance: 200,
    minFadeOutThreshold: .6,
    maxFadeOutThreshold: .8,
    minEndScale: 1,
    maxEndScale: 1,
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
    particlesPerEmit: 10,
  )
  ```

<video width="800" height="500" controls>
  <source src="/video/deterministic/fountain_deterministic.mp4" type="video/mp4"/>
  Your browser does not support the video tag.
</video>
</div>
</>
<>

In the relativistic version of the fountain animation, particles are emitted at angles between -80 and -100 degrees, causing them to move upward. The variation in the emission angle is the key factor that alters the trajectory of each particle, making them follow different paths. Additional randomness is applied to further diversify the motion, resulting in a more dynamic and realistic fountain effect.

```dart
 RelativisticEffectConfiguration(
    gravity: Gravity.earthGravity,
    minParticleLifespan: const Duration(seconds: 4),
    maxParticleLifespan: const Duration(seconds: 6),
    minFadeOutThreshold: .6,
    maxFadeOutThreshold: .8,
    minEndScale: 1,
    maxEndScale: 1,
    minAngle: -100,
    maxAngle: -80,
    minVelocity: Velocity.custom(3),
    maxVelocity: Velocity.custom(5),
    onlyInteractWithEdges: true,
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
    particlesPerEmit: 10,
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

For the pulse animation, we use a `customPathBuilder` to compute the emission angle for each particle. The angle is calculated based on the total number of particles emitted per pulse and the count of particles already emitted. This ensures that the particles are evenly distributed in a circular pattern. All particles use the same animation duration, so they travel at the same pace, creating a synchronized and cohesive pulse effect.


  ```dart
  DeterministicEffectConfiguration(
    customPathBuilder: (effect, animatedParticle) {
      final particlesPerEmit = effect.effectConfiguration.particlesPerEmit;
      final angle = 360 / particlesPerEmit * (effect.activeParticles.length % particlesPerEmit);
      return StraightPathTransformation(distance: effect.effectConfiguration.randomDistance(), angle: angle);
    },
    emitDuration: const Duration(seconds: 1),
    maxParticleLifespan: const Duration(seconds: 4),
    maxEndScale: 1,
    maxFadeOutThreshold: .8,
    minDistance: 200,
    minEndScale: 1,
    minParticleLifespan: const Duration(seconds: 4),
    minFadeOutThreshold: .8,
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
    particlesPerEmit: 15,
  )
  ```

<video width="800" height="500" controls>
  <source src="/video/deterministic/pulse_deterministic.mp4" type="video/mp4"/>
  Your browser does not support the video tag.
</video>
</div>
</>
<>
For the relativistic pulse animation, the process is similar, but we use the `effectOverrider` to achieve the desired result (specific to relativistic animations). The key parameter here is `onlyInteractWithEdges`, which ensures that particles do not interact with each other, creating a clean pulse effect. Additionally, gravity is set to zero so that all particles maintain the same speed throughout the animation, enhancing the synchronized pulse motion.

```dart
 RelativisticEffectConfiguration(
    configurationOverrider: (effect) {
      final particlesPerEmit = effect.effectConfiguration.particlesPerEmit;
      final angle = 360 / particlesPerEmit * (effect.activeParticles.length % particlesPerEmit);
      return effect.effectConfiguration.copyWith(maxAngle: angle, minAngle: angle);
    },
    gravity: Gravity.zero,
    emitDuration: const Duration(seconds: 1),
    maxEndScale: 1,
    maxFadeOutThreshold: .8,
    maxParticleLifespan: const Duration(seconds: 4),
    maxVelocity: const Velocity(.6),
    minEndScale: 1,
    minParticleLifespan: const Duration(seconds: 4),
    minVelocity: const Velocity(.6),
    minFadeOutThreshold: .8,
    onlyInteractWithEdges: true,
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
    particlesPerEmit: 15,
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
    minAngle: -100,
    maxAngle: -80,
    minOriginOffset: const Offset(-.01, 0),
    minParticleLifespan: const Duration(seconds: 4),
    maxParticleLifespan: const Duration(seconds: 7),
    minFadeOutThreshold: .6,
    maxFadeOutThreshold: .8,
    maxOriginOffset: const Offset(.01, 0),
    minEndScale: 1,
    maxEndScale: 1,
    particleConfiguration: const ParticleConfiguration(
      shape: CircleShape(),
      size: Size(5, 5),
    ),
    particlesPerEmit: 3,
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
The relativistic version is not available yet, as it requires buoyancy to be implemented first.
</div>
</>
</Configurations>

## Firework

<Configurations>
<>
<div>
The firework effect introduces a key concept: the `postEffectBuilder` in the particle configuration. This allows triggering a new effect when a particle's lifespan ends. For the firework, we emit particles upward with some randomness in their angle. In the `postEffectBuilder`, we create an explosion effect at the last particle's position, using that as the origin for the explosion. Additionally, we enable the trail effect to simulate the fire trail of the launching firework, making the animation more realistic.
> **Note:** You can mix both relativistic and deterministic effects, though particles from each effect will not interact with each other.
  ```dart
  DeterministicEffectConfiguration(
    minAngle: -120,
    maxAngle: -60,
    maxParticleLifespan: const Duration(seconds: 2),
    minFadeOutThreshold: .6,
    maxFadeOutThreshold: .8,
    emitDuration: const Duration(milliseconds: 500),
    minEndScale: 1,
    maxEndScale: 1,
    particleConfiguration: ParticleConfiguration(
      shape: const CircleShape(),
      size: const Size(5, 5),
      postEffectBuilder: (particle, effect) {
        final offset = Offset(
          particle.position.dx / effect.surfaceSize.width,
          particle.position.dy / effect.surfaceSize.height,
        );
        return DeterministicEffectConfiguration(
          maxAngle: 180,
          minAngle: -180,
          particleCount: 10,
          particleConfiguration: const ParticleConfiguration(
            shape: CircleShape(),
            size: Size(5, 5),
            color: SingleParticleColor(color: Colors.blue),
          ),
          particlesPerEmit: 10,
          distanceCurve: Curves.decelerate,
          origin: offset,
        );
      },
    ),
    trail: const StraightTrail(
      trailWidth: 3,
      trailProgress: .3,
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
For the relativistic version, the process is similar, but we remove solid edges by setting `SolidEdges.none`, allowing particles to travel without interacting with boundaries.

```dart
 RelativisticEffectConfiguration(
    gravity: Gravity.earthGravity,
    minAngle: -100,
    maxAngle: -80,
    minFadeOutThreshold: .6,
    maxFadeOutThreshold: .8,
    maxParticleLifespan: const Duration(seconds: 1, milliseconds: 500),
    emitDuration: const Duration(milliseconds: 500),
    minEndScale: 1,
    maxEndScale: 1,
    minVelocity: const Velocity(9),
    maxVelocity: const Velocity(10),
    origin: const Offset(0.5, 1),
    solidEdges: SolidEdges.none,
    particleConfiguration: ParticleConfiguration(
      shape: const CircleShape(),
      size: const Size(5, 5),
      postEffectBuilder: (particle, effect) {
        final offset = Offset(
          particle.position.dx / effect.surfaceSize.width,
          particle.position.dy / effect.surfaceSize.height,
        );
        return RelativisticEffectConfiguration(
          gravity: Gravity.earthGravity,
          maxAngle: 180,
          minAngle: -180,
          particleCount: 10,
          solidEdges: SolidEdges.none,
          minVelocity: const Velocity(5),
          maxVelocity: const Velocity(5),
          particleConfiguration: const ParticleConfiguration(
            shape: CircleShape(),
            size: Size(5, 5),
            color: SingleParticleColor(color: Colors.blue),
          ),
          particlesPerEmit: 10,
          origin: offset,
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
