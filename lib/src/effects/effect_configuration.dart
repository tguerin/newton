import 'package:flutter/widgets.dart';
import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/effects/deterministic/deterministic_effect.dart';
import 'package:newton_particles/src/utils/particle_pool.dart';

/// Extension type `Tag` represents a simple wrapper around a string value that can be used
/// to tag or identify specific configurations, effects, or particles within the Newton system.
///
/// Example usage:
///
/// ```dart
/// final myTag = Tag('uniqueTag');
/// print(myTag.value); // Output: uniqueTag
/// ```
extension type const Tag(String value) {}

/// Configuration class for defining particle emission properties in Newton effects.
///
/// The `EffectConfiguration` class provides a flexible framework for customizing particle
/// emission in Newton effects. It allows you to configure various parameters, such as emission
/// duration, particle count per emission, emission curve, origin, and more, to fine-tune the
/// behavior and appearance of particles in a Newton effect.
///
/// This class is abstract and is meant to be extended by specific configurations, such as
/// `DeterministicEffectConfiguration` or `PhysicsEffectConfiguration`.
///
/// Example usage:
///
/// ```dart
/// final config = SomeEffectConfiguration(
///   particleConfiguration: ParticleConfiguration(...),
///   emitCurve: Curves.easeIn,
///   maxDuration: Duration(seconds: 2),
///   particleCount: 100,
/// );
/// ```
@immutable
abstract class EffectConfiguration<T extends ParticleConfiguration> {
  /// An abstract class representing the configuration for particle effects,
  /// providing a foundation for controlling particle emission, animation,
  /// and visual behavior.
  ///
  /// The [EffectConfiguration] class defines various parameters such as emission rate,
  /// particle scaling, fading, and lifespans, but it cannot be instantiated directly.
  /// Instead, this class is meant to be extended by other concrete effect configurations
  /// that implement specific behavior.
  ///
  /// Subclasses such as [DeterministicEffectConfiguration] or [PhysicsEffectConfiguration]
  /// (recommended) inherit and build upon the parameters defined here, allowing developers
  /// to create customized particle effects.
  ///
  /// - [particleConfiguration]: The general configuration for how particles are emitted and animated.
  /// - [emitCurve]: A curve that controls the rate of particle emission over time. Defaults to [Curves.decelerate],
  ///   which gradually slows the emission rate.
  /// - [emitDuration]: The interval between each emission of particles. Defaults to 100 milliseconds.
  /// - [fadeInCurve]: A curve that controls how particles fade in, typically from transparent to fully visible.
  ///   Defaults to [Curves.linear] for a consistent fade-in.
  /// - [fadeOutCurve]: A curve that controls how particles fade out, typically from fully visible to transparent.
  ///   Defaults to [Curves.linear] for a consistent fade-out.
  /// - [origin]: The origin point for particle emission, relative to the top-left corner of the container.
  ///   Defaults to the center of the container at [Offset(0.5, 0.5)].
  /// - [particleCount]: The total number of particles that will be emitted over the lifetime of the effect.
  ///   Defaults to `0`, meaning no particles will be emitted by default.
  /// - [particleLayer]: Specifies the layer on which particles will be rendered. Defaults to [ParticleLayer.background],
  ///   meaning particles will render behind other elements.
  /// - [particlesPerEmit]: The number of particles emitted during each emission event. Defaults to `1`.
  /// - [scaleCurve]: A curve controlling how the particle size changes over time. Defaults to [Curves.linear],
  ///   which means the size change is consistent.
  /// - [startDelay]: The delay before particle emission starts after the effect is triggered. Defaults to no delay (`Duration.zero`).
  /// - [tag]: An optional identifier to tag or label the effect for tracking or reference purposes.
  /// - [trail]: Specifies the trailing effect that follows each particle, providing additional visual flair. Defaults to [NoTrail()],
  ///   which means no trailing effect will be applied to particles.
  ///
  /// For range-based properties (angles, scales, fade thresholds, etc.), see the grouped properties classes:
  /// - [VisualProperties] for scale and fade ranges
  /// - [EmissionProperties] for emission timing, origin offsets, and lifespan ranges
  /// - [PhysicsProperties] or [DeterministicProperties] for angle ranges
  ///
  /// Note: This constructor only accepts [particleConfiguration] and [tag].
  /// All other properties are provided by subclasses via grouped property classes
  /// (VisualProperties, EmissionProperties, AnimationProperties, LayerProperties, etc.).
  /// Subclasses set these fields in their initializer lists from the grouped properties.
  const EffectConfiguration({
    required this.particleConfiguration,
    this.tag,
  });

