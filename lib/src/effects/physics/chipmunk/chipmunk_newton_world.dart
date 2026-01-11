import 'dart:math';
import 'dart:ui';

import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi.dart' as chipmunk2d_physics_ffi;
import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/effects/relativistic/newton_world.dart';
import 'package:newton_particles/src/utils/sdf_physics.dart';

const _particleCategory = 0x0001;
const _edgeCategory = 0x0002;
const int _edgeMask = _particleCategory;

/// The `ChipmunkNewtonWorld` class implements the `NewtonWorld` interface using the Chipmunk2D
/// physics engine. It manages the simulation of physics particles within a 2D world,
/// handling their addition, removal, and updates based on the physical properties defined.

class ChipmunkNewtonWorld implements NewtonWorld {
  /// Creates a new `ChipmunkNewtonWorld` with the specified gravity.
  ///
  /// - [gravity]: The gravity vector applied to the world, typically defined as `Gravity(dx, dy)`.
  ChipmunkNewtonWorld(Gravity gravity, SolidEdges hardEdges) {
    _space = chipmunk2d_physics_ffi.Space();
    _space.gravity = chipmunk2d_physics_ffi.Vector(gravity.dx, gravity.dy);
    _boundaries = _Boundaries(_space, hardEdges);
  }

  static const _pixelsPerMeter = 100.0;

  late final _Boundaries _boundaries;
  final Map<PhysicsParticle, chipmunk2d_physics_ffi.Body> _particlesBody = {};
  final Map<PhysicsParticle, chipmunk2d_physics_ffi.Shape> _particlesShape = {};
  final Map<PhysicsParticle, _ParticleFixtureCache> _particleFixtureCache = {};
  late final chipmunk2d_physics_ffi.Space _space;
  List<RRect> _colliders = [];

  @override
  Offset? getParticleScreenPosition(PhysicsParticle particle) {
    final body = _particlesBody[particle];
    if (body == null) {
      return null;
    }
    final position = body.position;
    return _worldToScreen(position);
  }

