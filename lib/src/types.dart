import 'dart:ui';

import 'package:newton_particles/newton_particles.dart';

/// Definition of function that returns an Effect to trigger once particle travel is over
typedef PostEffectBuilder = EffectConfiguration Function(
  Particle particle,
  Effect<AnimatedParticle, EffectConfiguration> effect,
);

/// Definition of function that returns a Shape
typedef ShapeBuilder = Shape Function(Offset position);

/// Definition of function that returns a z-index value for particles
typedef ZIndexBuilder = int Function(Offset position);
