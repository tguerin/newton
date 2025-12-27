import 'dart:math';
import 'dart:ui';

import 'package:forge2d/forge2d.dart' as f2d;
import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/effects/relativistic/newton_world.dart';
import 'package:newton_particles/src/utils/sdf_physics.dart';

const _particleCategory = 0x0001;
const _edgeCategory = 0x0002;
const int _edgeMask = _particleCategory;

/// The `ForgeNewtonWorld` class implements the `NewtonWorld` interface using the Forge2D
/// physics engine. It manages the simulation of physics particles within a 2D world,
/// handling their addition, removal, and updates based on the physical properties defined.

class ForgeNewtonWorld implements NewtonWorld {
  /// Creates a new `ForgeNewtonWorld` with the specified gravity.
  ///
  /// - [gravity]: The gravity vector applied to the world, typically defined as `Gravity(dx, dy)`.
  ForgeNewtonWorld(Gravity gravity, SolidEdges hardEdges) {
    final world = f2d.World(f2d.Vector2(gravity.dx, gravity.dy));
    _world = world;
    _boundaries = _Boundaries(world, hardEdges);
  }

  static const _pixelsPerMeter = 100.0;

  late final _Boundaries _boundaries;
  final Map<PhysicsParticle, f2d.Body> _particlesBody = {};
  final Map<PhysicsParticle, f2d.Fixture> _particlesFixture = {};
  final Map<PhysicsParticle, _ParticleFixtureCache> _particleFixtureCache = {};
  late final f2d.World _world;
  List<RRect> _colliders = [];

  @override
  Offset? getParticleScreenPosition(PhysicsParticle particle) {
    final position = _particlesBody[particle]?.position;
    if (position == null) {
      return null;
    }
    return _worldToScreen(position);
  }

  @override
  void forward(Duration elapsedDuration) {
    _world.stepDt(elapsedDuration.inMilliseconds / Duration.millisecondsPerSecond);
    // Apply SDF-based collision detection for widget colliders
    _applySDFCollisions();
  }

  /// Sets the list of colliders (RRects) for SDF-based collision detection.
  /// This replaces all existing colliders with the new list.
  void setColliders(List<RRect> colliders) {
    // Create a new list to ensure we're not keeping old references
    _colliders = List<RRect>.from(colliders);
  }

