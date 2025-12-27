import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:newton_particles/newton_particles.dart';

/// Groups all animation timing-related properties for particle effects.
///
/// This class encapsulates properties related to when animations start and timing delays.
/// Note: Visual animation curves (scale, fade) are in [VisualProperties],
/// and trajectory angles are in [PhysicsProperties] or [DeterministicProperties].
@immutable
class AnimationProperties {
  /// Creates an [AnimationProperties] instance with the specified animation properties.
  const AnimationProperties({
    this.startDelay = Duration.zero,
  });

  /// Delay before the particle effect starts after initiation.
  final Duration startDelay;

  /// Creates a copy of this [AnimationProperties] with the given fields replaced with new values.
  AnimationProperties copyWith({
    Duration? startDelay,
  }) {
    return AnimationProperties(
      startDelay: startDelay ?? this.startDelay,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimationProperties && runtimeType == other.runtimeType && startDelay == other.startDelay;

  @override
  int get hashCode => startDelay.hashCode;

  @override
  String toString() => 'AnimationProperties(startDelay: $startDelay)';
}
