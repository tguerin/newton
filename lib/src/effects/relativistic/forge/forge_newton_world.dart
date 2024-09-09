import 'dart:math';
import 'dart:ui';

import 'package:forge2d/forge2d.dart' as f2d;
import 'package:newton_particles/newton_particles.dart';
import 'package:newton_particles/src/effects/relativistic/newton_world.dart';

const _particleCategory = 0x0001;
const _edgeCategory = 0x0002;
const _edgeMask = _particleCategory;

/// The `ForgeNewtonWorld` class implements the `NewtonWorld` interface using the Forge2D
/// physics engine. It manages the simulation of relativistic particles within a 2D world,
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
  final Map<RelativisticParticle, f2d.Body> _particlesBody = {};
  final Map<RelativisticParticle, f2d.Fixture> _particlesFixture = {};
  late final f2d.World _world;

  @override
  Offset? getParticleScreenPosition(RelativisticParticle particle) {
    final position = _particlesBody[particle]?.position;
    if (position == null) {
      return null;
    }
    return _worldToScreen(position);
  }

  @override
  void forward(Duration elapsedDuration) {
    _world.stepDt(elapsedDuration.inMilliseconds / Duration.millisecondsPerSecond);
  }

  @override
  void removeParticle(RelativisticParticle particle) {
    final body = _particlesBody.remove(particle);
    final fixture = _particlesFixture.remove(particle);
    if (body != null) {
      if (fixture != null) {
        body.destroyFixture(fixture);
      }
      _world.destroyBody(body);
    }
  }

  @override
  void addParticle(RelativisticParticle relativistParticle) {
    final speed = relativistParticle.velocity;
    final angleInDegrees = relativistParticle.angle;

    final angleInRadians = angleInDegrees * (pi / 180);

    final vx = speed.value * cos(angleInRadians);
    final vy = speed.value * sin(angleInRadians);

    final bodyDef = f2d.BodyDef()
      ..type = f2d.BodyType.dynamic
      ..position = _screenToWorld(relativistParticle.particle.initialPosition);

    final body = _world.createBody(bodyDef)..linearVelocity = f2d.Vector2(vx, vy);
    _particlesBody[relativistParticle] = body;
  }

  @override
  void updateSurfaceSize(Size surfaceSize) {
    _boundaries.updateBoundaries(_sizeToWorld(surfaceSize));
  }

  @override
  void updateParticles(List<RelativisticParticle> activeParticles) {
    for (final relativistParticle in activeParticles) {
      final particleMask = relativistParticle.onlyInteractWithEdges ? _edgeCategory : _particleCategory | _edgeCategory;
      final body = _particlesBody[relativistParticle];
      if (body == null) continue;
      final fixture = _particlesFixture[relativistParticle];
      if (fixture != null) {
        body.destroyFixture(fixture);
      }
      final particleSize = _sizeToWorld(relativistParticle.particle.size);
      final circleShape = switch (relativistParticle.particle.configuration.shape) {
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
        ..density = relativistParticle.density.value
        ..friction = relativistParticle.friction.value
        ..restitution = relativistParticle.restitution.value
        ..filter.categoryBits = _particleCategory
        ..filter.maskBits = particleMask;
      _particlesFixture[relativistParticle] = body.createFixture(fixtureDef);
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
}

class _Boundaries {
  _Boundaries(this._world, this._hardEdges);

  List<f2d.Body> _boundaries = [];
  final SolidEdges _hardEdges;
  final f2d.World _world;

  void updateBoundaries(f2d.Vector2 newScreenSize) {
    for (final boundary in _boundaries) {
      _world.destroyBody(boundary);
    }
    _boundaries.clear();
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
