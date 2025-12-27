import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart' hide Velocity;
import 'package:newton_particles/newton_particles.dart';

DartFormatter? _dartFormatter;

/// Gets the Dart formatter, initializing it only if not on web.
DartFormatter? get _formatter {
  if (kIsWeb) {
    // DartFormatter doesn't work on web, return null to skip formatting
    return null;
  }
  return _dartFormatter ??= DartFormatter();
}

/// Formats the given code string, or returns it unformatted if formatting fails or is unavailable.
String _formatCode(String code) {
  final formatter = _formatter;
  if (formatter == null) {
    // On web or if formatter unavailable, return code as-is
    // code_builder already generates reasonably formatted code
    return code;
  }

  try {
    return formatter.format(code);
  } catch (e) {
    // If formatting fails, return unformatted code
    // This can happen on web or if there's a parsing error
    return code;
  }
}

/// Generates Dart code for a single effect configuration.
String generateEffectCode(EffectConfiguration config, {String? effectName}) {
  Expression expression;
  if (config is DeterministicEffectConfiguration) {
    expression = _generateDeterministicCode(config);
  } else if (config is PhysicsEffectConfiguration) {
    expression = _generatePhysicsCode(config);
  } else {
    throw UnsupportedError('Unsupported configuration type: ${config.runtimeType}');
  }

  final emitter = DartEmitter();
  final code = '${expression.accept(emitter)}';
  return _formatCode(code);
}

/// Generates Dart code for all effects wrapped in a Newton widget.
String generateAllEffectsCode(List<EffectConfiguration> configs) {
  final effectConfigs = configs.map((config) {
    if (config is DeterministicEffectConfiguration) {
      return _generateDeterministicCode(config);
    } else if (config is PhysicsEffectConfiguration) {
      return _generatePhysicsCode(config);
    }
    throw UnsupportedError('Unsupported configuration type: ${config.runtimeType}');
  }).toList();

  final newtonExpression = InvokeExpression.newOf(
    refer('Newton'),
    [],
    {
      'effectConfigurations': literalList(effectConfigs),
    },
  );

  final emitter = DartEmitter();
  final code = '${newtonExpression.accept(emitter)}';
  return _formatCode(code);
}

/// Generates a complete, runnable Flutter app with the given effect configurations.
String generateRunnableApp(List<EffectConfiguration> configs) {
  final library = Library((b) {
    // Add imports - hide Velocity from material.dart to avoid conflict
    b.directives.add(Directive.import('package:flutter/material.dart', hide: const ['Velocity']));
    b.directives.add(Directive.import('package:newton_particles/newton_particles.dart'));

    // Generate effect configurations
    final effectConfigs = configs.map((config) {
      if (config is DeterministicEffectConfiguration) {
        return _generateDeterministicCode(config);
      } else if (config is PhysicsEffectConfiguration) {
        return _generatePhysicsCode(config);
      }
      throw UnsupportedError('Unsupported configuration type: ${config.runtimeType}');
    }).toList();

    // Main function
    b.body.add(
      Method((b) {
        b
          ..name = 'main'
          ..body = Block.of([
            refer('runApp').call([refer('MyApp').newInstance([])]).statement,
          ]);
      }),
    );

    // MyApp widget
    b.body.add(
      Class((b) {
        b
          ..name = 'MyApp'
          ..extend = refer('StatelessWidget');
        b.methods.add(
          Method((b) {
            b
              ..name = 'build'
              ..returns = refer('Widget');
            b.requiredParameters.add(
              Parameter((b) {
                b
                  ..name = 'context'
                  ..type = refer('BuildContext');
              }),
            );
            b.body = Block.of([
              refer('MaterialApp')
                  .newInstance([], {
                    'title': literal('Newton Particles Example'),
                    'theme': refer('ThemeData').newInstance([], {
                      'colorScheme': refer('ColorScheme').property('fromSeed').call([], {
                        'seedColor': refer('Colors').property('deepPurple'),
                      }),
                      'useMaterial3': literal(true),
                    }),
                    'home': refer('MyHomePage').newInstance([]),
                  })
                  .returned
                  .statement,
            ]);
          }),
        );
      }),
    );

    // MyHomePage widget
    b.body.add(
      Class((b) {
        b
          ..name = 'MyHomePage'
          ..extend = refer('StatelessWidget');
        b.methods.add(
          Method((b) {
            b
              ..name = 'build'
              ..returns = refer('Widget');
            b.requiredParameters.add(
              Parameter((b) {
                b
                  ..name = 'context'
                  ..type = refer('BuildContext');
              }),
            );
            b.body = Block.of([
              refer('Scaffold')
                  .newInstance([], {
                    'appBar': refer('AppBar').newInstance([], {
                      'backgroundColor': refer('Theme')
                          .property('of')
                          .call([refer('context')])
                          .property('colorScheme')
                          .property('inversePrimary'),
                      'title': refer('Text').newInstance([literal('Newton Particles')]),
                    }),
                    'body': refer('Newton').newInstance([], {
                      'effectConfigurations': literalList(effectConfigs),
                    }),
                  })
                  .returned
                  .statement,
            ]);
          }),
        );
      }),
    );
  });

  final emitter = DartEmitter();
  final code = '${library.accept(emitter)}';
  return _formatCode(code);
}

