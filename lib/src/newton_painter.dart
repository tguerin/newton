import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:newton_particles/newton_particles.dart';

/// A custom painter that renders particle effects on a canvas in Newton.
///
/// The `NewtonPainter` class is responsible for painting active particles
/// from specified effects onto the provided canvas. It utilizes a sprite sheet
/// for particle shapes and manages their transformations and rendering.
class NewtonPainter extends CustomPainter {
  /// Creates an instance of [NewtonPainter].
  ///
  /// - [effects]: A list of particle effects to be rendered.
  /// - [elapsedTimeNotifier]: A [ValueListenable] that notifies when the elapsed time changes,
  ///   which is used to update the animations.
  /// - [shapesSpriteSheet]: Provides the graphical shapes used in painting particles.
  ///
  /// The painter listens for changes in the [elapsedTimeNotifier] to update the canvas.
  NewtonPainter({
    required this.effects,
    required this.elapsedTimeNotifier,
    required this.shapesSpriteSheet,
  }) : super(repaint: elapsedTimeNotifier);

  /// The list of particle effects to be rendered by this painter.
  ///
  /// Each effect contains a collection of particles with specific behaviors
  /// and transformations.
  final List<Effect> effects;

  /// Notifies listeners about changes in the elapsed time.
  ///
  /// This is used to update the animation state of the particles.
  final ValueListenable<Duration> elapsedTimeNotifier;

  /// The sprite sheet containing shapes used in rendering particles.
  ///
  /// This image provides the graphical assets for particle shapes.
  final ui.Image shapesSpriteSheet;

  // Internal state for managing transformations and rendering.
  final Set<_BlendedImage> _allBlendedImages = {};
  final Map<_BlendedImage, List<RSTransform>> _transformsPerImage = {};
  final Map<_BlendedImage, List<Rect>> _rectsPerImage = {};
  final Map<_BlendedImage, List<Color>> _colorsPerImage = {};

  /// Paints the particle effects onto the provided canvas.
  ///
  /// This method clears any previous transformations, computes the necessary
  /// transformations for each active particle, and then draws them on the canvas.
  @override
  void paint(Canvas canvas, Size size) {
    _clearTransformations(); // Clear previous transformations.

    // Iterate over each effect and update their active particles.
    effects.expand((effect) {
      effect
        ..surfaceSize = size
        ..forward(elapsedTimeNotifier.value); // Update the effect state.
      return effect.activeParticles;
    }).forEach((activeParticle) {
      _updateTransformations(activeParticle); // Compute transformations.
      activeParticle.drawExtra(canvas); // Draw additional effects.
    });

    // Draw all particles using drawAtlas for efficiency.
    for (final blendedImage in _allBlendedImages) {
      canvas.drawAtlas(
        blendedImage.image,
        _transformsPerImage[blendedImage] ?? [],
        _rectsPerImage[blendedImage] ?? [],
        _colorsPerImage[blendedImage],
        blendedImage.blendMode,
        null,
        Paint(),
      );
    }
  }

  /// Determines whether the painter should repaint.
  ///
  /// The painter will repaint if the effects managed by the [effects]
  /// have changed.
  @override
  bool shouldRepaint(covariant NewtonPainter oldDelegate) {
    return !listEquals(oldDelegate.effects, effects);
  }

  /// Clears stored transformations for the current painting cycle.
  ///
  /// This ensures that old transformations do not interfere with
  /// the current rendering of particle effects.
  void _clearTransformations() {
    _transformsPerImage.clear();
    _rectsPerImage.clear();
    _colorsPerImage.clear();
    _allBlendedImages.clear();
  }

  /// Updates the transformation maps with the given particle's properties.
  ///
  /// This method adds transformations, rectangles, and colors for each particle
  /// to their respective maps for rendering.
  void _updateTransformations(AnimatedParticle activeParticle) {
    final transformationData = activeParticle.particle.computeTransformation(shapesSpriteSheet);
    if (transformationData == null) return; // Skip if no transformation data.

    final blendedImage = _BlendedImage(
      image: transformationData.image,
      blendMode: transformationData.blendMode ?? ui.BlendMode.dstIn,
    );
    // Add the image and its transformations to the respective maps.
    _allBlendedImages.add(blendedImage);
    _rectsPerImage.update(
      blendedImage,
      (rects) => rects..add(transformationData.rect),
      ifAbsent: () => [transformationData.rect],
    );
    _transformsPerImage.update(
      blendedImage,
      (transforms) => transforms..add(transformationData.transform),
      ifAbsent: () => [transformationData.transform],
    );
    _colorsPerImage.update(
      blendedImage,
      (colors) => colors..add(transformationData.color),
      ifAbsent: () => [transformationData.color],
    );
  }
}

@immutable
class _BlendedImage {
  const _BlendedImage({required this.image, required this.blendMode});

  final ui.Image image;
  final ui.BlendMode? blendMode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is _BlendedImage && runtimeType == other.runtimeType && image == other.image;

  @override
  int get hashCode => image.hashCode;
}