  @override
  void forward(Duration elapsedDuration) {
    _space.step(elapsedDuration.inMilliseconds / Duration.millisecondsPerSecond);
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
          final currentVelocity = body.velocity;
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
            body.position = body.position + worldPushOut;

            // Reflect only the normal component with restitution, preserve tangential for rolling
            // velocityDotNormal is negative when moving toward, so -velocityDotNormal is positive (moving away)
            // Apply restitution to reduce bounce: -velocityDotNormal * restitution
            final reflectedNormalComponent = outwardNormal * (-velocityDotNormal * restitution);
            final finalVelocity = tangentialVelocity + reflectedNormalComponent;

            final worldVelocity = chipmunk2d_physics_ffi.Vector(
              finalVelocity.dx / _pixelsPerMeter,
              finalVelocity.dy / _pixelsPerMeter,
            );
            body.velocity = worldVelocity;
          } else if (penetration > collisionThreshold * 2) {
            // Only push out if deeply penetrating, but preserve tangential velocity for rolling
            final pushOut = outwardNormal * (penetration - collisionThreshold);
            final worldPushOut = _screenToWorld(pushOut);
            body.position = body.position + worldPushOut;

            // If velocity is very low, zero it out to prevent jittering
            // Otherwise apply restitution to normal component and preserve tangential
            if (velocityMagnitude < 1.0) {
              body.velocity = chipmunk2d_physics_ffi.Vector.zero;
            } else {
              // Apply restitution to normal component if moving toward collider
              final reflectedNormalComponent = velocityDotNormal < 0
                  ? outwardNormal * (-velocityDotNormal * restitution)
                  : outwardNormal * velocityDotNormal;
              final finalVelocity = tangentialVelocity + reflectedNormalComponent;

              final worldVelocity = chipmunk2d_physics_ffi.Vector(
                finalVelocity.dx / _pixelsPerMeter,
                finalVelocity.dy / _pixelsPerMeter,
              );
              body.velocity = worldVelocity;
            }
          } else if (penetration > 0 && velocityDotNormal.abs() < 0.5) {
            // Particle is in contact but not penetrating much and velocity is mostly tangential
            // This is rolling along the edge - just push out slightly
            // Apply restitution if there's any normal component
            final pushOut = outwardNormal * (penetration * 0.5);
            final worldPushOut = _screenToWorld(pushOut);
            body.position = body.position + worldPushOut;

            // Apply restitution to any normal component while preserving tangential
            if (velocityDotNormal < -0.01) {
              // Small normal component toward collider - apply restitution
              final reflectedNormalComponent = outwardNormal * (-velocityDotNormal * restitution);
              final finalVelocity = tangentialVelocity + reflectedNormalComponent;

              final worldVelocity = chipmunk2d_physics_ffi.Vector(
                finalVelocity.dx / _pixelsPerMeter,
                finalVelocity.dy / _pixelsPerMeter,
              );
              body.velocity = worldVelocity;
            }
            // If velocityDotNormal is positive or very small, don't modify - let Chipmunk2D handle it
          }
        }
      }
    }
  }

  @override
  void removeParticle(PhysicsParticle particle) {
    final body = _particlesBody.remove(particle);
    final shape = _particlesShape.remove(particle);
    _particleFixtureCache.remove(particle);
    if (body != null) {
      if (shape != null) {
        _space.removeShape(shape);
        shape.dispose();
      }
      _space.removeBody(body);
      body.dispose();
    }
  }

  @override
  void addParticle(PhysicsParticle particle) {
    final speed = particle.velocity;
    final angleInDegrees = particle.angle;

    final angleInRadians = angleInDegrees * (pi / 180);

    final vx = speed.value * cos(angleInRadians);
    final vy = speed.value * sin(angleInRadians);

    // Create body with temporary mass and moment - will be updated when shape is added
    // Use a default mass of 1.0, moment will be calculated when shape is created
    final body = chipmunk2d_physics_ffi.Body.dynamic(1, 1)
      ..position = _screenToWorld(particle.particle.initialPosition)
      ..velocity = chipmunk2d_physics_ffi.Vector(vx, vy);

    _space.addBody(body);
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

      // Check if we need to recreate the shape
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
        // Destroy old shape if it exists
        final oldShape = _particlesShape[particle];
        if (oldShape != null) {
          _space.removeShape(oldShape);
          oldShape.dispose();
        }

        // Create new shape with current properties
        final shape = switch (particle.particle.shape) {
          CircleShape() => chipmunk2d_physics_ffi.CircleShape(
              body,
              particleSize.x / 2,
            ),
          _ => chipmunk2d_physics_ffi.BoxShape(
              body,
              particleSize.x,
              particleSize.y,
            ),
        }
          ..friction = friction
          ..elasticity = restitution
          ..density = density
          ..filter = chipmunk2d_physics_ffi.ShapeFilter(
            categories: _particleCategory,
            mask: particleMask,
          );

        // Update body mass and moment from shape - must be after setting shape density
        body
          ..mass = shape.mass
          ..moment = shape.moment;

        _space.addShape(shape);
        _particlesShape[particle] = shape;

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

  static chipmunk2d_physics_ffi.Vector _screenToWorld(Offset screenPosition) {
    return chipmunk2d_physics_ffi.Vector(
      screenPosition.dx / _pixelsPerMeter,
      screenPosition.dy / _pixelsPerMeter,
    );
  }

  static chipmunk2d_physics_ffi.Vector _sizeToWorld(Size screenSize) {
    return chipmunk2d_physics_ffi.Vector(
      screenSize.width / _pixelsPerMeter,
      screenSize.height / _pixelsPerMeter,
    );
  }

  static Offset _worldToScreen(chipmunk2d_physics_ffi.Vector worldPosition) {
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
  _Boundaries(this._space, this._hardEdges);

  List<chipmunk2d_physics_ffi.Shape> _boundaries = [];
  final SolidEdges _hardEdges;
  final chipmunk2d_physics_ffi.Space _space;

  void updateBoundaries(chipmunk2d_physics_ffi.Vector newScreenSize) {
    _boundaries
      ..forEach((shape) {
        _space.removeShape(shape);
        shape.dispose();
      })
      ..clear();
    if (_hardEdges == SolidEdges.none) return;
    _boundaries = _createBoundaries(newScreenSize);
  }

  List<chipmunk2d_physics_ffi.Shape> _createBoundaries(chipmunk2d_physics_ffi.Vector screenSize) {
    final boundaries = <chipmunk2d_physics_ffi.Shape>[];
    final staticBody = _space.staticBody;

    if (_hardEdges.left) {
      final leftEdge = chipmunk2d_physics_ffi.SegmentShape(
        staticBody,
        chipmunk2d_physics_ffi.Vector.zero,
        chipmunk2d_physics_ffi.Vector(0, screenSize.y),
        0,
      );
      _setEdgeFilter(leftEdge);
      _space.addShape(leftEdge);
      boundaries.add(leftEdge);
    }
    if (_hardEdges.top) {
      final topEdge = chipmunk2d_physics_ffi.SegmentShape(
        staticBody,
        chipmunk2d_physics_ffi.Vector.zero,
        chipmunk2d_physics_ffi.Vector(screenSize.x, 0),
        0,
      );
      _setEdgeFilter(topEdge);
      _space.addShape(topEdge);
      boundaries.add(topEdge);
    }
    if (_hardEdges.right) {
      final rightEdge = chipmunk2d_physics_ffi.SegmentShape(
        staticBody,
        chipmunk2d_physics_ffi.Vector(screenSize.x, 0),
        chipmunk2d_physics_ffi.Vector(screenSize.x, screenSize.y),
        0,
      );
      _setEdgeFilter(rightEdge);
      _space.addShape(rightEdge);
      boundaries.add(rightEdge);
    }
    if (_hardEdges.bottom) {
      final bottomEdge = chipmunk2d_physics_ffi.SegmentShape(
        staticBody,
        chipmunk2d_physics_ffi.Vector(0, screenSize.y),
        chipmunk2d_physics_ffi.Vector(screenSize.x, screenSize.y),
        0,
      );
      _setEdgeFilter(bottomEdge);
      _space.addShape(bottomEdge);
      boundaries.add(bottomEdge);
    }
    return boundaries;
  }

  void _setEdgeFilter(chipmunk2d_physics_ffi.Shape shape) {
    shape.filter = const chipmunk2d_physics_ffi.ShapeFilter(
      categories: _edgeCategory,
      mask: _edgeMask,
    );
  }
}

/// Caches fixture properties to avoid unnecessary shape recreation.
class _ParticleFixtureCache {
  const _ParticleFixtureCache({
    required this.size,
    required this.density,
    required this.friction,
    required this.restitution,
    required this.maskBits,
    required this.isCircle,
  });

  final chipmunk2d_physics_ffi.Vector size;
  final double density;
  final double friction;
  final double restitution;
  final int maskBits;
  final bool isCircle;
}