  /// Applies SDF-based collision detection and correction for all particles.
  void _applySDFCollisions() {
    if (_colliders.isEmpty) return;

    for (final entry in _particlesBody.entries) {
      final particle = entry.key;
      final body = entry.value;

      // Widget colliders always work regardless of onlyInteractWithEdges setting

      final particlePosition = _worldToScreen(body.position);
      final particleSize = particle.particle.size;

      // Calculate collision radius based on particle shape
      final collisionRadius = _getCollisionRadius(particle.particle.shape, particleSize);

      // Check collision with each collider
      for (final collider in _colliders) {
        // Get distance from particle center to RRect surface
        // Negative = inside, Positive = outside, Zero = on surface
        final distance = SDFPhysics.getDistanceToRRect(particlePosition, collider);

        // Collision occurs when the particle's edge penetrates the surface
        // distance is from particle center to RRect surface
        // If distance < collisionRadius, the particle edge has penetrated
        // Add a small threshold to prevent jittering when particles are at rest
        const collisionThreshold = 0.5; // pixels
        if (distance < collisionRadius - collisionThreshold) {
          // Calculate penetration depth (how far the particle has penetrated)
          final penetration = collisionRadius - distance;

          // Get surface normal (points outward from collider)
          final normal = SDFPhysics.getNormal(particlePosition, collider);
          if (normal.distance < 0.1) continue; // Invalid normal

          // Ensure normal points outward (away from collider)
          // If distance is negative (inside), normal should point away from center
          // If distance is positive but < radius (edge touching), normal should point away
          final toParticle = particlePosition - collider.center;
          final normalDotToParticle = normal.dx * toParticle.dx + normal.dy * toParticle.dy;
          final outwardNormal = normalDotToParticle > 0 ? normal : -normal;

          // Get current velocity in screen space
          final currentVelocity = body.linearVelocity;
          final screenVelocity = Offset(
            currentVelocity.x * _pixelsPerMeter,
            currentVelocity.y * _pixelsPerMeter,
          );
          final velocityMagnitude = screenVelocity.distance;

          // Check if velocity is moving toward the collider (negative dot product)
          final velocityDotNormal = screenVelocity.dx * outwardNormal.dx + screenVelocity.dy * outwardNormal.dy;

          // Calculate tangential velocity (component parallel to surface)
          // This preserves rolling motion along the edge
          final tangentialVelocity = screenVelocity - outwardNormal * velocityDotNormal;

          // Get restitution value
          final restitution = particle.restitution.value;

          // Only apply corrections if:
          // 1. Particle is actually penetrating (not just touching)
          // 2. Particle has significant velocity toward the collider
          // This prevents jittering when particles are at rest
          if (penetration > collisionThreshold && velocityDotNormal < -0.1) {
            // Push particle out of collider by the penetration depth
            final pushOut = outwardNormal * penetration;
            final worldPushOut = _screenToWorld(pushOut);
            body.setTransform(body.position + worldPushOut, body.angle);

            // Reflect only the normal component with restitution, preserve tangential for rolling
            // velocityDotNormal is negative when moving toward, so -velocityDotNormal is positive (moving away)
            // Apply restitution to reduce bounce: -velocityDotNormal * restitution
            final reflectedNormalComponent = outwardNormal * (-velocityDotNormal * restitution);
            final finalVelocity = tangentialVelocity + reflectedNormalComponent;

            final worldVelocity = f2d.Vector2(
              finalVelocity.dx / _pixelsPerMeter,
              finalVelocity.dy / _pixelsPerMeter,
            );
            body.linearVelocity = worldVelocity;
          } else if (penetration > collisionThreshold * 2) {
            // Only push out if deeply penetrating, but preserve tangential velocity for rolling
            final pushOut = outwardNormal * (penetration - collisionThreshold);
            final worldPushOut = _screenToWorld(pushOut);
            body.setTransform(body.position + worldPushOut, body.angle);

            // If velocity is very low, zero it out to prevent jittering
            // Otherwise apply restitution to normal component and preserve tangential
            if (velocityMagnitude < 1.0) {
              body.linearVelocity = f2d.Vector2.zero();
            } else {
              // Apply restitution to normal component if moving toward collider
              final reflectedNormalComponent = velocityDotNormal < 0
                  ? outwardNormal * (-velocityDotNormal * restitution)
                  : outwardNormal * velocityDotNormal;
              final finalVelocity = tangentialVelocity + reflectedNormalComponent;

              final worldVelocity = f2d.Vector2(
                finalVelocity.dx / _pixelsPerMeter,
                finalVelocity.dy / _pixelsPerMeter,
              );
              body.linearVelocity = worldVelocity;
            }
          } else if (penetration > 0 && velocityDotNormal.abs() < 0.5) {
            // Particle is in contact but not penetrating much and velocity is mostly tangential
            // This is rolling along the edge - just push out slightly
            // Apply restitution if there's any normal component
            final pushOut = outwardNormal * (penetration * 0.5);
            final worldPushOut = _screenToWorld(pushOut);
            body.setTransform(body.position + worldPushOut, body.angle);

            // Apply restitution to any normal component while preserving tangential
            if (velocityDotNormal < -0.01) {
              // Small normal component toward collider - apply restitution
              final reflectedNormalComponent = outwardNormal * (-velocityDotNormal * restitution);
              final finalVelocity = tangentialVelocity + reflectedNormalComponent;

              final worldVelocity = f2d.Vector2(
                finalVelocity.dx / _pixelsPerMeter,
                finalVelocity.dy / _pixelsPerMeter,
              );
              body.linearVelocity = worldVelocity;
            }
            // If velocityDotNormal is positive or very small, don't modify - let Forge2D handle it
          }
        }
      }
    }
  }

  @override
  void removeParticle(PhysicsParticle particle) {
    final body = _particlesBody.remove(particle);
    final fixture = _particlesFixture.remove(particle);
    _particleFixtureCache.remove(particle);
    if (body != null) {
      if (fixture != null) {
        body.destroyFixture(fixture);
      }
      _world.destroyBody(body);
    }
  }

  @override
  void addParticle(PhysicsParticle particle) {
    final speed = particle.velocity;
    final angleInDegrees = particle.angle;

    final angleInRadians = angleInDegrees * (pi / 180);

    final vx = speed.value * cos(angleInRadians);
    final vy = speed.value * sin(angleInRadians);

    final bodyDef = f2d.BodyDef()
      ..type = f2d.BodyType.dynamic
      ..position = _screenToWorld(particle.particle.initialPosition);

    final body = _world.createBody(bodyDef)..linearVelocity = f2d.Vector2(vx, vy);
    _particlesBody[particle] = body;
  }

  @override
  void updateSurfaceSize(Size surfaceSize) {
    _boundaries.updateBoundaries(_sizeToWorld(surfaceSize));
  }

