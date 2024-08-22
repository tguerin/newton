import 'dart:math';
import 'dart:ui';

import 'package:forge2d/forge2d.dart' as f2d;
import 'package:newton_particles/newton_particles.dart';

class NewtonWorld {
  static const pixelsPerMeter = 100.0;
  final f2d.World world;
  final Map<RelativisticParticle, f2d.Body> particlesBody = {};
  final Map<RelativisticParticle, f2d.Fixture> particlesFixture = {};

  NewtonWorld(f2d.Vector2 gravity) : world = f2d.World(gravity);

  static f2d.Vector2 screenToWorld(Offset screenPosition) {
    return f2d.Vector2(
      screenPosition.dx / pixelsPerMeter,
      screenPosition.dy / pixelsPerMeter,
    );
  }

  static Offset worldToScreen(f2d.Vector2 worldPosition) {
    return Offset(
      worldPosition.x * pixelsPerMeter,
      worldPosition.y * pixelsPerMeter,
    );
  }

  Offset? getParticleScreenPosition(RelativisticParticle particle) {
    final position = particlesBody[particle]?.position;
    if(position == null) {
      return null;
    }
    return worldToScreen(position);
  }

  void forward(Duration elapsedDuration) {
    world.stepDt(elapsedDuration.inMilliseconds / Duration.millisecondsPerSecond);
  }

  void removeParticle(RelativisticParticle particle) {
    final body = particlesBody[particle];
    particlesFixture.remove(particle);
    if(body != null) {
      world.destroyBody(body);
    }
  }

  f2d.Body createBody(f2d.BodyDef bodyDef) => world.createBody(bodyDef);

  void addParticle(RelativisticParticle relativistParticle) {
    final speed = 5.0;
    final angleInDegrees = -90; // relativistParticle.angle; // Angle in degrees

    // Convert angle to radians
    final angleInRadians = angleInDegrees * (pi / 180);

    // Compute the velocity components
    final vx = speed * cos(angleInRadians); // Horizontal velocity component
    final vy = speed * sin(angleInRadians); // Vertical velocity component

    // Define the body
    final bodyDef = f2d.BodyDef()
      ..type = f2d.BodyType.dynamic // The body is dynamic, meaning it is affected by forces
      ..position = screenToWorld(relativistParticle.particle.initialPosition); // Initial position in the world

    // Create the body in the world
    final body = world.createBody(bodyDef);

    // Define the shape of the body as a circle
    final circleShape = f2d.CircleShape()
      ..radius = relativistParticle.particle.size.width / pixelsPerMeter; // Radius of the circle

    // Define the fixture
    final fixtureDef = f2d.FixtureDef(circleShape)
      ..density = 1.0 // Mass density of the body
      ..friction = 0.3 // Friction when sliding along surfaces
      ..restitution = 0.5
      ..filter.groupIndex = -1; // Bounciness
    body.linearVelocity = f2d.Vector2(vx, vy);
    body.createFixture(fixtureDef);

  }
}
