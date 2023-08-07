---
sidebar_position: 4
---

# Custom Effect

To customize an effect, let's explore the rain effect as an example.
The rain effect emits particles at regular intervals (default `emitDuration`: 100ms) that follow a
downward path.
By emitting particles from various locations and applying different `animationDuration`, we create a
dynamic rain effect, with each particle traveling at a unique pace.

Before we proceed, a friendly reminder: all durations are in milliseconds, distances are measured in
logical pixels, and angles are specified in degrees.

## Rain Example

First you will extend the `Effect` class with `AnimatedParticle` as particles:

```dart
class RainEffect extends Effect<AnimatedParticle> {

  RainEffect({
    required super.particleConfiguration,
    required super.effectConfiguration,
  });

  @override
  AnimatedParticle instantiateParticle(Size surfaceSize) {
    // Here is where the magic happens
  }
}
```

In Newton, customizing particle emission is straightforward with just one method to
override: `instantiateParticle(Size surfaceSize)`.
When this method is called upon emission, you can define how particles are emitted.

In Newton effects, the `AnimatedParticle` serves as the default particle, moving in a straight line
upon emission.
The `surfaceSize` represents the available animation area.

The `particleConfiguration` describes the aspect of the particle (size, shape, color etc.).

The `EffectConfiguration` describes how particles will be emitted (angle, distance, etc.). 

For the rain effect, particles will originate randomly along the top side at various x-coordinates,
and each particle will travel a distance equivalent to `surfaceSize.height`.

```dart
class RainEffect extends Effect<AnimatedParticle> {

  RainEffect({
    required super.particleConfiguration,
    required super.effectConfiguration,
  });

  @override
  AnimatedParticle instantiateParticle(Size surfaceSize) {
    return AnimatedParticle(
      particle: Particle(
        configuration: particleConfiguration,
        position: Offset(
          random.nextDouble() * surfaceSize.width,
          0,
        ),
      ),
      pathTransformation: StraightPathTransformation(
        distance: surfaceSize.height,
        angle: 90,
      ),
      startTime: totalElapsed,
      animationDuration: randomDuration(),
    );
  }
}
```

`startTime` is necessary to know when particle is emitted an be able to compute the animation
duration properly.
Most of the time it will `totalElapsed` a property from the effect, which is the total elapsed time
in milliseconds since the effect started.

`StraightPathTransformation` is the function applied to know what is the position of the particle given
a `progress`. In this example, the particle will travel in a straight line following an angle of 90 degrees (going down).

`randomDuration` is provided by the `Effect` class and will give random duration based
on `EffectConfiguration.minDuration` and `EffectConfiguration.maxDuration`.
This `animationDuration` property will give the effect that particles don't fall at the same pace.

And “voilà” you have a rain effect, to use it just reuse the code
from [Getting Started](/docs/intro)

## Firework Example

In this example, we will go further by chaining effects. To achieve the firework effect, we are just going
to trigger a explode effect once the particle travel is over. We also add some trail effect to the particle. 
To do that, it's pretty straightforward:

```dart
ExplodeEffect(
      particleConfiguration: ParticleConfiguration(
          shape: CircleShape(),
          size: const Size(5, 5),
          color: const SingleParticleColor(color: Colors.white),
          postEffectBuilder: (particle) => ExplodeEffect(
            particleConfiguration: ParticleConfiguration(
              shape: CircleShape(),
              size: const Size(5, 5),
              color: const SingleParticleColor(color: Colors.blue),
            ),
            effectConfiguration: EffectConfiguration(
              maxAngle: 180,
              minAngle: -180,
              minDuration: 1000,
              maxDuration: 2000,
              minFadeOutThreshold: 0.6,
              maxFadeOutThreshold: 0.8,
              particleCount: 10,
              particlesPerEmit: 10,
              distanceCurve: Curves.decelerate,
              origin: particle.position,
              trail: StraightTrail(trailProgress: 0.3, trailWidth: 3.0)
            )
          )
      ),
      effectConfiguration: EffectConfiguration(
        emitDuration: 600,
        minAngle: -120,
        maxAngle: -60,
        minDuration: 1000,
        maxDuration: 2000,
        minFadeOutThreshold: 0.6,
        maxFadeOutThreshold: 0.8,
        distanceCurve: Curves.decelerate,
        origin: Offset(size.width / 2, size.height / 2),
        trail: StraightTrail(trailProgress: 0.3, trailWidth: 3.0),
      ),
);
```

