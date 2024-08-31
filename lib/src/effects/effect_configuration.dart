import 'package:flutter/widgets.dart';
import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/effects/deterministic/deterministic_effect.dart';
import 'package:newton_particles/src/effects/relativistic/relativistic_effect.dart';

extension type Tag(String value) {}

/// Configuration class for defining particle emission properties in Newton effects.
///
/// The `EffectConfiguration` class provides customizable properties to control particle emission
/// in Newton effects. It allows you to fine-tune various parameters, such as emission duration,
/// particle count per emission, emission curve, origin, distance, duration, scale, and fade animation.
@immutable
abstract class EffectConfiguration<T extends ParticleConfiguration> {
  /// Creates an instance of `EffectConfiguration` with the specified parameters.
  ///
  /// All parameters have default values that can be overridden during object creation.
  const EffectConfiguration({
    required this.particleConfiguration,
    this.emitCurve = Curves.decelerate,
    this.emitDuration = const Duration(milliseconds: 100),
    this.fadeInCurve = Curves.linear,
    this.fadeOutCurve = Curves.linear,
    this.foreground = false,
    this.maxAngle = 0,
    this.maxBeginScale = 1,
    this.maxDuration = const Duration(seconds: 1),
    this.maxEndScale = -1,
    this.maxFadeInThreshold = 0,
    this.maxFadeOutThreshold = 1,
    this.maxOriginOffset = Offset.zero,
    this.minAngle = 0,
    this.minBeginScale = 1,
    this.minDuration = const Duration(seconds: 1),
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
          minAngle <= maxAngle,
          'Min angle can’t be greater than max angle',
        ),
        assert(
          minBeginScale <= maxBeginScale,
          'Begin min scale can’t be greater than begin max scale',
        ),
        assert(
          minDuration <= maxDuration,
          'Min duration can’t be greater than max duration',
        ),
        assert(
          minEndScale <= maxEndScale,
          'End min scale can’t be greater than end max scale',
        ),
        assert(
          minFadeInThreshold <= maxFadeInThreshold,
          'Min fadeIn limit can’t be greater than end max fadeIn threshold',
        ),
        assert(
          minFadeOutThreshold <= maxFadeOutThreshold,
          'Min fadeOut threshold can’t be greater than end max fadeOut threshold',
        );

  /// Curve to control the emission timing. Default: [Curves.decelerate].
  final Curve emitCurve;

  /// Duration between particle emissions. Default: `100ms`.
  final Duration emitDuration;

  /// Curve to control particle fade-in animation. Default: [Curves.linear].
  final Curve fadeInCurve;

  /// Curve to control particle fade-out animation. Default: [Curves.linear].
  final Curve fadeOutCurve;

  /// Indicates whether the effect should be played in the foreground. Default: `false`.
  final bool foreground;

  /// Maximum angle in degrees for particle trajectory. Default: `0`.
  final double maxAngle;

  /// Maximum initial particle scale. Default: `1`.
  final double maxBeginScale;

  /// Maximum particle animation duration. Default: `1s`.
  final Duration maxDuration;

  /// Maximum final particle scale. Default: `-1`.
  final double maxEndScale;

  /// Maximum opacity threshold for particle fade-in. Default: `0`.
  final double maxFadeInThreshold;

  /// Maximum opacity threshold for particle fade-out. Default: `1`.
  final double maxFadeOutThreshold;

  /// Offset for the maximum origin point of particle emission. Default: [Offset.zero].
  final Offset maxOriginOffset;

  /// Minimum angle in degrees for particle trajectory. Default: `0`.
  final double minAngle;

  /// Minimum initial particle scale. Default: `1`.
  final double minBeginScale;

  /// Minimum particle animation duration. Default: `1s`.
  final Duration minDuration;

  /// Minimum opacity threshold for particle fade-in. Default: `0`.
  final double minFadeInThreshold;

  /// Minimum opacity threshold for particle fade-out. Default: `1`.
  final double minFadeOutThreshold;

  /// Minimum final particle scale. Default: `-1`.
  final double minEndScale;

  /// Offset for the minimum origin point of particle emission. Default: [Offset.zero].
  final Offset minOriginOffset;

  /// Origin point for particle emission, relative from the top-left of the container. Default: `Offset(0.5, 0.5)`.
  final Offset origin;

  /// Define the look and feel of emitted particle
  final T particleConfiguration;

  /// Total number of particles to emit. Default: `0` means infinite count.
  final int particleCount;

  /// On which layer the particle should be rendered. Default: background
  final ParticleLayer particleLayer;

  /// Number of particles emitted per emission. Default: `1`.
  final int particlesPerEmit;

  /// Curve to control particle scaling animation. Default: [Curves.linear].
  final Curve scaleCurve;

  /// Delay before starting the effect. Default: [Duration.zero].
  final Duration startDelay;

  /// Tag to identify the effect configuration
  final Tag? tag;

  /// The trail effect associated with emitted particles. Default: [NoTrail].
  final Trail trail;

  /// Helper method to generate a random duration within the range [minAngle] - [maxAngle].
  double randomAngle() {
    return random.nextDoubleRange(
      minAngle,
      maxAngle,
    );
  }

  /// Helper method to generate a random duration within the range [minDuration] - [maxDuration].
  Duration randomDuration() {
    return Duration(
      milliseconds: random.nextIntRange(
        minDuration.inMilliseconds,
        maxDuration.inMilliseconds,
      ),
    );
  }

  /// Helper method to generate a random origin offset within the range [minOriginOffset] - [maxOriginOffset].
  Offset randomOriginOffset() {
    return Offset(
      random.nextDoubleRange(minOriginOffset.dx, maxOriginOffset.dx),
      random.nextDoubleRange(minOriginOffset.dy, maxOriginOffset.dy),
    );
  }

  /// Helper method to generate a random scale tween
  /// within the range [minBeginScale] - [maxBeginScale] and [minEndScale] - [maxEndScale].
  Tween<double> randomScaleRange() {
    final beginScale = random.nextDoubleRange(
      minBeginScale,
      maxBeginScale,
    );
    final endScale = (minEndScale < 0 || maxEndScale < 0)
        ? beginScale
        : random.nextDoubleRange(
            minEndScale,
            maxEndScale,
          );
    return Tween(begin: beginScale, end: endScale);
  }

  bool randomParticleForeground() {
    return switch (particleLayer) {
      ParticleLayer.background => false,
      ParticleLayer.foreground => true,
      ParticleLayer.random => random.nextBool(),
    };
  }

  /// Helper method to generate a random fade-out threshold
  /// within the range [minFadeOutThreshold] - [maxFadeOutThreshold].
  double randomFadeOutThreshold() {
    return random.nextDoubleRange(
      minFadeOutThreshold,
      maxFadeOutThreshold,
    );
  }

  /// Helper method to generate a random fade-in limit
  /// within the range [EffectConfiguration.minFadeInThreshold] - [EffectConfiguration.maxFadeInThreshold].
  double randomFadeInThreshold() {
    return random.nextDoubleRange(
      minFadeInThreshold,
      maxFadeInThreshold,
    );
  }

  EffectConfiguration copyWith({
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
          foreground == other.foreground &&
          maxAngle == other.maxAngle &&
          maxBeginScale == other.maxBeginScale &&
          maxDuration == other.maxDuration &&
          maxEndScale == other.maxEndScale &&
          maxFadeInThreshold == other.maxFadeInThreshold &&
          maxFadeOutThreshold == other.maxFadeOutThreshold &&
          maxOriginOffset == other.maxOriginOffset &&
          minAngle == other.minAngle &&
          minBeginScale == other.minBeginScale &&
          minDuration == other.minDuration &&
          minFadeInThreshold == other.minFadeInThreshold &&
          minFadeOutThreshold == other.minFadeOutThreshold &&
          minEndScale == other.minEndScale &&
          minOriginOffset == other.minOriginOffset &&
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
      foreground.hashCode ^
      maxAngle.hashCode ^
      maxBeginScale.hashCode ^
      maxDuration.hashCode ^
      maxEndScale.hashCode ^
      maxFadeInThreshold.hashCode ^
      maxFadeOutThreshold.hashCode ^
      maxOriginOffset.hashCode ^
      minAngle.hashCode ^
      minBeginScale.hashCode ^
      minDuration.hashCode ^
      minFadeInThreshold.hashCode ^
      minFadeOutThreshold.hashCode ^
      minEndScale.hashCode ^
      minOriginOffset.hashCode ^
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

extension EffectForConfiguration on EffectConfiguration<ParticleConfiguration> {
  Effect<AnimatedParticle, EffectConfiguration> effect() => switch (this) {
        final DeterministicEffectConfiguration effectConfiguration => DeterministicEffect(effectConfiguration),
        final RelativisticEffectConfiguration effectConfiguration => RelativistEffect(effectConfiguration),
        _ => throw Exception('unexpected configuration type'),
      } as Effect<AnimatedParticle, EffectConfiguration>;
}
