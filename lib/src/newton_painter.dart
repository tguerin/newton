import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:newton_particles/newton_particles.dart';

/// A custom painter that renders particle effects on a canvas in Newton.
///
/// The `NewtonPainter` class is responsible for painting the active particles
/// of specified effects onto the provided canvas. It uses a sprite sheet for
/// particle shapes and manages their transformations and rendering.
class NewtonPainter extends CustomPainter {
  /// Creates an instance of [NewtonPainter].
  ///
  /// - [blendMode]: Specifies how the particles should be blended on the canvas.
  /// - [effectsNotifier]: Manages the list of effects to be rendered.
  /// - [shapesSpriteSheet]: Provides the graphical shapes used in painting particles.
  ///
  /// The painter listens for changes in the [effectsNotifier] to update the canvas.
  NewtonPainter({
    required this.blendMode,
    required this.effectsNotifier,
    required this.shapesSpriteSheet,
  }) : super(repaint: effectsNotifier);

  /// The blend mode to apply for images.
  final BlendMode blendMode;

  /// The manager for the list of particle effects to be rendered.
  final EffectsNotifier effectsNotifier;

  /// The sprite sheet containing shapes used in rendering particles.
  final ui.Image shapesSpriteSheet;

  // Internal state for transformations
  final Set<ui.Image> _allImages = {};
  final Map<ui.Image, List<RSTransform>> _transformsPerImage = {};
  final Map<ui.Image, List<Rect>> _rectsPerImage = {};
  final Map<ui.Image, List<Color>> _colorsPerImage = {};

  /// Paints the particle effects onto the provided canvas.
  ///
  /// This method clears any previous transformations, computes the necessary
  /// transformations for each active particle, and then draws them on the canvas.
  @override
  void paint(Canvas canvas, Size size) {
    _clearTransformations();
    effectsNotifier.effects.expand((effect) {
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
        blendMode,
        null,
        Paint(),
      );
    }
  }

  /// Determines whether the painter should repaint.
  ///
  /// The painter will repaint if the effects managed by the [effectsNotifier]
  /// have changed.
  @override
  bool shouldRepaint(covariant NewtonPainter oldDelegate) {
    return oldDelegate.effectsNotifier != effectsNotifier;
  }

  /// Clears stored transformations for the current painting cycle.
  void _clearTransformations() {
    _transformsPerImage.clear();
    _rectsPerImage.clear();
    _colorsPerImage.clear();
  }

  /// Updates the transformation maps with the given particle's properties.
  ///
  /// This method adds transformations, rectangles, and colors for each particle
  /// to their respective maps for rendering.
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

/// Manages a collection of effects for use in particle animations.
///
/// The `EffectsNotifier` class extends `ChangeNotifier` to provide reactive updates
/// when the list of effects changes. It supports adding, removing, and cleaning up effects.
class EffectsNotifier with ChangeNotifier {
  /// Creates an instance of [EffectsNotifier].
  EffectsNotifier();

  /// The list of effects currently managed by the notifier.
  final effects = <Effect>[];

  /// Adds an effect to the list and notifies listeners.
  ///
  /// - [e]: The effect to add.
  void add<T extends AnimatedParticle>(Effect<T> e) {
    effects.add(e);
    notifyListeners();
  }

  /// Adds multiple effects to the list and notifies listeners.
  ///
  /// - [es]: The effects to add.
  void addAll<T extends AnimatedParticle>(Iterable<Effect<T>> es) {
    effects.addAll(es);
    notifyListeners();
  }

  /// Removes an effect from the list and notifies listeners.
  ///
  /// - [e]: The effect to remove.
  void remove<T extends AnimatedParticle>(Effect<T> e) {
    effects.remove(e);
    notifyListeners();
  }

  /// Cleans up effects that are no longer active and notifies listeners.
  void cleanDeadEffects() {
    effects.removeWhere((effect) => effect.state == EffectState.killed);
    notifyListeners();
  }

  /// Indicates whether the notifier has been disposed.
  bool _disposed = false;

  /// Disposes of the notifier, clearing all effects and preventing further notifications.
  @override
  void dispose() {
    _disposed = true;
    effects.clear();
    super.dispose();
  }

  /// Notifies listeners of changes, unless the notifier has been disposed.
  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
