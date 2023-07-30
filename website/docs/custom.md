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

The `particleConfiguration` describes the aspect of the particle (size, shape, color etc.)

For the rain effect, particles will originate randomly along the top side at various x-coordinates,
and each particle will travel a distance equivalent to `surfaceSize.height`.

```dart
class RainEffect extends Effect<AnimatedParticle> {

  RainEffect({
    required super.particleConfiguration,
    super.minDuration,
    super.maxDuration,
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
      angle: 90,
      distance: surfaceSize.height,
      startTime: totalElapsed,
      animationDuration: randomDuration(),
    );
  }
}
```

`startTime` is necessary to know when particle is emitted an be able to compute the animation
duration properly.
Most of the time it will `totalElapsed` a property from the effect, which is the total elapsed time
in milliseconds since
the effect started.

`randomDuration` is provided by the `Effect` class and will provide random duration based
on `minDuration` and `maxDuration`.
This `animationDuration` property will give the effect that particles don't fall at the same pace.

And “voilà” you have a rain effect, to use it just reuse the code
from [Getting Started](/docs/intro)

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

## Particle Configuration

`ParticleConfiguration` is use to describe the particle aspect. Main properties are:

1. `shape`: can be `CircleShape`, `SquareShape` or `ImageShape`
2. `size`: `width` and `height` of the particle
3. `color`: the particle color, doesn't apply for the `ImageShape`

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
From this place you can adjust `position`, `size`, `color, shape over time and achieve whatever effect
you have in mind.