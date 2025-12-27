import 'package:flutter/widgets.dart';
import 'package:newton_particles/src/utils/range.dart';

/// Groups all visual-related properties for particle effects.
///
/// This class encapsulates all visual appearance properties including scale ranges,
/// fade thresholds, and the curves that control how these visual properties animate.
/// Can be shared between both physics and deterministic effect types.
///
/// Example usage:
///
/// ```dart
/// final properties = VisualProperties(
///   beginScale: Range.between(0.5, 1.0),
///   endScale: Range.between(0.0, 0.5),
///   fadeInThreshold: Range.between(0.0, 0.2),
///   fadeOutThreshold: Range.between(0.8, 1.0),
///   scaleCurve: Curves.easeInOut,
///   fadeInCurve: Curves.easeIn,
///   fadeOutCurve: Curves.easeOut,
/// );
/// ```
@immutable
class VisualProperties {
  /// Creates a [VisualProperties] instance with the specified visual properties.
  ///
  /// All ranges must have valid min/max values, and individual properties must
  /// satisfy their constraints:
  /// - Scale: > 0.0
  /// - Fade thresholds: 0.0 to 1.0
  const VisualProperties({
    this.beginScale = const Range.single(1),
    this.endScale = const Range.single(-1),
    this.fadeInThreshold = const Range.single(0),
    this.fadeOutThreshold = const Range.single(1),
    this.scaleCurve = Curves.linear,
    this.fadeInCurve = Curves.linear,
    this.fadeOutCurve = Curves.linear,
  });

  /// The begin scale range for particles.
  final Range<double> beginScale;

  /// The end scale range for particles.
  /// -1 indicates no scaling.
  final Range<double> endScale;

  /// The fade in threshold range for particles.
  final Range<double> fadeInThreshold;

  /// The fade out threshold range for particles.
  final Range<double> fadeOutThreshold;

  /// The curve that controls how particle scale changes over time.
  final Curve scaleCurve;

  /// The curve that controls how particles fade in.
  final Curve fadeInCurve;

  /// The curve that controls how particles fade out.
  final Curve fadeOutCurve;

  /// Generates a random begin scale within the specified range.
  double randomBeginScale() {
    return beginScale.random();
  }

  /// Generates a random end scale within the specified range.
  ///
  /// **Special case for -1 values:**
  /// - If both min and max are -1, returns -1 (indicating no scaling should be applied)
  /// - If only min is -1, randomly chooses between -1 (no scaling) or a value in the positive range [0, max]
  /// - Otherwise, returns a random value within the normal range [min, max]
  ///
  /// The -1 value is a special sentinel that indicates the particle should maintain its initial scale
  /// rather than scaling to a different size.
  double randomEndScale() {
    if (endScale.min == -1 && endScale.max == -1) {
      return -1;
    }
    // If min is -1, we need to handle it specially
    if (endScale.min == -1) {
      // Randomly choose between -1 and a value in the positive range
      const range = Range<double>.between(0, 1);
      if (range.random() < 0.5) {
        return -1;
      }
      return Range<double>.between(0, endScale.max).random();
    }
    return endScale.random();
  }

  /// Generates a random fade in threshold within the specified range.
  double randomFadeInThreshold() {
    return fadeInThreshold.random();
  }

  /// Generates a random fade out threshold within the specified range.
  double randomFadeOutThreshold() {
    return fadeOutThreshold.random();
  }

  /// Generates a random scale tween within the specified begin and end scale ranges.
  ///
  /// If the end scale range allows -1 values (indicating no scaling), this method will
  /// handle that special case appropriately. Otherwise, it generates a random begin scale
  /// and end scale within their respective ranges.
  Tween<double> randomScaleRange() {
    final beginScale = randomBeginScale();
    final endScale = randomEndScale();
    // If endScale is -1, use beginScale (no scaling)
    final effectiveEndScale = endScale < 0 ? beginScale : endScale;
    return Tween(begin: beginScale, end: effectiveEndScale);
  }

  /// Creates a copy of this [VisualProperties] with the given fields replaced with new values.
  VisualProperties copyWith({
    Range<double>? beginScale,
    Range<double>? endScale,
    Range<double>? fadeInThreshold,
    Range<double>? fadeOutThreshold,
    Curve? scaleCurve,
    Curve? fadeInCurve,
    Curve? fadeOutCurve,
  }) {
    return VisualProperties(
      beginScale: beginScale ?? this.beginScale,
      endScale: endScale ?? this.endScale,
      fadeInThreshold: fadeInThreshold ?? this.fadeInThreshold,
      fadeOutThreshold: fadeOutThreshold ?? this.fadeOutThreshold,
      scaleCurve: scaleCurve ?? this.scaleCurve,
      fadeInCurve: fadeInCurve ?? this.fadeInCurve,
      fadeOutCurve: fadeOutCurve ?? this.fadeOutCurve,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisualProperties &&
          runtimeType == other.runtimeType &&
          beginScale == other.beginScale &&
          endScale == other.endScale &&
          fadeInThreshold == other.fadeInThreshold &&
          fadeOutThreshold == other.fadeOutThreshold &&
          scaleCurve == other.scaleCurve &&
          fadeInCurve == other.fadeInCurve &&
          fadeOutCurve == other.fadeOutCurve;

  @override
  int get hashCode =>
      beginScale.hashCode ^
      endScale.hashCode ^
      fadeInThreshold.hashCode ^
      fadeOutThreshold.hashCode ^
      scaleCurve.hashCode ^
      fadeInCurve.hashCode ^
      fadeOutCurve.hashCode;

  @override
  String toString() =>
      'VisualProperties(beginScale: $beginScale, endScale: $endScale, fadeInThreshold: $fadeInThreshold, fadeOutThreshold: $fadeOutThreshold, scaleCurve: $scaleCurve, fadeInCurve: $fadeInCurve, fadeOutCurve: $fadeOutCurve)';
}
