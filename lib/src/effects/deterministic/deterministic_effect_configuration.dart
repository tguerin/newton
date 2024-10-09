import 'package:flutter/widgets.dart';
import 'package:newton_particles/newton_particles.dart';

/// The `DeterministicEffectConfiguration` class defines the configuration settings for a deterministic particle effect.
///
/// This class extends [EffectConfiguration] and introduces additional properties to control the travel distance of particles
/// and to specify a custom path builder for particle motion. It allows for precise control over particle behavior in a deterministic effect.
@immutable
class DeterministicEffectConfiguration extends EffectConfiguration {
  /// Creates an instance of [DeterministicEffectConfiguration] with customizable parameters
  /// to control the behavior of particles in a deterministic manner.
  ///
  /// This configuration allows detailed control over the movement paths, emission properties,
  /// and particle scaling, giving fine-grained control over visual effects.
  ///
  /// - [particleConfiguration]: General particle configuration inherited from [EffectConfiguration],
  ///   defining how particles are emitted and animated.
  /// - [customPathBuilder]: A function to define a custom particle movement path. This allows
  ///   developers to define unique trajectories for particles beyond standard configurations.
  /// - [distanceCurve]: A curve that determines how particle travel distance changes over time.
  ///   The default is [Curves.linear], which provides a constant rate of movement.
  /// - [maxDistance]: The maximum distance that particles can travel from their origin. Defaults to `200`.
  /// - [minDistance]: The minimum distance that particles can travel from their origin. Defaults to `100`.
  ///
  /// Inherited parameters from [EffectConfiguration]:
  /// - [emitCurve]: A curve that controls the timing and rate of particle emission.
  /// - [emitDuration]: The interval between particle emissions, controlling how long the effect lasts.
  /// - [fadeInCurve]: A curve that controls the fade-in effect for particles, allowing smooth appearance animations.
  /// - [fadeOutCurve]: A curve that controls the fade-out effect for particles, allowing particles to disappear gradually.
  /// - [foreground]: Determines whether the effect should render in the foreground layer.
  ///   When set to `true`, particles are rendered on top of other visual elements.
  /// - [maxAngle]: The maximum angle (in degrees) for particle trajectory, providing control over the
  ///   directional spread of particles.
  /// - [maxBeginScale]: The maximum starting scale for particles, controlling their initial size.
  /// - [maxEndScale]: The maximum final scale for particles after any scaling animations are applied.
  /// - [maxFadeInThreshold]: The highest opacity value at which particles will complete fading in,
  ///   controlling the visibility at the start of the effect.
  /// - [maxFadeOutThreshold]: The highest opacity value at which particles begin fading out, controlling
  ///   when particles start to disappear.
  /// - [maxOriginOffset]: The maximum offset for particle emission, determining how far the particles
  ///   can start from the specified origin point.
  /// - [maxParticleLifespan]: The maximum time a particle can exist before being removed from the effect.
  /// - [minAngle]: The minimum angle (in degrees) for particle trajectory, allowing more control over particle directionality.
  /// - [minBeginScale]: The minimum initial scale of particles, controlling their starting size for smaller particles.
  /// - [minEndScale]: The minimum final scale of particles after scaling animations, controlling how small particles can become.
  /// - [minFadeInThreshold]: The lowest opacity value at which particles start to fade in, controlling
  ///   when particles become visible.
  /// - [minFadeOutThreshold]: The lowest opacity value at which particles start to fade out,
  ///   controlling when particles begin disappearing.
  /// - [minOriginOffset]: The minimum offset for particle emission relative to the origin point,
  ///   controlling where particles can be emitted from.
  /// - [minParticleLifespan]: The minimum lifespan for particles, determining how long they remain visible.
  /// - [origin]: The starting point for particle emission, relative to the top-left corner of the container.
  /// - [particleCount]: The total number of particles that will be emitted during the lifetime of the effect.
  /// - [particlesPerEmit]: The number of particles emitted in each burst or emission cycle.
  /// - [particleLayer]: The visual layer on which particles are rendered, allowing for layered visual effects.
  /// - [scaleCurve]: A curve controlling how the particle size changes over time, allowing for smooth scaling animations.
  /// - [startDelay]: The delay before the effect starts after it has been triggered, useful for timed or staged animations.
  /// - [trail]: Defines a trailing effect for particles as they move, adding visual trails for more dynamic effects.
  const DeterministicEffectConfiguration({
    required super.particleConfiguration,
    this.customPathBuilder,
    this.distanceCurve = Curves.linear,
    this.maxDistance = 200,
    this.minDistance = 100,
    super.emitCurve,
    super.emitDuration,
    super.fadeInCurve,
    super.fadeOutCurve,
    super.maxAngle,
    super.maxBeginScale,
    super.maxEndScale,
    super.maxFadeInThreshold,
    super.maxFadeOutThreshold,
    super.maxOriginOffset,
    super.maxParticleLifespan,
    super.minAngle,
    super.minBeginScale,
    super.minEndScale,
    super.minFadeInThreshold,
    super.minFadeOutThreshold,
    super.minOriginOffset,
    super.minParticleLifespan,
    super.origin,
    super.particleCount,
    super.particleLayer,
    super.particlesPerEmit,
    super.scaleCurve,
    super.startDelay,
    super.trail,
  });

