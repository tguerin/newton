import 'package:flutter/foundation.dart';
import 'package:newton_particles/newton_particles.dart';

/// Groups all layer-related properties for particle effects.
///
/// This class encapsulates properties related to rendering layer and trail effects.
@immutable
class LayerProperties {
  /// Creates a [LayerProperties] instance with the specified layer properties.
  const LayerProperties({
    this.particleLayer = ParticleLayer.background,
    this.trail = const NoTrail(),
  });

  /// Visual layer on which particles are rendered.
  final ParticleLayer particleLayer;

  /// Trail effect applied to particles as they move.
  final Trail trail;

  /// Creates a copy of this [LayerProperties] with the given fields replaced with new values.
  LayerProperties copyWith({
    ParticleLayer? particleLayer,
    Trail? trail,
  }) {
    return LayerProperties(
      particleLayer: particleLayer ?? this.particleLayer,
      trail: trail ?? this.trail,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayerProperties &&
          runtimeType == other.runtimeType &&
          particleLayer == other.particleLayer &&
          trail == other.trail;

  @override
  int get hashCode => particleLayer.hashCode ^ trail.hashCode;

  @override
  String toString() => 'LayerProperties(particleLayer: $particleLayer, trail: $trail)';
}
