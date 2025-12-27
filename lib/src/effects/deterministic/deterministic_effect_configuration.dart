import 'package:flutter/widgets.dart';
import 'package:newton_particles/newton_particles.dart';

/// The `DeterministicEffectConfiguration` class defines the configuration settings for a deterministic particle effect.
///
/// This class extends [EffectConfiguration] and introduces additional properties to control the travel distance of particles
/// and to specify a custom path builder for particle motion. It allows for precise control over particle behavior in a deterministic effect.
@immutable
class DeterministicEffectConfiguration extends EffectConfiguration {
  /// Creates a [DeterministicEffectConfiguration] with grouped properties.
  ///
  /// This constructor accepts [DeterministicProperties] to group all deterministic-related ranges together,
  /// and optionally [VisualProperties] to group visual-related ranges (scale, fade thresholds).
  /// This provides better organization and validation.
  DeterministicEffectConfiguration({
    required super.particleConfiguration,
    super.emissionProperties = const EmissionProperties(),
    this.deterministicProperties = const DeterministicProperties(),
    this.visualProperties = const VisualProperties(),
    this.animationProperties = const AnimationProperties(),
    this.layerProperties = const LayerProperties(),
    this.customPathBuilder,
    this.distanceCurve = Curves.linear,
  })  : minDistance = deterministicProperties.distance.min,
        maxDistance = deterministicProperties.distance.max,
        // Map visual properties (single values only)
        fadeInCurve = visualProperties.fadeInCurve,
        fadeOutCurve = visualProperties.fadeOutCurve,
        scaleCurve = visualProperties.scaleCurve,
        // Map animation properties
        startDelay = animationProperties.startDelay,
        // Map layer properties
        particleLayer = layerProperties.particleLayer,
        trail = layerProperties.trail;

  /// The deterministic properties (grouped ranges for distance and angle).
  final DeterministicProperties deterministicProperties;

  /// The visual properties (grouped ranges for scale and fade thresholds).
  final VisualProperties visualProperties;

  /// The animation properties (start delay).
  final AnimationProperties animationProperties;

  /// The layer properties (particle layer and trail).
  final LayerProperties layerProperties;

  /// Curve to control particle travel distance. Default: [Curves.linear].
  final Curve distanceCurve;

  /// Maximum distance traveled by particles.
  final double maxDistance;

  /// Minimum distance traveled by particles.
  final double minDistance;

  // Visual properties mapped to EffectConfiguration fields (single values only)
  @override
  final Curve fadeInCurve;

  @override
  final Curve fadeOutCurve;

  @override
  final Curve scaleCurve;

  // Animation properties mapped to EffectConfiguration fields
  @override
  final Duration startDelay;

  // Layer properties mapped to EffectConfiguration fields
  @override
  final ParticleLayer particleLayer;

  @override
  final Trail trail;

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
    DeterministicProperties? deterministicProperties,
    VisualProperties? visualProperties,
    EmissionProperties? emissionProperties,
    AnimationProperties? animationProperties,
    LayerProperties? layerProperties,
    DeterministicPathTransformation Function(
      Effect<DeterministicAnimatedParticle, DeterministicEffectConfiguration>,
      DeterministicAnimatedParticle,
    )? customPathBuilder,
    Curve? distanceCurve,
    ParticleConfiguration? particleConfiguration,
  }) {
    return DeterministicEffectConfiguration(
      deterministicProperties: deterministicProperties ?? this.deterministicProperties,
      visualProperties: visualProperties ?? this.visualProperties,
      emissionProperties: emissionProperties ?? super.emissionProperties,
      animationProperties: animationProperties ?? this.animationProperties,
      layerProperties: layerProperties ?? this.layerProperties,
      customPathBuilder: customPathBuilder ?? this.customPathBuilder,
      distanceCurve: distanceCurve ?? this.distanceCurve,
      particleConfiguration: particleConfiguration ?? this.particleConfiguration,
    );
  }

  @override
  double randomAngle() {
    return deterministicProperties.randomAngle();
  }

  // randomDuration is now implemented in EffectConfiguration base class

  @override
  double randomFadeInThreshold() {
    return visualProperties.randomFadeInThreshold();
  }

  @override
  double randomFadeOutThreshold() {
    return visualProperties.randomFadeOutThreshold();
  }

  // randomOriginOffset is now implemented in EffectConfiguration base class

  @override
  Tween<double> randomScaleRange() {
    return visualProperties.randomScaleRange();
  }

  /// Generates a random distance for a particle within the specified min and max range.
  ///
  /// This method is used to determine how far a particle should travel, providing
  /// variation in particle motion within the effect.
  double randomDistance() {
    return deterministicProperties.randomDistance();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is DeterministicEffectConfiguration &&
          runtimeType == other.runtimeType &&
          deterministicProperties == other.deterministicProperties &&
          visualProperties == other.visualProperties &&
          animationProperties == other.animationProperties &&
          layerProperties == other.layerProperties &&
          distanceCurve == other.distanceCurve &&
          customPathBuilder == other.customPathBuilder;

  @override
  int get hashCode =>
      super.hashCode ^
      deterministicProperties.hashCode ^
      visualProperties.hashCode ^
      animationProperties.hashCode ^
      layerProperties.hashCode ^
      distanceCurve.hashCode ^
      customPathBuilder.hashCode;
}
