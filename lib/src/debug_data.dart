import 'package:flutter/foundation.dart';
import 'package:newton_particles/newton_particles.dart';

/// Debug information about particle effects for monitoring and performance analysis.
///
/// This class provides real-time information about active particles in the Newton widget,
/// allowing developers to monitor performance and optimize particle counts.
@immutable
class NewtonDebugData {
  /// Creates a [NewtonDebugData] instance with the specified particle information.
  const NewtonDebugData({
    required this.effectData,
    required this.totalActiveParticles,
    required this.totalEffects,
  });

  /// Per-effect debug information.
  final List<EffectDebugData> effectData;

  /// Total number of active particles across all effects.
  final int totalActiveParticles;

  /// Total number of active effects.
  final int totalEffects;

  @override
  String toString() {
    return 'NewtonDebugData(totalActiveParticles: $totalActiveParticles, totalEffects: $totalEffects, effectData: $effectData)';
  }
}

/// Debug information about a single particle effect.
@immutable
class EffectDebugData {
  /// Creates an [EffectDebugData] instance with the specified effect information.
  const EffectDebugData({
    required this.configuration,
    required this.activeParticleCount,
    required this.totalEmittedCount,
    required this.state,
  });

  /// The effect configuration associated with this debug data.
  final EffectConfiguration configuration;

  /// Number of active particles in this effect for the current frame.
  final int activeParticleCount;

  /// Total number of particles that have been emitted by this effect.
  final int totalEmittedCount;

  /// Current state of the effect.
  final EffectState state;

  @override
  String toString() {
    return 'EffectDebugData(activeParticleCount: $activeParticleCount, totalEmittedCount: $totalEmittedCount, state: $state)';
  }
}
