import 'package:flutter/widgets.dart';
import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/effects/deterministic/deterministic_effect.dart';
import 'package:newton_particles/src/effects/relativistic/relativistic_effect.dart';

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
/// `DeterministicEffectConfiguration` or `RelativisticEffectConfiguration`.
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
  /// Subclasses such as [DeterministicEffectConfiguration] or [RelativisticEffectConfiguration]
  /// inherit and build upon the parameters defined here, allowing developers to create
  /// customized particle effects.
  ///
  /// - [particleConfiguration]: The general configuration for how particles are emitted and animated.
  /// - [emitCurve]: A curve that controls the rate of particle emission over time. Defaults to [Curves.decelerate],
  ///   which gradually slows the emission rate.
  /// - [emitDuration]: The interval between each emission of particles. Defaults to 100 milliseconds.
  /// - [fadeInCurve]: A curve that controls how particles fade in, typically from transparent to fully visible.
  ///   Defaults to [Curves.linear] for a consistent fade-in.
  /// - [fadeOutCurve]: A curve that controls how particles fade out, typically from fully visible to transparent.
  ///   Defaults to [Curves.linear] for a consistent fade-out.
  /// - [maxAngle]: The maximum angle (in degrees) for particle trajectory, determining the directional spread of particles.
  ///   Defaults to `0`, meaning no spread.
  /// - [maxBeginScale]: The maximum initial scale of the particles, determining their size when first emitted. Defaults to `1`.
  /// - [maxEndScale]: The maximum final scale of the particles after scaling animations. Defaults to `-1`,
  ///   which indicates no scaling applied.
  /// - [maxFadeInThreshold]: The highest opacity value at which particles will complete fading in, controlling
  ///   the visibility of the particles when they fully appear. Defaults to `0`.
  /// - [maxFadeOutThreshold]: The highest opacity value at which particles start to fade out, controlling
  ///   when particles begin disappearing. Defaults to `1`.
  /// - [maxOriginOffset]: The maximum offset from the origin point for particle emission. Defaults to [Offset.zero],
  ///   meaning particles will emit from the specified origin without any additional offset.
  /// - [maxParticleLifespan]: The maximum time a particle can exist before disappearing. Defaults to 1 second.
  /// - [minAngle]: The minimum angle (in degrees) for particle trajectory, providing control over particle directionality.
  ///   Defaults to `0`.
  /// - [minBeginScale]: The minimum initial scale for particles, defining their smallest possible size when emitted. Defaults to `1`.
  /// - [minParticleLifespan]: The minimum time a particle can exist before disappearing. Defaults to 1 second.
  /// - [minEndScale]: The minimum final scale for particles, controlling the smallest size particles can reach after scaling. Defaults to `-1`,
  ///   meaning no scaling is applied.
  /// - [minFadeInThreshold]: The lowest opacity value at which particles will start to fade in, controlling
  ///   the visibility of particles as they begin to appear. Defaults to `0`.
  /// - [minFadeOutThreshold]: The lowest opacity value at which particles will start fading out, controlling
  ///   when particles begin to disappear. Defaults to `1`.
  /// - [minOriginOffset]: The minimum offset from the origin point for particle emission. Defaults to [Offset.zero].
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
  /// Assertions ensure the following conditions are met:
  /// - [minAngle] cannot be greater than [maxAngle].
  /// - [minBeginScale] cannot be greater than [maxBeginScale].
  /// - [minEndScale] cannot be greater than [maxEndScale].
  /// - [minFadeInThreshold] cannot be greater than [maxFadeInThreshold].
  /// - [minFadeOutThreshold] cannot be greater than [maxFadeOutThreshold].
  /// - [minOriginOffset] cannot be greater than [maxOriginOffset].
  /// - [minParticleLifespan] cannot be greater than [maxParticleLifespan].
  const EffectConfiguration({
    required this.particleConfiguration,
    this.emitCurve = Curves.decelerate,
    this.emitDuration = const Duration(milliseconds: 100),
    this.fadeInCurve = Curves.linear,
    this.fadeOutCurve = Curves.linear,
    this.maxAngle = 0,
    this.maxBeginScale = 1,
    this.maxEndScale = -1,
    this.maxFadeInThreshold = 0,
    this.maxFadeOutThreshold = 1,
    this.maxOriginOffset = Offset.zero,
    this.maxParticleLifespan = const Duration(seconds: 1),
    this.minAngle = 0,
    this.minBeginScale = 1,
    this.minParticleLifespan = const Duration(seconds: 1),
    this.minEndScale = -1,
    this.minFadeInThreshold = 0,
    this.minFadeOutThreshold = 1,
    this.minOriginOffset = Offset.zero,
    this.origin = const Offset(0.5, 0.5),
    this.particleCount = 0,
    this.particleLayer = ParticleLayer.background,
    this.particlesPerEmit = 1,
    this.scaleCurve = Curves.linear,
    this.startDelay = Duration.zero,
    this.tag,
    this.trail = const NoTrail(),
  })  : assert(
            minAngle <= maxAngle, 'Min angle can’t be greater than max angle'),
        assert(minBeginScale <= maxBeginScale,
            'Begin min scale can’t be greater than begin max scale'),
        assert(minEndScale <= maxEndScale,
            'End min scale can’t be greater than end max scale'),
        assert(
          minFadeInThreshold <= maxFadeInThreshold,
          'Min fadeIn threshold can’t be greater than max fadeIn threshold',
        ),
        assert(
          minFadeOutThreshold <= maxFadeOutThreshold,
          'Min fadeOut threshold can’t be greater than max fadeOut threshold',
        ),
        assert(
          minOriginOffset <= maxOriginOffset,
          'Min origin offset can’t be greater than max origin offset',
        ),
        assert(minParticleLifespan <= maxParticleLifespan,
            'Min lifespan can’t be greater than max lifespan');

  /// Curve to control the emission timing of particles. Default: [Curves.decelerate].
  final Curve emitCurve;

  /// Duration between particle emissions. Default: `100ms`.
  final Duration emitDuration;

  /// Curve to control particle fade-in animation. Default: [Curves.linear].
  final Curve fadeInCurve;

  /// Curve to control particle fade-out animation. Default: [Curves.linear].
  final Curve fadeOutCurve;

  /// Maximum angle in degrees for particle trajectory. Default: `0`.
  final double maxAngle;

  /// Maximum initial particle scale. Default: `1`.
  final double maxBeginScale;

  /// Maximum final particle scale. Default: `-1` (no scaling).
  final double maxEndScale;

  /// Maximum opacity threshold for particle fade-in. Default: `0`.
  final double maxFadeInThreshold;

  /// Maximum opacity threshold for particle fade-out. Default: `1`.
  final double maxFadeOutThreshold;

  /// Offset for the maximum origin point of particle emission. Default: [Offset.zero].
  final Offset maxOriginOffset;

  /// Maximum particle lifespan duration. Default: `1s`.
  final Duration maxParticleLifespan;

  /// Minimum angle in degrees for particle trajectory. Default: `0`.
  final double minAngle;

  /// Minimum initial particle scale. Default: `1`.
  final double minBeginScale;

  /// Minimum final particle scale. Default: `-1` (no scaling).
  final double minEndScale;

  /// Minimum opacity threshold for particle fade-in. Default: `0`.
  final double minFadeInThreshold;

  /// Minimum opacity threshold for particle fade-out. Default: `1`.
  final double minFadeOutThreshold;

  /// Offset for the minimum origin point of particle emission. Default: [Offset.zero].
  final Offset minOriginOffset;

  /// Minimum particle lifespan duration. Default: `1s`.
  final Duration minParticleLifespan;

  /// Origin point for particle emission, relative from the top-left of the container. Default: `Offset(0.5, 0.5)`.
  final Offset origin;

  /// Defines the configuration of the emitted particles.
  final T particleConfiguration;

  /// Total number of particles to emit. Default: `0` (infinite count).
  final int particleCount;

  /// The layer on which the particles should be rendered. Default: [ParticleLayer.background].
  final ParticleLayer particleLayer;

  /// Number of particles emitted per emission event. Default: `1`.
  final int particlesPerEmit;

  /// Curve to control particle scaling animation. Default: [Curves.linear].
  final Curve scaleCurve;

  /// Delay before starting the particle effect. Default: [Duration.zero].
  final Duration startDelay;

  /// Tag to identify the effect configuration, allowing for easy reference or management. Optional.
  final Tag? tag;

  /// The trail effect associated with emitted particles. Default: [NoTrail].
  final Trail trail;

  /// Helper method to generate a random angle within the range [minAngle] to [maxAngle].
  double randomAngle() {
    return random.nextDoubleRange(minAngle, maxAngle);
  }

  /// Helper method to generate a random duration within the range [minParticleLifespan] to [maxParticleLifespan].
  Duration randomDuration() {
    return Duration(
      milliseconds: random.nextIntRange(minParticleLifespan.inMilliseconds,
          maxParticleLifespan.inMilliseconds),
    );
  }

  /// Helper method to generate a random fade-in threshold
  /// within the range [minFadeInThreshold] to [maxFadeInThreshold].
  double randomFadeInThreshold() {
    return random.nextDoubleRange(minFadeInThreshold, maxFadeInThreshold);
  }

  /// Helper method to generate a random fade-out threshold
  /// within the range [minFadeOutThreshold] to [maxFadeOutThreshold].
  double randomFadeOutThreshold() {
    return random.nextDoubleRange(minFadeOutThreshold, maxFadeOutThreshold);
  }

  /// Helper method to generate a random origin offset within the range [minOriginOffset] to [maxOriginOffset].
  Offset randomOriginOffset() {
    return Offset(
      random.nextDoubleRange(minOriginOffset.dx, maxOriginOffset.dx),
      random.nextDoubleRange(minOriginOffset.dy, maxOriginOffset.dy),
    );
  }

  /// Helper method to determine if the particle should be rendered in the foreground based on [particleLayer].
  bool randomParticleForeground() {
    return switch (particleLayer) {
      ParticleLayer.background => false,
      ParticleLayer.foreground => true,
      ParticleLayer.random => random.nextBool(),
    };
  }

  /// Helper method to generate a random scale tween
  /// within the range [minBeginScale] to [maxBeginScale] and [minEndScale] to [maxEndScale].
  Tween<double> randomScaleRange() {
    final beginScale = random.nextDoubleRange(minBeginScale, maxBeginScale);
    final endScale = (minEndScale < 0 || maxEndScale < 0)
        ? beginScale
        : random.nextDoubleRange(minEndScale, maxEndScale);
    return Tween(begin: beginScale, end: endScale);
  }

  /// Creates a copy of this `EffectConfiguration` with the specified overrides.
  EffectConfiguration copyWith({
    Curve? distanceCurve,
    Curve? emitCurve,
    Duration? emitDuration,
    Curve? fadeInCurve,
    Curve? fadeOutCurve,
    double? maxAngle,
    double? maxBeginScale,
    Duration? maxParticleLifespan,
    double? maxDistance,
    double? maxEndScale,
    double? maxFadeInThreshold,
    double? maxFadeOutThreshold,
    Offset? maxOriginOffset,
    double? minAngle,
    double? minBeginScale,
    Duration? minParticleLifespan,
    double? minDistance,
    double? minEndScale,
    double? minFadeInThreshold,
    double? minFadeOutThreshold,
    Offset? minOriginOffset,
    Offset? origin,
    ParticleConfiguration? particleConfiguration,
    int? particleCount,
    ParticleLayer? particleLayer,
    int? particlesPerEmit,
    Curve? scaleCurve,
    Duration? startDelay,
    Trail? trail,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EffectConfiguration &&
          runtimeType == other.runtimeType &&
          emitCurve == other.emitCurve &&
          emitDuration == other.emitDuration &&
          fadeInCurve == other.fadeInCurve &&
          fadeOutCurve == other.fadeOutCurve &&
          maxAngle == other.maxAngle &&
          maxBeginScale == other.maxBeginScale &&
          maxEndScale == other.maxEndScale &&
          maxFadeInThreshold == other.maxFadeInThreshold &&
          maxFadeOutThreshold == other.maxFadeOutThreshold &&
          maxOriginOffset == other.maxOriginOffset &&
          maxParticleLifespan == other.maxParticleLifespan &&
          minAngle == other.minAngle &&
          minBeginScale == other.minBeginScale &&
          minEndScale == other.minEndScale &&
          minFadeInThreshold == other.minFadeInThreshold &&
          minFadeOutThreshold == other.minFadeOutThreshold &&
          minOriginOffset == other.minOriginOffset &&
          minParticleLifespan == other.minParticleLifespan &&
          origin == other.origin &&
          particleConfiguration == other.particleConfiguration &&
          particleCount == other.particleCount &&
          particleLayer == other.particleLayer &&
          particlesPerEmit == other.particlesPerEmit &&
          scaleCurve == other.scaleCurve &&
          startDelay == other.startDelay &&
          tag == other.tag &&
          trail == other.trail;

  @override
  int get hashCode =>
      emitCurve.hashCode ^
      emitDuration.hashCode ^
      fadeInCurve.hashCode ^
      fadeOutCurve.hashCode ^
      maxAngle.hashCode ^
      maxBeginScale.hashCode ^
      maxParticleLifespan.hashCode ^
      maxEndScale.hashCode ^
      maxFadeInThreshold.hashCode ^
      maxFadeOutThreshold.hashCode ^
      maxOriginOffset.hashCode ^
      minAngle.hashCode ^
      minBeginScale.hashCode ^
      minEndScale.hashCode ^
      minFadeInThreshold.hashCode ^
      minFadeOutThreshold.hashCode ^
      minOriginOffset.hashCode ^
      minParticleLifespan.hashCode ^
      origin.hashCode ^
      particleConfiguration.hashCode ^
      particleCount.hashCode ^
      particleLayer.hashCode ^
      particlesPerEmit.hashCode ^
      scaleCurve.hashCode ^
      startDelay.hashCode ^
      tag.hashCode ^
      trail.hashCode;
}

/// Extension on `EffectConfiguration` that provides a method to create an `Effect`
/// based on the specific type of `EffectConfiguration`.
extension EffectForConfiguration on EffectConfiguration<ParticleConfiguration> {
  /// Creates an `Effect` based on the specific type of `EffectConfiguration`.
  Effect<AnimatedParticle, EffectConfiguration> effect() => switch (this) {
        final DeterministicEffectConfiguration effectConfiguration =>
          DeterministicEffect(effectConfiguration),
        final RelativisticEffectConfiguration effectConfiguration =>
          RelativistEffect(effectConfiguration),
        _ => throw Exception('Unexpected configuration type'),
      } as Effect<AnimatedParticle, EffectConfiguration>;
}
