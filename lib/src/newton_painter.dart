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
    required List<Effect<AnimatedParticle, EffectConfiguration<ParticleConfiguration>>> effects,
    required ValueListenable<Duration> elapsedTimeNotifier,
    required ui.Image shapesSpriteSheet,
    bool foreground = false,
  })  : _foreground = foreground,
        _shapesSpriteSheet = shapesSpriteSheet,
        _elapsedTimeNotifier = elapsedTimeNotifier,
        _effects = effects,
        super(repaint: elapsedTimeNotifier);

  /// The list of particle effects to be rendered by this painter.
  ///
  /// Each effect contains a collection of particles with specific behaviors
  /// and transformations.
  final List<Effect> _effects;

  /// Notifies listeners about changes in the elapsed time.
  ///
  /// This is used to update the animation state of the particles.
  final ValueListenable<Duration> _elapsedTimeNotifier;

  final bool _foreground;

  /// The sprite sheet containing shapes used in rendering particles.
  ///
  /// This image provides the graphical assets for particle shapes.
  final ui.Image _shapesSpriteSheet;

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
    _clearTransformations();

    // Update effects and collect all active particles
    final allParticles = <AnimatedParticle>[];
    for (final effect in _effects) {
      effect
        ..surfaceSize = size
        ..forward(_elapsedTimeNotifier.value);
      allParticles.addAll(effect.activeParticles);
    }

    // Sort particles: zIndex first, then maintain relative order for tie-breaker
    // Optimized: removed indexed/map steps, using simpler sort comparator
    final sortedParticles = allParticles.toList()
      ..sort((ap1, ap2) {
        final zIndexComp = ap1.particle.zIndex.compareTo(ap2.particle.zIndex);
        if (zIndexComp != 0) return zIndexComp;
        // For equal zIndex, maintain relative order (stable sort)
        return 0;
      });

    // Viewport bounds with margin for particles that might extend beyond their position
    // (e.g., trails, large particles, rotation)
    const cullMargin = 100.0; // pixels
    final viewportBounds = Rect.fromLTWH(
      -cullMargin,
      -cullMargin,
      size.width + 2 * cullMargin,
      size.height + 2 * cullMargin,
    );

    // Paint particles in sorted order, culling off-screen particles
    for (final activeParticle in sortedParticles) {
      if (activeParticle.foreground == _foreground) {
        // Check if particle is within viewport before processing
        if (_isParticleVisible(activeParticle, viewportBounds)) {
          _updateTransformations(activeParticle);
          activeParticle.drawExtra(canvas);
        }
      }
    }

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
  /// The painter will repaint if the effects managed by the [_effects]
  /// have changed.
  @override
  bool shouldRepaint(covariant NewtonPainter oldDelegate) {
    return !listEquals(oldDelegate._effects, _effects);
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

  /// Checks if a particle is visible within the viewport bounds.
  ///
  /// This method performs viewport culling to skip particles that are
  /// outside the visible area, improving performance for large particle counts.
  ///
  /// - [particle]: The particle to check.
  /// - [viewportBounds]: The viewport bounds with margin for particles that extend beyond their position.
  ///
  /// Returns `true` if the particle is potentially visible, `false` if it's definitely off-screen.
  bool _isParticleVisible(AnimatedParticle particle, Rect viewportBounds) {
    final pos = particle.particle.position;
    final size = particle.particle.size;

    // Calculate bounding box for the particle
    // Account for rotation by using the diagonal of the size as the radius
    final maxRadius = (size.width + size.height) / 2;
    final particleBounds = Rect.fromCircle(
      center: pos,
      radius: maxRadius,
    );

    // Check if particle bounds intersect with viewport
    return viewportBounds.overlaps(particleBounds);
  }

  /// Updates the transformation maps with the given particle's properties.
  ///
  /// This method adds transformations, rectangles, and colors for each particle
  /// to their respective maps for rendering.
  void _updateTransformations(AnimatedParticle activeParticle) {
    final transformationData = activeParticle.particle.computeTransformation(_shapesSpriteSheet);
    if (transformationData == null) return;

    final blendedImage = _BlendedImage(
      image: transformationData.image,
      blendMode: transformationData.blendMode ?? ui.BlendMode.dstIn,
    );
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
      identical(this, other) ||
      other is _BlendedImage &&
          runtimeType == other.runtimeType &&
          image == other.image &&
          blendMode == other.blendMode;

  @override
  int get hashCode => image.hashCode ^ blendMode.hashCode;
}