Expression _generateDeterministicCode(DeterministicEffectConfiguration config) {
  final detProps = config.deterministicProperties;
  final visualProps = config.visualProperties;
  final emissionProps = config.emissionProperties;
  final animationProps = config.animationProperties;
  final layerProps = config.layerProperties;

  final parameters = <String, Expression>{};

  // Deterministic properties
  parameters['deterministicProperties'] = InvokeExpression.newOf(
    refer('DeterministicProperties'),
    [],
    {
      'distance': _formatRange(detProps.distance),
      'angle': _formatRange(detProps.angle),
    },
  );

  // Visual properties
  parameters['visualProperties'] = _generateVisualProperties(visualProps);

  // Emission properties
  parameters['emissionProperties'] = _generateEmissionProperties(emissionProps);

  // Animation properties
  if (animationProps.startDelay != Duration.zero) {
    parameters['animationProperties'] = InvokeExpression.newOf(
      refer('AnimationProperties'),
      [],
      {'startDelay': _formatDuration(animationProps.startDelay)},
    );
  }

  // Layer properties
  final layerExpr = _generateLayerProperties(layerProps);
  if (layerExpr != null) {
    parameters['layerProperties'] = layerExpr;
  }

  // Distance curve
  if (config.distanceCurve != Curves.linear) {
    parameters['distanceCurve'] = _formatCurve(config.distanceCurve);
  }

  // Custom path builder
  if (config.customPathBuilder != null) {
    // Note: customPathBuilder cannot be serialized
  }

  // Particle configuration
  parameters['particleConfiguration'] = _generateParticleConfiguration(config.particleConfiguration);

  return InvokeExpression.newOf(
    refer('DeterministicEffectConfiguration'),
    [],
    parameters,
  );
}

Expression _generatePhysicsCode(PhysicsEffectConfiguration config) {
  final physicsProps = config.physicsProperties;
  final visualProps = config.visualProperties;
  final emissionProps = config.emissionProperties;
  final animationProps = config.animationProperties;
  final layerProps = config.layerProperties;

  final parameters = <String, Expression>{};

  // Physics properties
  parameters['physicsProperties'] = InvokeExpression.newOf(
    refer('PhysicsProperties'),
    [],
    {
      'density': _formatDensityRange(physicsProps.density),
      'friction': _formatFrictionRange(physicsProps.friction),
      'restitution': _formatRestitutionRange(physicsProps.restitution),
      'velocity': _formatVelocityRange(physicsProps.velocity),
      'angle': _formatRange(physicsProps.angle),
      'gravity': _formatGravity(physicsProps.gravity),
      'onlyInteractWithEdges': literal(physicsProps.onlyInteractWithEdges),
      'solidEdges': _formatSolidEdges(physicsProps.solidEdges),
    },
  );

  // Visual properties
  parameters['visualProperties'] = _generateVisualProperties(visualProps);

  // Emission properties
  parameters['emissionProperties'] = _generateEmissionProperties(emissionProps);

  // Animation properties
  if (animationProps.startDelay != Duration.zero) {
    parameters['animationProperties'] = InvokeExpression.newOf(
      refer('AnimationProperties'),
      [],
      {'startDelay': _formatDuration(animationProps.startDelay)},
    );
  }

  // Layer properties
  final layerExpr = _generateLayerProperties(layerProps);
  if (layerExpr != null) {
    parameters['layerProperties'] = layerExpr;
  }

  // Configuration overrider
  if (config.configurationOverrider != null) {
    // Note: configurationOverrider cannot be serialized
  }

  // Particle configuration
  parameters['particleConfiguration'] = _generateParticleConfiguration(config.particleConfiguration);

  return InvokeExpression.newOf(
    refer('PhysicsEffectConfiguration'),
    [],
    parameters,
  );
}