  /// Defines the configuration of the emitted particles.
  final T particleConfiguration;

  /// Tag to identify the effect configuration, allowing for easy reference or management. Optional.
  final Tag? tag;

  // The following fields are provided by subclasses via grouped properties.
  // They are declared here for convenience and are accessed through properties objects.
  // Subclasses set these fields in their initializer lists from grouped properties.

  /// Curve to control the emission timing of particles.
  /// Provided by subclasses via [EmissionProperties].
  Curve get emitCurve;

  /// Duration between particle emissions.
  /// Provided by subclasses via [EmissionProperties].
  Duration get emitDuration;

  /// Curve to control particle fade-in animation.
  /// Provided by subclasses via [VisualProperties].
  Curve get fadeInCurve;

  /// Curve to control particle fade-out animation.
  /// Provided by subclasses via [VisualProperties].
  Curve get fadeOutCurve;

  /// Origin point for particle emission, relative from the top-left of the container.
  /// Provided by subclasses via [EmissionProperties].
  Offset get origin;

  /// Total number of particles to emit.
  /// Provided by subclasses via [EmissionProperties].
  int get particleCount;

  /// The layer on which the particles should be rendered.
  /// Provided by subclasses via [LayerProperties].
  ParticleLayer get particleLayer;

  /// Number of particles emitted per emission event.
  /// Provided by subclasses via [EmissionProperties].
  int get particlesPerEmit;

  /// Curve to control particle scaling animation.
  /// Provided by subclasses via [VisualProperties].
  Curve get scaleCurve;

  /// Delay before starting the particle effect.
  /// Provided by subclasses via [AnimationProperties].
  Duration get startDelay;

  /// The trail effect associated with emitted particles.
  /// Provided by subclasses via [LayerProperties].
  Trail get trail;

  /// Helper method to generate a random angle within the configured range.
  /// Delegates to the appropriate properties object (PhysicsProperties or DeterministicProperties).
  double randomAngle();

  /// Helper method to generate a random duration within the configured lifespan range.
  /// Delegates to [EmissionProperties].
  Duration randomDuration();

  /// Helper method to generate a random fade-in threshold within the configured range.
  /// Delegates to [VisualProperties].
  double randomFadeInThreshold();

  /// Helper method to generate a random fade-out threshold within the configured range.
  /// Delegates to [VisualProperties].
  double randomFadeOutThreshold();

  /// Helper method to generate a random origin offset within the configured range.
  /// Delegates to [EmissionProperties].
  Offset randomOriginOffset();

  /// Helper method to determine if the particle should be rendered in the foreground based on [particleLayer].
  bool randomParticleForeground() {
    return switch (particleLayer) {
      ParticleLayer.background => false,
      ParticleLayer.foreground => true,
      ParticleLayer.random => random.nextBool(),
    };
  }

  /// Helper method to generate a random scale tween within the configured ranges.
  /// Delegates to [VisualProperties].
  Tween<double> randomScaleRange();

  /// Creates a copy of this `EffectConfiguration` with the specified overrides.
  /// Subclasses should override this to accept grouped properties.
  EffectConfiguration copyWith({
    ParticleConfiguration? particleConfiguration,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EffectConfiguration &&
          runtimeType == other.runtimeType &&
          particleConfiguration == other.particleConfiguration &&
          tag == other.tag;

  @override
  int get hashCode => particleConfiguration.hashCode ^ tag.hashCode;
}

/// Extension on `EffectConfiguration` that provides a method to create an `Effect`
/// based on the specific type of `EffectConfiguration`.
extension EffectForConfiguration on EffectConfiguration<ParticleConfiguration> {
  /// Creates an `Effect` based on the specific type of `EffectConfiguration`.
  ///
  /// - [particlePool]: Optional particle pool for reusing particle instances.
  ///   If not provided, each effect will use its own default pool.
  ///   Providing a custom pool allows you to control memory usage and share
  ///   pools across multiple effects.
  Effect<AnimatedParticle, EffectConfiguration> effect({ParticlePool? particlePool}) => switch (this) {
        final DeterministicEffectConfiguration effectConfiguration => DeterministicEffect(
            effectConfiguration,
            particlePool: particlePool,
          ),
        final PhysicsEffectConfiguration effectConfiguration => PhysicsEffect(
            effectConfiguration,
            particlePool: particlePool,
          ),
        _ => throw Exception('Unexpected configuration type'),
      } as Effect<AnimatedParticle, EffectConfiguration>;
}
