import 'package:flutter/widgets.dart';
import 'package:newton_particles/newton_particles.dart';

/// The `DeterministicEffectConfiguration` class defines the configuration settings for a deterministic particle effect.
///
/// This class extends [EffectConfiguration] and introduces additional properties to control the travel distance of particles
/// and to specify a custom path builder for particle motion. It allows for precise control over particle behavior in a deterministic effect.
class DeterministicEffectConfiguration extends EffectConfiguration {
  /// Creates an instance of [DeterministicEffectConfiguration] with the specified parameters.
  ///
  /// - [customPathBuilder]: A function that defines a custom path transformation for particles.
  /// - [distanceCurve]: A curve to control the particle travel distance. Default is [Curves.linear].
  /// - [maxDistance]: The maximum distance particles can travel. Default is `200`.
  /// - [minDistance]: The minimum distance particles can travel. Default is `100`.
  /// - [emitCurve]: A curve to control the emission timing. Inherited from [EffectConfiguration].
  /// - [emitDuration]: The duration between particle emissions. Inherited from [EffectConfiguration].
  /// - [fadeInCurve]: A curve to control the fade-in animation progress. Inherited from [EffectConfiguration].
  /// - [fadeOutCurve]: A curve to control the fade-out animation progress. Inherited from [EffectConfiguration].
  /// - [foreground]: Indicates whether the effect should be played in the foreground. Inherited from [EffectConfiguration].
  /// - [maxAngle]: The maximum angle in degrees for particle trajectory. Inherited from [EffectConfiguration].
  /// - [maxBeginScale]: The maximum initial particle scale. Inherited from [EffectConfiguration].
  /// - [maxDuration]: The maximum duration of the particle animation. Inherited from [EffectConfiguration].
  /// - [maxEndScale]: The maximum final particle scale. Inherited from [EffectConfiguration].
  /// - [maxFadeInThreshold]: The maximum opacity threshold for particle fade-in. Inherited from [EffectConfiguration].
  /// - [maxFadeOutThreshold]: The maximum opacity threshold for particle fade-out. Inherited from [EffectConfiguration].
  /// - [maxOriginOffset]: The offset for the maximum origin point of particle emission. Inherited from [EffectConfiguration].
  /// - [minAngle]: The minimum angle in degrees for particle trajectory. Inherited from [EffectConfiguration].
  /// - [minBeginScale]: The minimum initial particle scale. Inherited from [EffectConfiguration].
  /// - [minDuration]: The minimum duration of the particle animation. Inherited from [EffectConfiguration].
  /// - [minEndScale]: The minimum final particle scale. Inherited from [EffectConfiguration].
  /// - [minFadeInThreshold]: The minimum opacity threshold for particle fade-in. Inherited from [EffectConfiguration].
  /// - [minFadeOutThreshold]: The minimum opacity threshold for particle fade-out. Inherited from [EffectConfiguration].
  /// - [minOriginOffset]: The offset for the minimum origin point of particle emission. Inherited from [EffectConfiguration].
  /// - [origin]: The origin point for particle emission, relative from the top left of the container. Inherited from [EffectConfiguration].
  /// - [particleCount]: The total number of particles to emit. Inherited from [EffectConfiguration].
  /// - [particlesPerEmit]: The number of particles emitted per emission. Inherited from [EffectConfiguration].
  /// - [scaleCurve]: A curve to control particle scaling animation progress. Inherited from [EffectConfiguration].
  /// - [startDelay]: The delay before starting the effect. Inherited from [EffectConfiguration].
  /// - [trail]: The trail effect associated with the particles. Inherited from [EffectConfiguration].
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
    super.foreground,
    super.maxAngle,
    super.maxBeginScale,
    super.maxDuration,
    super.maxEndScale,
    super.maxFadeInThreshold,
    super.maxFadeOutThreshold,
    super.maxOriginOffset,
    super.minAngle,
    super.minBeginScale,
    super.minDuration,
    super.minEndScale,
    super.minFadeInThreshold,
    super.minFadeOutThreshold,
    super.minOriginOffset,
    super.origin,
    super.particleCount,
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
  DeterministicEffectConfiguration copyWith({
    DeterministicPathTransformation Function(
            Effect<DeterministicAnimatedParticle, DeterministicEffectConfiguration>, DeterministicAnimatedParticle,)?
        customPathBuilder,
    Curve? distanceCurve,
    Curve? emitCurve,
    Duration? emitDuration,
    Curve? fadeInCurve,
    Curve? fadeOutCurve,
    bool? foreground,
    double? maxAngle,
    double? maxBeginScale,
    Duration? maxDuration,
    double? maxDistance,
    double? maxEndScale,
    double? maxFadeInThreshold,
    double? maxFadeOutThreshold,
    Offset? maxOriginOffset,
    double? minAngle,
    double? minBeginScale,
    Duration? minDuration,
    double? minDistance,
    double? minEndScale,
    double? minFadeInThreshold,
    double? minFadeOutThreshold,
    Offset? minOriginOffset,
    Offset? origin,
    ParticleConfiguration? particleConfiguration,
    int? particleCount,
    int? particlesPerEmit,
    Curve? scaleCurve,
    Duration? startDelay,
    Trail? trail,
  }) {
    return DeterministicEffectConfiguration(
      particleConfiguration: particleConfiguration ?? this.particleConfiguration,
      customPathBuilder: customPathBuilder ?? this.customPathBuilder,
      distanceCurve: distanceCurve ?? this.distanceCurve,
      emitCurve: emitCurve ?? this.emitCurve,
      emitDuration: emitDuration ?? this.emitDuration,
      fadeInCurve: fadeInCurve ?? this.fadeInCurve,
      fadeOutCurve: fadeOutCurve ?? this.fadeOutCurve,
      foreground: foreground ?? this.foreground,
      maxAngle: maxAngle ?? this.maxAngle,
      maxBeginScale: maxBeginScale ?? this.maxBeginScale,
      maxDuration: maxDuration ?? this.maxDuration,
      maxDistance: maxDistance ?? this.maxDistance,
      maxEndScale: maxEndScale ?? this.maxEndScale,
      maxFadeInThreshold: maxFadeInThreshold ?? this.maxFadeInThreshold,
      maxFadeOutThreshold: maxFadeOutThreshold ?? this.maxFadeOutThreshold,
      maxOriginOffset: maxOriginOffset ?? this.maxOriginOffset,
      minAngle: minAngle ?? this.minAngle,
      minBeginScale: minBeginScale ?? this.minBeginScale,
      minDuration: minDuration ?? this.minDuration,
      minDistance: minDistance ?? this.minDistance,
      minEndScale: minEndScale ?? this.minEndScale,
      minFadeInThreshold: minFadeInThreshold ?? this.minFadeInThreshold,
      minFadeOutThreshold: minFadeOutThreshold ?? this.minFadeOutThreshold,
      minOriginOffset: minOriginOffset ?? this.minOriginOffset,
      origin: origin ?? this.origin,
      particleCount: particleCount ?? this.particleCount,
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
}
