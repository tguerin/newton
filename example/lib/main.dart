import 'package:example/available_effect.dart';
import 'package:example/color_selection.dart';
import 'package:example/range_selection.dart';
import 'package:example/single_value_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newton_particles/newton_particles.dart';
import 'dart:async';
import 'dart:ui' as ui;

void main() {
  runApp(const NewtonExampleApp());
} 

class NewtonExampleApp extends StatelessWidget {
  const NewtonExampleApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const Map<int, Color> primaryColor = {
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
      home: ThumbUpExample(),
    );
  }
}

class ThumbUpExample extends StatefulWidget {
  const ThumbUpExample({super.key});

  @override
  State<ThumbUpExample> createState() => _ThumbUpExampleState();
}

class _ThumbUpExampleState extends State<ThumbUpExample> {
  final newtonKey = GlobalKey<NewtonState>();

  List<String> imgNames = [
    'images/thumb_up_1.png',
    'images/thumb_up_2.png',
    'images/thumb_up_3.png',
  ];

  List<ui.Image> imgs = []; 

  @override
  void initState() {
    super.initState();
    loadImgs();
  }

  void loadImgs() async {
    for (var imgName in imgNames) {
      imgs.add(await loadImageFromAsset(imgName));
    }
  }

  double emojiSize = 50;
  double btnSize = 50;
  Effect currentActiveEffect(int index) {
    return SmokeEffect(
      particleConfiguration: ParticleConfiguration(
        shape: ImageShape(imgs[index]), size: Size.square(emojiSize), color: const SingleParticleColor(color: Colors.black)),
      effectConfiguration: EffectConfiguration(
          particleCount: 100,
          particlesPerEmit: 100,
          distanceCurve: Curves.slowMiddle,
          emitCurve: Curves.fastOutSlowIn,
          fadeInCurve: Curves.easeIn,
          fadeOutCurve: Curves.easeOut,
          emitDuration: 250,
          minAngle: -45,
          maxAngle: 45,
          minDistance: 90,
          maxDistance: 220,
          minDuration: 1000,
          maxDuration: 3000,
          minFadeOutThreshold: 0.6,
          maxFadeOutThreshold: 0.8, 
          minBeginScale: 0.7,
          maxBeginScale: 0.9,
          minEndScale: 1.0,
          maxEndScale: 1.2,
          origin: Offset(btnSize/2, 0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 250,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
              Newton(
                key: newtonKey,
                blendMode: BlendMode.srcIn,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    imgs.shuffle();
                    for (var i = 0; i < imgs.length; i++) {
                      Future.delayed(Duration(milliseconds: i * 100), () {
                        newtonKey.currentState?.addEffect(currentActiveEffect(i));
                      });
                    }
                  },
                  child: Container(
                    width: btnSize,
                    height: btnSize,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(btnSize/2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<ui.Image> loadImageFromAsset(String assetName) async {
  var buffer = await ImmutableBuffer.fromAsset(assetName);
  var codec = await ui.instantiateImageCodecFromBuffer(buffer);
  var frame = await codec.getNextFrame();
  return frame.image;
}

class NewtonConfigurationPage extends StatefulWidget {
  const NewtonConfigurationPage({super.key});

  @override
  State<NewtonConfigurationPage> createState() => _NewtonConfigurationPageState();
}

class _NewtonConfigurationPageState extends State<NewtonConfigurationPage> {
  final _scrollController = ScrollController();

  AvailableEffect _selectedAnimation = AvailableEffect.rain;
  EffectConfiguration _effectConfiguration = AvailableEffect.rain.defaultEffectConfiguration;
  ParticleColor _currentParticleColor = const SingleParticleColor(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Newton(
            activeEffects: [currentActiveEffect()],
            onEffectStateChanged: (effect, state) => { 
            },
          ),
          configurationSection()
        ],
      ),
    );
  }

  Effect currentActiveEffect() {
    final size = MediaQuery.sizeOf(context);
    return _selectedAnimation.instantiate(
      size: size,
      effectConfiguration: _effectConfiguration,
      color: _currentParticleColor,
    );
  }

  Widget configurationSection() {
    return Scrollbar(
      controller: _scrollController,
      scrollbarOrientation: ScrollbarOrientation.left,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              animationSelectionSection(defaultAnimation: _selectedAnimation),
              const SizedBox(
                height: 20,
              ),
              if (_selectedAnimation.supportParameter(AnimationParameter.color)) colorSelection(),
              const SizedBox(
                height: 20,
              ),
              particlesPerEmitSection(),
              emitDurationSection(),
              animationDurationSection(),
              if (_selectedAnimation.supportParameter(AnimationParameter.distance)) particleDistanceSection(),
              if (_selectedAnimation.supportParameter(AnimationParameter.fadeout)) particleFadeoutProgressSection(),
              particleBeginScaleSection(),
              particleEndScaleSection(),
              if (_selectedAnimation.supportParameter(AnimationParameter.angle)) particleAngleSection(),
              if (_selectedAnimation.supportParameter(AnimationParameter.trail)) ...[trailWidthSection(), trailProgressSection()],
            ],
          ),
        ),
      ),
    );
  }

