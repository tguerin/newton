import 'dart:math';
import 'dart:ui';

import 'package:forge2d/forge2d.dart' as f2d;
import 'package:newton_particles/newton_particles.dart';

class NewtonWorld {
  NewtonWorld(Gravity gravity) {
    final world = f2d.World(f2d.Vector2(gravity.dx, gravity.dy));
    _world = world;
    _boundaries = _Boundaries(world);
  }

  static const _pixelsPerMeter = 100.0;

  late final f2d.World _world;
  late final _Boundaries _boundaries;
  final Map<RelativisticParticle, f2d.Body> _particlesBody = {};
  final Map<RelativisticParticle, f2d.Fixture> _particlesFixture = {};

  static f2d.Vector2 screenToWorld(Offset screenPosition) {
    return f2d.Vector2(
      screenPosition.dx / _pixelsPerMeter,
      screenPosition.dy / _pixelsPerMeter,
    );
  }

  static f2d.Vector2 sizeToWorld(Size screenSize) {
    return f2d.Vector2(
      screenSize.width / _pixelsPerMeter,
      screenSize.height / _pixelsPerMeter,
    );
  }

  static Offset worldToScreen(f2d.Vector2 worldPosition) {
    return Offset(
      worldPosition.x * _pixelsPerMeter,
      worldPosition.y * _pixelsPerMeter,
    );
  }

  Offset? getParticleScreenPosition(RelativisticParticle particle) {
    final position = _particlesBody[particle]?.position;
    if (position == null) {
      return null;
    }
    return worldToScreen(position);
  }

  void forward(Duration elapsedDuration) {
    _world.stepDt(elapsedDuration.inMilliseconds / Duration.millisecondsPerSecond);
  }

  void removeParticle(RelativisticParticle particle) {
    final body = _particlesBody[particle];
    _particlesFixture.remove(particle);
    if (body != null) {
      _world.destroyBody(body);
    }
  }

  f2d.Body createBody(f2d.BodyDef bodyDef) => _world.createBody(bodyDef);

  void addParticle(RelativisticParticle relativistParticle) {
    final speed = relativistParticle.velocity;
    final angleInDegrees = relativistParticle.angle;

    // Convert angle to radians
    final angleInRadians = angleInDegrees * (pi / 180);

    // Compute the velocity components
    final vx = speed.value * cos(angleInRadians); // Horizontal velocity component
    final vy = speed.value * sin(angleInRadians); // Vertical velocity component

    // Define the body
    final bodyDef = f2d.BodyDef()
      ..type = f2d.BodyType.dynamic // The body is dynamic, meaning it is affected by forces
      ..position = screenToWorld(relativistParticle.particle.initialPosition); // Initial position in the world

    // Create the body in the world
    final body = _world.createBody(bodyDef);

    _particlesBody[relativistParticle] = body;
    // Define the shape of the body as a circle
    final circleShape = f2d.CircleShape()
      ..radius = relativistParticle.particle.size.width / _pixelsPerMeter; // Radius of the circle

    // Define the fixture
    final fixtureDef = f2d.FixtureDef(circleShape)
      ..density = .2 // Mass density of the body
      ..friction = 0.05 // Friction when sliding along surfaces
      ..restitution = 0.5; // Bounciness
    body
      ..linearVelocity = f2d.Vector2(vx, vy)
      ..createFixture(fixtureDef);
  }

  void updateSurfaceSize(Size surfaceSize) {
    _boundaries.updateBoundaries(sizeToWorld(surfaceSize));
  }
}

class _Boundaries {
  _Boundaries(this._world);

  List<f2d.Body> _boundaries = [];
  final f2d.World _world;

  void updateBoundaries(f2d.Vector2 newScreenSize) {
    // Remove existing boundaries
    for (final boundary in _boundaries) {
      _world.destroyBody(boundary);
    }
    _boundaries.clear();

    // Add new boundaries based on the updated screen size
    _boundaries = _createBoundaries(newScreenSize);
  }

  List<f2d.Body> _createBoundaries(f2d.Vector2 screenSize) {
    final boundaries = <f2d.Body>[];

    // Create the edges using EdgeShape
    final topEdge = f2d.EdgeShape()..set(f2d.Vector2(0, 0), f2d.Vector2(screenSize.x, 0));
    final bottomEdge = f2d.EdgeShape()..set(f2d.Vector2(0, screenSize.y), f2d.Vector2(screenSize.x, screenSize.y));
    final leftEdge = f2d.EdgeShape()..set(f2d.Vector2(0, 0), f2d.Vector2(0, screenSize.y));
    final rightEdge = f2d.EdgeShape()..set(f2d.Vector2(screenSize.x, 0), f2d.Vector2(screenSize.x, screenSize.y));

    // Create boundary bodies
    boundaries
      ..add(_createEdgeBoundary(topEdge))
      ..add(_createEdgeBoundary(bottomEdge))
      ..add(_createEdgeBoundary(leftEdge))
      ..add(_createEdgeBoundary(rightEdge));

    return boundaries;
  }

  f2d.Body _createEdgeBoundary(f2d.EdgeShape edge) {
    final bodyDef = f2d.BodyDef()
      ..position = f2d.Vector2.zero()
      ..type = f2d.BodyType.static;

    return _world.createBody(bodyDef)..createFixtureFromShape(edge);
  }
}
