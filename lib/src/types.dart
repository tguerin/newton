import 'package:newton_particles/newton_particles.dart';

/// Definition of function that returns an Effect to trigger once particle travel is over
typedef PostEffectBuilder = EffectConfiguration Function(
  Particle,
  Effect<AnimatedParticle, EffectConfiguration>,
);

/// Definition of function that returns a Shape
typedef ShapeBuilder = Shape Function();