  Widget animationSelectionSection({required AvailableEffect defaultAnimation}) {
    return SizedBox(
        width: 200,
        child: DropdownButton<String>(
          isExpanded: true,
          value: defaultAnimation.label,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              _selectedAnimation = AvailableEffect.of(value!);
              _effectConfiguration = _selectedAnimation.defaultEffectConfiguration..copyWith(particleCount: 3);
            });
          },
          items: AvailableEffect.values.map<DropdownMenuItem<String>>((AvailableEffect value) {
            return DropdownMenuItem<String>(
              value: value.label,
              child: Text(value.label),
            );
          }).toList(),
        ));
  }

  Widget animationDurationSection() {
    return RangeSelection(
      initialMin: _effectConfiguration.minDuration.toDouble(),
      initialMax: _effectConfiguration.maxDuration.toDouble(),
      min: 100,
      max: 8000,
      title: "Animation duration",
      onChanged: (values) {
        setState(() {
          _effectConfiguration = _effectConfiguration.copyWith(
            minDuration: values.start.round(),
            maxDuration: values.end.round(),
          );
        });
      },
    );
  }

  Widget particlesPerEmitSection() {
    return SingleValueSelection(
      value: _effectConfiguration.particlesPerEmit.toDouble(),
      title: "Particles per emit",
      onChanged: (value) {
        setState(() {
          _effectConfiguration = _effectConfiguration.copyWith(
            particlesPerEmit: value.round(),
          );
        });
      },
      min: 1,
      max: 1001,
    );
  }

  Widget emitDurationSection() {
    return SingleValueSelection(
      value: _effectConfiguration.emitDuration.toDouble(),
      title: "Emit duration",
      onChanged: (value) {
        setState(() {
          _effectConfiguration = _effectConfiguration.copyWith(
            emitDuration: value.round(),
          );
        });
      },
      precision: 4,
      min: 100,
      max: 5000,
    );
  }

  Widget particleDistanceSection() {
    return RangeSelection(
      initialMin: _effectConfiguration.minDistance,
      initialMax: _effectConfiguration.maxDistance,
      min: 100,
      max: 2000,
      title: "Particle distance",
      onChanged: (values) {
        setState(() {
          _effectConfiguration = _effectConfiguration.copyWith(
            minDistance: values.start,
            maxDistance: values.end,
          );
        });
      },
    );
  }

  Widget particleFadeoutProgressSection() {
    return RangeSelection(
      initialMin: _effectConfiguration.minFadeOutThreshold,
      initialMax: _effectConfiguration.maxFadeOutThreshold,
      min: 0,
      max: 1,
      title: "Particle fadeout threshold",
      onChanged: (values) {
        setState(() {
          _effectConfiguration = _effectConfiguration.copyWith(
            minFadeOutThreshold: values.start,
            maxFadeOutThreshold: values.end,
          );
        });
      },
      roundValue: false,
    );
  }

  Widget particleBeginScaleSection() {
    return RangeSelection(
      initialMin: _effectConfiguration.minBeginScale,
      initialMax: _effectConfiguration.maxBeginScale,
      min: 0,
      max: 10,
      divisions: 100,
      title: "Particle begin scale",
      onChanged: (values) {
        setState(() {
          _effectConfiguration = _effectConfiguration.copyWith(
            minBeginScale: values.start,
            maxBeginScale: values.end,
          );
        });
      },
      roundValue: false,
    );
  }

  Widget particleEndScaleSection() {
    return RangeSelection(
      initialMin: _effectConfiguration.minEndScale,
      initialMax: _effectConfiguration.maxEndScale,
      min: 0,
      max: 10,
      divisions: 100,
      title: "Particle end scale",
      onChanged: (values) {
        setState(() {
          _effectConfiguration = _effectConfiguration.copyWith(
            minEndScale: values.start,
            maxEndScale: values.end,
          );
        });
      },
      roundValue: false,
    );
  }

  Widget particleAngleSection() {
    return RangeSelection(
      initialMin: _effectConfiguration.minAngle,
      initialMax: _effectConfiguration.maxAngle,
      min: -180,
      max: 180,
      divisions: 360,
      title: "Particle angle",
      onChanged: (values) {
        setState(() {
          _effectConfiguration = _effectConfiguration.copyWith(
            minAngle: values.start,
            maxAngle: values.end,
          );
        });
      },
      precision: 3,
      roundValue: false,
    );
  }

  Widget trailProgressSection() {
    return SingleValueSelection(
      value: _effectConfiguration.trail.trailProgress,
      title: "Trail Progress",
      onChanged: (value) {
        setState(() {
          final trailWidth = _effectConfiguration.trail is NoTrail ? 0.0 : (_effectConfiguration.trail as StraightTrail).trailWidth;
          _effectConfiguration = _effectConfiguration.copyWith(
            trail: StraightTrail(trailProgress: value, trailWidth: trailWidth),
          );
        });
      },
      roundValue: false,
      precision: 3,
      min: 0.0,
      max: 1.0,
    );
  }

  Widget trailWidthSection() {
    final trailWidth = _effectConfiguration.trail is NoTrail ? 0.0 : (_effectConfiguration.trail as StraightTrail).trailWidth;
    return SingleValueSelection(
      value: trailWidth,
      title: "Trail Width",
      onChanged: (value) {
        setState(() {
          _effectConfiguration = _effectConfiguration.copyWith(
            trail: StraightTrail(trailProgress: _effectConfiguration.trail.trailProgress, trailWidth: value),
          );
        });
      },
      precision: 3,
      min: 0.0,
      max: 10,
    );
  }

  Widget colorSelection() {
    return ColorSelection(onChanged: (color) {
      setState(() {
        _currentParticleColor = color;
      });
    });
  }
}
