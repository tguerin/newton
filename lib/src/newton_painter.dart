import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:newton_particles/newton_particles.dart';

/// A custom painter that renders particle effects on a canvas in Newton.
///
/// The `NewtonPainter` class extends `CustomPainter` and is responsible for painting
/// the active particles of the specified effects onto the provided canvas.
class NewtonPainter extends CustomPainter {
  /// Creates an instance of [NewtonPainter].
  ///
  /// The [effects] parameter specifies the list of effects to be rendered,
  /// and the [shapesSpriteSheet] provides the graphical shapes to be drawn.
  ///
  /// - [effects]: A list of effects that define how the painter will render.
  /// - [shapesSpriteSheet]: The sprite sheet containing shapes to be used in the painting.
  NewtonPainter({
    required this.effects,
    required this.shapesSpriteSheet,
  });

  /// The list of particle effects to be rendered on the canvas.
  final List<Effect> effects;

  /// The sprite sheet that contains default shapes
  final ui.Image shapesSpriteSheet;

  // Internal state for transformations
  final Set<ui.Image> _allImages = {};
  final Map<ui.Image, List<RSTransform>> _transformsPerImage = {};
  final Map<ui.Image, List<Rect>> _rectsPerImage = {};
  final Map<ui.Image, List<Color>> _colorsPerImage = {};

  @override
  void paint(Canvas canvas, Size size) {
    _clearTransformations();
    effects.expand((effect) {
      effect.surfaceSize = size;
      return effect.activeParticles;
    }).forEach(
      (activeParticle) {
        _updateTransformations(activeParticle);
        activeParticle.drawExtra(canvas);
      },
    );
    for (final image in _allImages) {
      canvas.drawAtlas(
        image,
        _transformsPerImage[image] ?? [],
        _rectsPerImage[image] ?? [],
        _colorsPerImage[image] ?? [],
        BlendMode.dstIn,
        null,
        Paint(),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return effects.isNotEmpty;
  }

  void _clearTransformations() {
    _transformsPerImage.clear();
    _rectsPerImage.clear();
    _colorsPerImage.clear();
  }

  void _updateTransformations(AnimatedParticle activeParticle) {
    final (image, rect, transform, color) =
        activeParticle.particle.computeTransformation(shapesSpriteSheet);
    _allImages.add(image);
    _rectsPerImage.update(
      image,
      (rects) => rects..add(rect),
      ifAbsent: () => [rect],
    );
    _transformsPerImage.update(
      image,
      (transforms) => transforms..add(transform),
      ifAbsent: () => [transform],
    );
    _colorsPerImage.update(
      image,
      (colors) => colors..add(color),
      ifAbsent: () => [color],
    );
  }
}
