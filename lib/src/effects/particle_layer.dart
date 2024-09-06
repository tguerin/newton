/// The `ParticleLayer` enum represents different layers in which particles can be rendered
/// within a particle system, allowing for the creation of depth and visual separation.
///
/// By assigning particles to different layers, you can control whether they appear in the
/// foreground, background, or are randomly assigned to either layer. This is useful for
/// creating complex visual effects with multiple layers of particle activity.
enum ParticleLayer {
  /// Particles are randomly assigned to either the foreground or background layer.
  random,

  /// Particles are rendered in the foreground layer, appearing above other content.
  foreground,

  /// Particles are rendered in the background layer, appearing behind other content.
  background,
}