Expression _generateVisualProperties(VisualProperties props) {
  final parameters = <String, Expression>{};

  if (props.beginScale.min != 1 || props.beginScale.max != 1) {
    parameters['beginScale'] = _formatRange(props.beginScale);
  }

  if (props.endScale.min != -1 || props.endScale.max != -1) {
    parameters['endScale'] = _formatRange(props.endScale);
  }

  if (props.fadeInThreshold.min != 0 || props.fadeInThreshold.max != 0) {
    parameters['fadeInThreshold'] = _formatRange(props.fadeInThreshold);
  }

  if (props.fadeOutThreshold.min != 1 || props.fadeOutThreshold.max != 1) {
    parameters['fadeOutThreshold'] = _formatRange(props.fadeOutThreshold);
  }

  if (props.scaleCurve != Curves.linear) {
    parameters['scaleCurve'] = _formatCurve(props.scaleCurve);
  }

  if (props.fadeInCurve != Curves.linear) {
    parameters['fadeInCurve'] = _formatCurve(props.fadeInCurve);
  }

  if (props.fadeOutCurve != Curves.linear) {
    parameters['fadeOutCurve'] = _formatCurve(props.fadeOutCurve);
  }

  return InvokeExpression.newOf(
    refer('VisualProperties'),
    [],
    parameters,
  );
}

Expression _generateEmissionProperties(EmissionProperties props) {
  final parameters = <String, Expression>{};

  if (props.emitCurve != Curves.decelerate) {
    parameters['emitCurve'] = _formatCurve(props.emitCurve);
  }

  if (props.emitDuration != const Duration(milliseconds: 100)) {
    parameters['emitDuration'] = _formatDuration(props.emitDuration);
  }

  if (props.particleCount != 0) {
    parameters['particleCount'] = literal(props.particleCount);
  }

  if (props.particlesPerEmit != 1) {
    parameters['particlesPerEmit'] = literal(props.particlesPerEmit);
  }

  if (props.origin != const Offset(0.5, 0.5)) {
    parameters['origin'] = _formatOffset(props.origin);
  }

  if (props.minOriginOffset != Offset.zero || props.maxOriginOffset != Offset.zero) {
    parameters['minOriginOffset'] = _formatOffset(props.minOriginOffset);
    parameters['maxOriginOffset'] = _formatOffset(props.maxOriginOffset);
  }

  if (props.minParticleLifespan != const Duration(seconds: 1) ||
      props.maxParticleLifespan != const Duration(seconds: 1)) {
    parameters['minParticleLifespan'] = _formatDuration(props.minParticleLifespan);
    parameters['maxParticleLifespan'] = _formatDuration(props.maxParticleLifespan);
  }

  return InvokeExpression.newOf(
    refer('EmissionProperties'),
    [],
    parameters,
  );
}

Expression? _generateLayerProperties(LayerProperties props) {
  if (props.particleLayer == ParticleLayer.background && props.trail is NoTrail) {
    return null;
  }

  final parameters = <String, Expression>{};

  if (props.particleLayer != ParticleLayer.background) {
    parameters['particleLayer'] = refer('ParticleLayer.${props.particleLayer.name}');
  }

  if (props.trail is StraightTrail) {
    final trail = props.trail as StraightTrail;
    parameters['trail'] = InvokeExpression.newOf(
      refer('StraightTrail'),
      [],
      {
        'trailProgress': literal(trail.trailProgress),
        'trailWidth': literal(trail.trailWidth),
      },
    );
  }

  return InvokeExpression.newOf(
    refer('LayerProperties'),
    [],
    parameters,
  );
}