  @override
  void updateParticles(List<PhysicsParticle> activeParticles) {
    for (final particle in activeParticles) {
      final body = _particlesBody[particle];
      if (body == null) continue;

      // Get current particle properties
      final particleSize = _sizeToWorld(particle.particle.size);
      final density = particle.density.value;
      final friction = particle.friction.value;
      final restitution = particle.restitution.value;
      final particleMask = particle.onlyInteractWithEdges ? _edgeCategory : _particleCategory | _edgeCategory;
      final isCircle = particle.particle.shape is CircleShape;

      // Check if we need to recreate the fixture
      final cached = _particleFixtureCache[particle];
      final needsUpdate = cached == null ||
          cached.size.x != particleSize.x ||
          cached.size.y != particleSize.y ||
          cached.density != density ||
          cached.friction != friction ||
          cached.restitution != restitution ||
          cached.maskBits != particleMask ||
          cached.isCircle != isCircle;

      if (needsUpdate) {
        // Destroy old fixture if it exists
        final oldFixture = _particlesFixture[particle];
        if (oldFixture != null) {
          body.destroyFixture(oldFixture);
        }

        // Create new fixture with current properties
        final circleShape = switch (particle.particle.shape) {
          CircleShape() => f2d.CircleShape()..radius = particleSize.x / 2,
          _ => f2d.PolygonShape()
            ..setAsBox(
              particleSize.x / 2,
              particleSize.y / 2,
              f2d.Vector2(0, 0),
              0,
            ),
        };
        final fixtureDef = f2d.FixtureDef(circleShape)
          ..density = density
          ..friction = friction
          ..restitution = restitution
          ..filter.categoryBits = _particleCategory
          ..filter.maskBits = particleMask;
        _particlesFixture[particle] = body.createFixture(fixtureDef);

        // Update cache
        _particleFixtureCache[particle] = _ParticleFixtureCache(
          size: particleSize,
          density: density,
          friction: friction,
          restitution: restitution,
          maskBits: particleMask,
          isCircle: isCircle,
        );
      }
    }
  }

  static f2d.Vector2 _screenToWorld(Offset screenPosition) {
    return f2d.Vector2(
      screenPosition.dx / _pixelsPerMeter,
      screenPosition.dy / _pixelsPerMeter,
    );
  }

  static f2d.Vector2 _sizeToWorld(Size screenSize) {
    return f2d.Vector2(
      screenSize.width / _pixelsPerMeter,
      screenSize.height / _pixelsPerMeter,
    );
  }

  static Offset _worldToScreen(f2d.Vector2 worldPosition) {
    return Offset(
      worldPosition.x * _pixelsPerMeter,
      worldPosition.y * _pixelsPerMeter,
    );
  }

  /// Gets the collision radius for a particle based on its shape.
  ///
  /// For circles, returns the radius.
  /// For squares/rectangles, returns half the diagonal (conservative approximation).
  /// For images, uses the bounding box diagonal.
  static double _getCollisionRadius(Shape shape, Size particleSize) {
    return switch (shape) {
      CircleShape() => particleSize.width / 2,
      SquareShape() => sqrt(particleSize.width * particleSize.width + particleSize.height * particleSize.height) / 2,
      ImageShape() => sqrt(particleSize.width * particleSize.width + particleSize.height * particleSize.height) / 2,
      ImageAssetShape() =>
        sqrt(particleSize.width * particleSize.width + particleSize.height * particleSize.height) / 2,
    };
  }
}

class _Boundaries {
  _Boundaries(this._world, this._hardEdges);

  List<f2d.Body> _boundaries = [];
  final SolidEdges _hardEdges;
  final f2d.World _world;

  void updateBoundaries(f2d.Vector2 newScreenSize) {
    _boundaries
      ..forEach(_world.destroyBody)
      ..clear();
    if (_hardEdges == SolidEdges.none) return;
    _boundaries = _createBoundaries(newScreenSize);
  }

  List<f2d.Body> _createBoundaries(f2d.Vector2 screenSize) {
    final boundaries = <f2d.Body>[];
    if (_hardEdges.left) {
      final leftEdge = f2d.EdgeShape()..set(f2d.Vector2(0, 0), f2d.Vector2(0, screenSize.y));
      boundaries.add(_createEdgeBoundary(leftEdge));
    }
    if (_hardEdges.top) {
      final topEdge = f2d.EdgeShape()..set(f2d.Vector2(0, 0), f2d.Vector2(screenSize.x, 0));
      boundaries.add(_createEdgeBoundary(topEdge));
    }
    if (_hardEdges.right) {
      final rightEdge = f2d.EdgeShape()..set(f2d.Vector2(screenSize.x, 0), f2d.Vector2(screenSize.x, screenSize.y));
      boundaries.add(_createEdgeBoundary(rightEdge));
    }
    if (_hardEdges.bottom) {
      final bottomEdge = f2d.EdgeShape()..set(f2d.Vector2(0, screenSize.y), f2d.Vector2(screenSize.x, screenSize.y));
      boundaries.add(_createEdgeBoundary(bottomEdge));
    }
    return boundaries;
  }

  f2d.Body _createEdgeBoundary(f2d.EdgeShape edge) {
    final bodyDef = f2d.BodyDef()
      ..position = f2d.Vector2.zero()
      ..type = f2d.BodyType.static;

    final fixtureDef = f2d.FixtureDef(edge)
      ..filter.categoryBits = _edgeCategory
      ..filter.maskBits = _edgeMask;
    return _world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// Caches fixture properties to avoid unnecessary fixture recreation.
class _ParticleFixtureCache {
  const _ParticleFixtureCache({
    required this.size,
    required this.density,
    required this.friction,
    required this.restitution,
    required this.maskBits,
    required this.isCircle,
  });

  final f2d.Vector2 size;
  final double density;
  final double friction;
  final double restitution;
  final int maskBits;
  final bool isCircle;
}
