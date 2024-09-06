import 'dart:ui';

import 'package:newton_particles/newton_particles.dart';

/// The `DeterministicEffect` class represents a particle effect where the behavior of
/// particles follows a predetermined or deterministic path.
///
/// This class is a specialized implementation of [Effect] that generates particles
/// with deterministic animation properties. It allows for precise control over particle
/// movement, scaling, fading, and more by using custom path transformations and configurations.
class DeterministicEffect extends Effect<DeterministicAnimatedParticle, DeterministicEffectConfiguration> {
  /// Creates an instance of [DeterministicEffect] with the specified configurations.
  ///
  /// - [effectConfiguration]: The configuration settings for the effect, defining how particles should behave.
  DeterministicEffect(super.effectConfiguration);

  /// Instantiates and returns a new [DeterministicAnimatedParticle] based on the current effect configuration.
  ///
  /// This method uses the provided [surfaceSize] to calculate the initial position of the particle
  /// and applies a path transformation, either custom-defined or a default straight path.
  ///
  /// - [surfaceSize]: The size of the surface where the effect is rendered. This is used to calculate the particle's position and movement.
  ///
  /// Returns a [DeterministicAnimatedParticle] that will be animated according to the effect's configuration.
  @override
  DeterministicAnimatedParticle instantiateParticle(Size surfaceSize) {
    final pathBuilder = effectConfiguration.customPathBuilder;
    final randomOriginOffset = effectConfiguration.randomOriginOffset();
    final deterministicAnimatedParticle = DeterministicAnimatedParticle(
      animationDuration: effectConfiguration.randomDuration(),
      distanceCurve: effectConfiguration.distanceCurve,
      elapsedTimeOnStart: totalElapsed,
      fadeInCurve: effectConfiguration.fadeInCurve,
      fadeInThreshold: effectConfiguration.randomFadeInThreshold(),
      fadeOutCurve: effectConfiguration.fadeOutCurve,
      fadeOutThreshold: effectConfiguration.randomFadeOutThreshold(),
      foreground: effectConfiguration.randomParticleForeground(),
      onPathTransformationRequested: (animatedParticle) {
        return pathBuilder != null
            ? pathBuilder(this, animatedParticle)
            : StraightPathTransformation(
                distance: effectConfiguration.randomDistance(),
                angle: effectConfiguration.randomAngle(),
              );
      },
      particle: Particle(
        configuration: effectConfiguration.particleConfiguration,
        position: Offset(
              effectConfiguration.origin.dx * surfaceSize.width,
              effectConfiguration.origin.dy * surfaceSize.height,
            ) +
            Offset(
              randomOriginOffset.dx * surfaceSize.width,
              randomOriginOffset.dy * surfaceSize.height,
            ),
      ),
      scaleRange: effectConfiguration.randomScaleRange(),
      scaleCurve: effectConfiguration.scaleCurve,
      trail: effectConfiguration.trail,
    );

    return deterministicAnimatedParticle;
  }
}