Expression _generateParticleConfiguration(ParticleConfiguration config) {
  final parameters = <String, Expression>{};

  // Shape
  if (config.shape != null) {
    parameters['shape'] = _formatShape(config.shape!);
  } else if (config.shapeBuilder != null) {
    // Note: shapeBuilder cannot be serialized
  }

  // Size
  parameters['size'] = _formatSize(config.size);

  // Color
  if (config.color is! SingleParticleColor || (config.color as SingleParticleColor).color != Colors.white) {
    parameters['color'] = _formatColor(config.color);
  }

  // Post effect builder
  if (config.postEffectBuilder != null) {
    // Note: postEffectBuilder cannot be serialized
  }

  return InvokeExpression.newOf(
    refer('ParticleConfiguration'),
    [],
    parameters,
  );
}

Expression _formatRange<T extends num>(Range<T> range) {
  if (range.min == range.max) {
    return InvokeExpression.newOf(
      refer('Range').property('single'),
      [literal(range.min)],
    );
  } else {
    return InvokeExpression.newOf(
      refer('Range').property('between'),
      [literal(range.min), literal(range.max)],
    );
  }
}

Expression _formatDuration(Duration duration) {
  if (duration.inDays > 0) {
    return InvokeExpression.newOf(
      refer('Duration'),
      [],
      {'days': literal(duration.inDays)},
    );
  } else if (duration.inHours > 0) {
    return InvokeExpression.newOf(
      refer('Duration'),
      [],
      {'hours': literal(duration.inHours)},
    );
  } else if (duration.inMinutes > 0) {
    return InvokeExpression.newOf(
      refer('Duration'),
      [],
      {'minutes': literal(duration.inMinutes)},
    );
  } else if (duration.inSeconds > 0) {
    return InvokeExpression.newOf(
      refer('Duration'),
      [],
      {'seconds': literal(duration.inSeconds)},
    );
  } else {
    return InvokeExpression.newOf(
      refer('Duration'),
      [],
      {'milliseconds': literal(duration.inMilliseconds)},
    );
  }
}

Expression _formatOffset(Offset offset) {
  return InvokeExpression.newOf(
    refer('Offset'),
    [literal(offset.dx), literal(offset.dy)],
  );
}

Expression _formatSize(Size size) {
  if (size.width == size.height) {
    return refer('Size').property('square').call([literal(size.width)]);
  }
  return InvokeExpression.newOf(
    refer('Size'),
    [literal(size.width), literal(size.height)],
  );
}

Expression _formatCurve(Curve curve) {
  // Try to match common curves
  final curveName = _getCurveName(curve);
  if (curveName != null) {
    return refer('Curves.$curveName');
  }

  // For custom curves, use linear with a comment
  return refer('Curves.linear');
}

String? _getCurveName(Curve curve) {
  if (curve == Curves.linear) return 'linear';
  if (curve == Curves.decelerate) return 'decelerate';
  if (curve == Curves.ease) return 'ease';
  if (curve == Curves.easeIn) return 'easeIn';
  if (curve == Curves.easeOut) return 'easeOut';
  if (curve == Curves.easeInOut) return 'easeInOut';
  if (curve == Curves.fastOutSlowIn) return 'fastOutSlowIn';
  if (curve == Curves.bounceIn) return 'bounceIn';
  if (curve == Curves.bounceOut) return 'bounceOut';
  if (curve == Curves.bounceInOut) return 'bounceInOut';
  if (curve == Curves.elasticIn) return 'elasticIn';
  if (curve == Curves.elasticOut) return 'elasticOut';
  if (curve == Curves.elasticInOut) return 'elasticInOut';
  return null;
}

Expression _formatShape(Shape shape) {
  if (shape is CircleShape) {
    return InvokeExpression.newOf(refer('CircleShape'), []);
  } else if (shape is SquareShape) {
    return InvokeExpression.newOf(refer('SquareShape'), []);
  } else if (shape is ImageShape) {
    // Note: ImageShape requires a ui.Image, cannot be serialized
    return refer('CircleShape').newInstance([]);
  } else if (shape is ImageAssetShape) {
    return InvokeExpression.newOf(
      refer('ImageAssetShape'),
      [literal(shape.imagePath)],
    );
  }
  return refer('CircleShape').newInstance([]);
}

