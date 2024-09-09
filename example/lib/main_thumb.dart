import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newton_particles/newton_particles.dart';

void main() {
  runApp(const ThumbUpExampleApp());
}

class ThumbUpExampleApp extends StatelessWidget {
  const ThumbUpExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = <int, Color>{
      50: Color.fromRGBO(27, 27, 29, .1),
      100: Color.fromRGBO(27, 27, 29, .2),
      200: Color.fromRGBO(27, 27, 29, .3),
      300: Color.fromRGBO(27, 27, 29, .4),
      400: Color.fromRGBO(27, 27, 29, .5),
      500: Color.fromRGBO(27, 27, 29, .6),
      600: Color.fromRGBO(27, 27, 29, .7),
      700: Color.fromRGBO(27, 27, 29, .8),
      800: Color.fromRGBO(27, 27, 29, .9),
      900: Color.fromRGBO(27, 27, 29, 1),
    };
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const MaterialColor(
          0x1b1b1d,
          primaryColor,
        ),
        canvasColor: const Color(0xff1b1b1d),
      ),
      home: const ThumbUpExample(),
    );
  }
}

class ThumbUpExample extends StatefulWidget {
  const ThumbUpExample({super.key});

  @override
  State<ThumbUpExample> createState() => _ThumbUpExampleState();
}

class _ThumbUpExampleState extends State<ThumbUpExample> {
  final _newtonKey = GlobalKey<NewtonState>();

  final Future<List<Shape>> _imageAssets = Future.wait([
    ImageShape.loadFromAssetAsync('images/thumb_up_1.png'),
    ImageShape.loadFromAssetAsync('images/thumb_up_2.png'),
    ImageShape.loadFromAssetAsync('images/thumb_up_3.png'),
  ]);

  final _emojiSize = 50.0;
  final _btnSize = 50.0;

  DeterministicEffectConfiguration currentActiveEffectConfiguration(Shape shape, Duration delay) {
    return DeterministicEffectConfiguration(
      particleCount: 100,
      particlesPerEmit: 100,
      distanceCurve: Curves.slowMiddle,
      emitCurve: Curves.fastOutSlowIn,
      fadeInCurve: Curves.easeIn,
      fadeOutCurve: Curves.easeOut,
      emitDuration: const Duration(milliseconds: 250),
      minAngle: -135,
      maxAngle: -45,
      minDistance: 90,
      maxDistance: 220,
      maxParticleLifespan: const Duration(seconds: 3),
      minFadeOutThreshold: 0.6,
      maxFadeOutThreshold: 0.8,
      minBeginScale: 0.7,
      maxBeginScale: 0.9,
      minEndScale: 1,
      maxEndScale: 1.2,
      particleConfiguration: ParticleConfiguration(
        shape: shape,
        size: Size.square(_emojiSize),
      ),
      startDelay: delay,
      origin: const Offset(0.5, 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Newton(
          key: _newtonKey,
          child: FutureBuilder(
            future: _imageAssets,
            builder: (context, snapshot) => TextButton(
              onPressed: snapshot.data == null
                  ? null
                  : () {
                      final assets = snapshot.data!..shuffle();
                      for (var i = 0; i < assets.length; i++) {
                        _newtonKey.currentState?.addEffect(
                          currentActiveEffectConfiguration(
                            assets[i].clone(),
                            Duration(milliseconds: i * 2000),
                          ),
                        );
                      }
                    },
              child: SizedBox(
                width: _btnSize,
                height: _btnSize,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Text('click')),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