  /// Curve to control particle travel distance. Default: [Curves.linear].
  final Curve distanceCurve;

  /// Maximum distance traveled by particles. Default: `200`.
  final double maxDistance;

  /// Minimum distance traveled by particles. Default: `100`.
  final double minDistance;

  /// Define your own particle path based on current effect state and the initialized particle
  final DeterministicPathTransformation Function(
    Effect<DeterministicAnimatedParticle, DeterministicEffectConfiguration>,
    DeterministicAnimatedParticle,
  )? customPathBuilder;

  /// Copies the current configuration with the possibility to override specific properties.
  ///
  /// This method is useful when you want to create a new configuration based on an existing one,
  /// but with some modified properties.
  @override
  DeterministicEffectConfiguration copyWith({
    DeterministicPathTransformation Function(
      Effect<DeterministicAnimatedParticle, DeterministicEffectConfiguration>,
      DeterministicAnimatedParticle,
    )? customPathBuilder,
    Curve? distanceCurve,
    Curve? emitCurve,
    Duration? emitDuration,
    Curve? fadeInCurve,
    Curve? fadeOutCurve,
    bool? foreground,
    double? maxAngle,
    double? maxBeginScale,
    double? maxDistance,
    double? maxEndScale,
    double? maxFadeInThreshold,
    double? maxFadeOutThreshold,
    Offset? maxOriginOffset,
    Duration? maxParticleLifespan,
    double? minAngle,
    double? minBeginScale,
    double? minDistance,
    double? minEndScale,
    double? minFadeInThreshold,
    double? minFadeOutThreshold,
    Offset? minOriginOffset,
    Duration? minParticleLifespan,
    Offset? origin,
    ParticleConfiguration? particleConfiguration,
    int? particleCount,
    ParticleLayer? particleLayer,
    int? particlesPerEmit,
    Curve? scaleCurve,
    Duration? startDelay,
    Trail? trail,
  }) {
    return DeterministicEffectConfiguration(
      customPathBuilder: customPathBuilder ?? this.customPathBuilder,
      distanceCurve: distanceCurve ?? this.distanceCurve,
      emitCurve: emitCurve ?? this.emitCurve,
      emitDuration: emitDuration ?? this.emitDuration,
      fadeInCurve: fadeInCurve ?? this.fadeInCurve,
      fadeOutCurve: fadeOutCurve ?? this.fadeOutCurve,
      maxAngle: maxAngle ?? this.maxAngle,
      maxBeginScale: maxBeginScale ?? this.maxBeginScale,
      maxDistance: maxDistance ?? this.maxDistance,
      maxEndScale: maxEndScale ?? this.maxEndScale,
      maxFadeInThreshold: maxFadeInThreshold ?? this.maxFadeInThreshold,
      maxFadeOutThreshold: maxFadeOutThreshold ?? this.maxFadeOutThreshold,
      maxOriginOffset: maxOriginOffset ?? this.maxOriginOffset,
      maxParticleLifespan: maxParticleLifespan ?? this.maxParticleLifespan,
      minAngle: minAngle ?? this.minAngle,
      minBeginScale: minBeginScale ?? this.minBeginScale,
      minDistance: minDistance ?? this.minDistance,
      minEndScale: minEndScale ?? this.minEndScale,
      minFadeInThreshold: minFadeInThreshold ?? this.minFadeInThreshold,
      minFadeOutThreshold: minFadeOutThreshold ?? this.minFadeOutThreshold,
      minOriginOffset: minOriginOffset ?? this.minOriginOffset,
      minParticleLifespan: minParticleLifespan ?? this.minParticleLifespan,
      origin: origin ?? this.origin,
      particleConfiguration: particleConfiguration ?? this.particleConfiguration,
      particleCount: particleCount ?? this.particleCount,
      particleLayer: particleLayer ?? this.particleLayer,
      particlesPerEmit: particlesPerEmit ?? this.particlesPerEmit,
      scaleCurve: scaleCurve ?? this.scaleCurve,
      startDelay: startDelay ?? this.startDelay,
      trail: trail ?? this.trail,
    );
  }

  /// Generates a random distance for a particle within the specified min and max range.
  ///
  /// This method is used to determine how far a particle should travel, providing
  /// variation in particle motion within the effect.
  double randomDistance() {
    return random.nextDoubleRange(
      minDistance,
      maxDistance,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is DeterministicEffectConfiguration &&
          runtimeType == other.runtimeType &&
          distanceCurve == other.distanceCurve &&
          maxDistance == other.maxDistance &&
          minDistance == other.minDistance &&
          customPathBuilder == other.customPathBuilder;

  @override
  int get hashCode =>
      super.hashCode ^
      distanceCurve.hashCode ^
      maxDistance.hashCode ^
      minDistance.hashCode ^
      customPathBuilder.hashCode;
}