Expression _formatColor(ParticleColor color) {
  if (color is SingleParticleColor) {
    return InvokeExpression.newOf(
      refer('SingleParticleColor'),
      [],
      {'color': _formatMaterialColor(color.color)},
    );
  } else if (color is LinearInterpolationParticleColor) {
    final colors = color.colors.map(_formatMaterialColor).toList();
    return InvokeExpression.newOf(
      refer('LinearInterpolationParticleColor'),
      [],
      {'colors': literalList(colors)},
    );
  }
  return refer('SingleParticleColor').newInstance([], {'color': refer('Colors.white')});
}

Expression _formatMaterialColor(Color color) {
  // Try to match common Material colors
  final colorName = _getColorName(color);
  if (colorName != null) {
    return refer('Colors.$colorName');
  }

  // For custom colors, use Color.fromARGB
  return InvokeExpression.newOf(
    refer('Color.fromARGB'),
    [
      literal(color.a),
      literal(color.r),
      literal(color.g),
      literal(color.b),
    ],
  );
}

String? _getColorName(Color color) {
  if (color == Colors.white) return 'white';
  if (color == Colors.black) return 'black';
  if (color == Colors.red) return 'red';
  if (color == Colors.green) return 'green';
  if (color == Colors.blue) return 'blue';
  if (color == Colors.yellow) return 'yellow';
  if (color == Colors.orange) return 'orange';
  if (color == Colors.purple) return 'purple';
  if (color == Colors.pink) return 'pink';
  if (color == Colors.cyan) return 'cyan';
  if (color == Colors.amber) return 'amber';
  if (color == Colors.indigo) return 'indigo';
  if (color == Colors.teal) return 'teal';
  if (color == Colors.brown) return 'brown';
  if (color == Colors.grey) return 'grey';
  if (color == Colors.transparent) return 'transparent';
  return null;
}

Expression _formatGravity(Gravity gravity) {
  if (gravity == Gravity.zero) {
    return refer('Gravity.zero');
  } else if (gravity == Gravity.earthGravity) {
    return refer('Gravity.earthGravity');
  } else {
    return InvokeExpression.newOf(
      refer('Gravity'),
      [literal(gravity.dx), literal(gravity.dy)],
    );
  }
}

Expression _formatSolidEdges(SolidEdges edges) {
  if (edges.left && edges.top && edges.right && edges.bottom) {
    return refer('SolidEdges.all').call([]);
  } else if (!edges.left && !edges.top && !edges.right && !edges.bottom) {
    return refer('SolidEdges.none');
  } else {
    return InvokeExpression.newOf(
      refer('SolidEdges.only'),
      [],
      {
        'left': literal(edges.left),
        'top': literal(edges.top),
        'right': literal(edges.right),
        'bottom': literal(edges.bottom),
      },
    );
  }
}

Expression _formatDensityRange(Range<double> range) {
  Expression formatDensityValue(double value) {
    final density = Density.custom(value);
    if (density == Density.defaultDensity) {
      return refer('Density').property('defaultDensity');
    }
    return InvokeExpression.newOf(
      refer('Density').property('custom'),
      [literal(value)],
    );
  }

  if (range.min == range.max) {
    return InvokeExpression.newOf(
      refer('Range').property('between'),
      [
        formatDensityValue(range.min),
        formatDensityValue(range.max),
      ],
    );
  }

  return InvokeExpression.newOf(
    refer('Range').property('between'),
    [
      formatDensityValue(range.min),
      formatDensityValue(range.max),
    ],
  );
}