Here are the key concepts for this effect:
1. We restrict the first explode effect angles so the particles only go upward with a reasonable angle.
2. We customise the particle travel with a `decelerate`effect and a `fadeOut` so the particle will disappear just before it explodes.
3. In the particle configuration we can add a post Effect by providing a `postEffectBuilder`. This builder takes the up to date particle upon explosion as parameter, thus you can trigger the explode from the particle `position`.
4. We define `particleCount` so the animation is not infinite and a `particlePerEmit` in order to fire all the particles upon explosion. We don't restrict angles to have 360° explosion.
5. We customize the trail effect with a `StraightTrail`. The `trailProgress` means how far we want to go back for the trail.

Enjoy your firework!

## All Effect Properties

- `emitDuration`: `int` - Duration between particle emissions. Default: `100`
- `particlesPerEmit`: `int` - Number of particles emitted per emission. Default: `1`
- `emitCurve`: `Curve` - Curve to control the emission timing. Default: `Curves.decelerate`
- `origin`: `Offset` - Origin point for particle emission. Default: `Offset(0, 0)`
- `minDistance`: `double` - Minimum distance traveled by particles. Default: `100`
- `maxDistance`: `double` - Maximum distance traveled by particles. Default: `200`
- `distanceCurve`: `Curve` - Curve to control particle travel distance. Default: `Curves.linear`
- `minDuration`: `int` - Minimum particle animation duration. Default: `1000`
- `maxDuration`: `int` - Maximum particle animation duration. Default: `1000`
- `minBeginScale`: `double` - Minimum initial particle scale. Default: `1`
- `maxBeginScale`: `double` - Maximum initial particle scale. Default: `1`
- `minEndScale`: `double` - Minimum final particle scale. Default: `-1`
- `maxEndScale`: `double` - Maximum final particle scale. Default: `-1`
- `scaleCurve`: `Curve` - Curve to control particle scaling animation. Default: `Curves.linear`
- `minFadeOutThreshold`: `double` - Minimum opacity threshold for particle fade-out. Default: `1`
- `maxFadeOutThreshold`: `double` - Maximum opacity threshold for particle fade-out. Default: `1`
- `fadeOutCurve`: `Curve` - Curve to control particle fade-out animation. Default: `Curves.linear`
- `minFadeInLimit`: `double` - Minimum opacity limit for particle fade-in. Default: `0`
- `maxFadeInLimit`: `double` - Maximum opacity limit for particle fade-in. Default: `0`
- `fadeInCurve`: `Curve` - Curve to control particle fade-in animation. Default: `Curves.linear`
- `minAngle`: `double` - Min angle in degrees for particle. Default: `0`
- `maxAngle`: `double` - Max angle in degrees for particle. Default: `0`
- `trail`: `Trail` - Define trail behavior, see [Trail](https://pub.dev/documentation/newton_particles/latest/newton_particles/Trail-class.html). Default: `NoTrail()`

## Particle Configuration

`ParticleConfiguration` is use to describe the particle aspect. Main properties are:

1. `shape`: can be `CircleShape`, `SquareShape` or `ImageShape`
2. `size`: `width` and `height` of the particle
3. `color`: the particle color see [ParticleColor](https://pub.dev/documentation/newton_particles/latest/newton_particles/ParticleColor-class.html), doesn't apply for the `ImageShape`
4. `postEffectBuilder`: from last particle position you can trigger a chain reaction

## Custom Particle

If you want to fine grain how the particle is travelling you can create your own particle by
extending
`AnimatedParticle`:

```dart

class MyCustomParticle extends AnimatedParticle {
  @override
  onAnimationUpdate(double progress) {
    // Do whatever you want
  }
}
```

Just override the `onAnimationUpdate(double progress)` method to fine-tune your particle travel.
From this place you can adjust `position`, `size`, `color`, `shape` over time and achieve whatever effect
you have in mind.