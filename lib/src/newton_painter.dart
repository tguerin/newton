import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:newton_particles/newton_particles.dart';

/// A custom painter that renders particle effects on a canvas in Newton.
///
/// The `NewtonPainter` class extends `CustomPainter` and is responsible for painting
/// the active particles of the specified effects onto the provided canvas.
class NewtonPainter extends CustomPainter {
  /// The list of particle effects to be rendered on the canvas.
  final EffectManager effectsManager;

  /// The sprite sheet that contains default shapes
  final ui.Image shapesSpriteSheet;

  final BlendMode blendMode;

  // Internal state for transformations
  final Set<ui.Image> _allImages = {};
  final Map<ui.Image, List<RSTransform>> _transformsPerImage = {};
  final Map<ui.Image, List<Rect>> _rectsPerImage = {};
  final Map<ui.Image, List<Color>> _colorsPerImage = {};

  NewtonPainter({required this.effectsManager, required this.shapesSpriteSheet, required this.blendMode}) : super(repaint: effectsManager);

  @override
  void paint(Canvas canvas, Size size) {
    _clearTransformations();
    effectsManager.effects.expand((effect) => effect.activeParticles).forEach(
      (activeParticle) {
        _updateTransformations(activeParticle);
        activeParticle.drawExtra(canvas);
      },
    );
    for (var image in _allImages) {
      canvas.drawAtlas(image, _transformsPerImage[image] ?? [], _rectsPerImage[image] ?? [], _colorsPerImage[image] ?? [], blendMode,
          null, Paint());
    }
  }

  @override
  bool shouldRepaint(covariant NewtonPainter oldDelegate) {
    return oldDelegate.effectsManager != effectsManager; 
  }

  void _clearTransformations() {
    _transformsPerImage.clear();
    _rectsPerImage.clear();
    _colorsPerImage.clear();
  }

  void _updateTransformations(AnimatedParticle activeParticle) {
    final (image, rect, transform, color) = activeParticle.particle.computeTransformation(shapesSpriteSheet);
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

class EffectManager with ChangeNotifier {
  List<Effect> effects = [];

  EffectManager();

  void add(Effect e) {
    effects.add(e);
    notifyListeners();
  }

  void addAll(Iterable<Effect> es) {
    effects.addAll(es);
    notifyListeners();
  }


  void remove(Effect e) {
    effects.remove(e);
    notifyListeners();
  }

  void cleanDeadEffects() {
    effects.removeWhere((effect) => effect.state == EffectState.killed);
    notifyListeners();
  }

  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    effects.clear();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