Expression _formatFrictionRange(Range<double> range) {
  Expression formatFrictionValue(double value) {
    final friction = Friction.custom(value);
    if (friction == Friction.ice) return refer('Friction').property('ice');
    if (friction == Friction.bananaPeel) return refer('Friction').property('bananaPeel');
    if (friction == Friction.teflon) return refer('Friction').property('teflon');
    if (friction == Friction.oil) return refer('Friction').property('oil');
    if (friction == Friction.polishedWood) return refer('Friction').property('polishedWood');
    if (friction == Friction.leather) return refer('Friction').property('leather');
    if (friction == Friction.steelOnSteel) return refer('Friction').property('steelOnSteel');
    if (friction == Friction.rubber) return refer('Friction').property('rubber');
    if (friction == Friction.sandpaper) return refer('Friction').property('sandpaper');
    if (friction == Friction.ductTape) return refer('Friction').property('ductTape');
    return InvokeExpression.newOf(
      refer('Friction').property('custom'),
      [literal(value)],
    );
  }

  if (range.min == range.max) {
    return InvokeExpression.newOf(
      refer('Range').property('between'),
      [
        formatFrictionValue(range.min),
        formatFrictionValue(range.max),
      ],
    );
  }

  return InvokeExpression.newOf(
    refer('Range').property('between'),
    [
      formatFrictionValue(range.min),
      formatFrictionValue(range.max),
    ],
  );
}

Expression _formatRestitutionRange(Range<double> range) {
  Expression formatRestitutionValue(double value) {
    final restitution = Restitution.custom(value);
    if (restitution == Restitution.noBounce) return refer('Restitution').property('noBounce');
    if (restitution == Restitution.slightlyBouncy) return refer('Restitution').property('slightlyBouncy');
    if (restitution == Restitution.rubberBall) return refer('Restitution').property('rubberBall');
    if (restitution == Restitution.rubberChicken) return refer('Restitution').property('rubberChicken');
    if (restitution == Restitution.tennisBall) return refer('Restitution').property('tennisBall');
    if (restitution == Restitution.basketball) return refer('Restitution').property('basketball');
    if (restitution == Restitution.bouncyCastle) return refer('Restitution').property('bouncyCastle');
    if (restitution == Restitution.superBall) return refer('Restitution').property('superBall');
    if (restitution == Restitution.trampoline) return refer('Restitution').property('trampoline');
    if (restitution == Restitution.flubber) return refer('Restitution').property('flubber');
    return InvokeExpression.newOf(
      refer('Restitution').property('custom'),
      [literal(value)],
    );
  }

  if (range.min == range.max) {
    return InvokeExpression.newOf(
      refer('Range').property('between'),
      [
        formatRestitutionValue(range.min),
        formatRestitutionValue(range.max),
      ],
    );
  }

  return InvokeExpression.newOf(
    refer('Range').property('between'),
    [
      formatRestitutionValue(range.min),
      formatRestitutionValue(range.max),
    ],
  );
}

Expression _formatVelocityRange(Range<double> range) {
  Expression formatVelocityValue(double value) {
    final velocity = Velocity.custom(value);
    if (velocity == Velocity.stationary) return refer('Velocity').property('stationary');
    if (velocity == Velocity.snail) return refer('Velocity').property('snail');
    if (velocity == Velocity.walking) return refer('Velocity').property('walking');
    if (velocity == Velocity.running) return refer('Velocity').property('running');
    if (velocity == Velocity.cycling) return refer('Velocity').property('cycling');
    if (velocity == Velocity.rainDrop) return refer('Velocity').property('rainDrop');
    if (velocity == Velocity.car) return refer('Velocity').property('car');
    if (velocity == Velocity.cheetah) return refer('Velocity').property('cheetah');
    if (velocity == Velocity.highway) return refer('Velocity').property('highway');
    if (velocity == Velocity.sound) return refer('Velocity').property('sound');
    if (velocity == Velocity.concorde) return refer('Velocity').property('concorde');
    if (velocity == Velocity.hypersonic) return refer('Velocity').property('hypersonic');
    if (velocity == Velocity.light) return refer('Velocity').property('light');
    if (velocity == Velocity.theFlash) return refer('Velocity').property('theFlash');
    if (velocity == Velocity.procrastination) return refer('Velocity').property('procrastination');
    return InvokeExpression.newOf(
      refer('Velocity').property('custom'),
      [literal(value)],
    );
  }

  if (range.min == range.max) {
    return InvokeExpression.newOf(
      refer('Range').property('between'),
      [
        formatVelocityValue(range.min),
        formatVelocityValue(range.max),
      ],
    );
  }

  return InvokeExpression.newOf(
    refer('Range').property('between'),
    [
      formatVelocityValue(range.min),
      formatVelocityValue(range.max),
    ],
  );
}
