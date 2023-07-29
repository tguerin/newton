import 'package:example/available_effect.dart';
import 'package:example/range_selection.dart';
import 'package:example/single_value_selection.dart';
import 'package:example/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:newton/newton.dart';

void main() {
  runApp(const NewtonExampleApp());
}

class NewtonExampleApp extends StatelessWidget {
  const NewtonExampleApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const Map<int, Color> _primaryColor = {
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
          _primaryColor,
        ),
        canvasColor: const Color(0xff1b1b1d),
      ),
      home: const NewtonConfigurationPage(),
    );
  }
}

class NewtonConfigurationPage extends StatefulWidget {
  const NewtonConfigurationPage({super.key});

  @override
  State<NewtonConfigurationPage> createState() =>
      _NewtonConfigurationPageState();
}

class _NewtonConfigurationPageState extends State<NewtonConfigurationPage> {
  final _scrollController = ScrollController();

  AvailableEffect _selectedAnimation = AvailableEffect.rain;
  int _particlesPerEmit = 1;
  int _emitDuration = 100;
  int _particleMinDuration = 4000;
  int _particleMaxDuration = 7000;
  double _particleMinDistance = 100;
  double _particleMaxDistance = 200;
  double _particleMinFadeOutThreshold = 0.6;
  double _particleMaxFadeOutThreshold = 0.8;
  double _particleMinBeginScale = 1;
  double _particleMaxBeginScale = 1;
  double _particleMinEndScale = 1;
  double _particleMaxEndScale = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Newton(
            activeEffects: [currentActiveEffect()],
          ),
          configurationSection()
        ],
      ),
    );
  }

  Effect currentActiveEffect() {
    final size = MediaQuery.of(context).size;
    return _selectedAnimation.instantiate(
      size: size,
      particlesPerEmit: _particlesPerEmit,
      emitDuration: _emitDuration,
      particleMinDuration: _particleMinDuration,
      particleMaxDuration: _particleMaxDuration,
      particleMinDistance: _particleMinDistance,
      particleMaxDistance: _particleMaxDistance,
      particleMinFadeOutThreshold: _particleMinFadeOutThreshold,
      particleMaxFadeOutThreshold: _particleMaxFadeOutThreshold,
      particleMinBeginScale: _particleMinBeginScale,
      particleMaxBeginScale: _particleMaxBeginScale,
      particleMinEndScale: _particleMinEndScale,
      particleMaxEndScale: _particleMaxEndScale,
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
              particlesPerEmitSection(),
              emitDurationSection(),
              animationDurationSection(),
              if (_selectedAnimation
                  .supportParameter(AnimationParameter.distance))
                particleDistanceSection(),
              if (_selectedAnimation
                  .supportParameter(AnimationParameter.fadeout))
                particleFadeoutProgressSection(),
              particleBeginScaleSection(),
              particleEndScaleSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget animationSelectionSection(
      {required AvailableEffect defaultAnimation}) {
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
            });
          },
          items: AvailableEffect.values
              .map<DropdownMenuItem<String>>((AvailableEffect value) {
            return DropdownMenuItem<String>(
              value: value.label,
              child: Text(value.label),
            );
          }).toList(),
        ));
  }

  Widget animationDurationSection() {
    return RangeSelection(
      initialMin: _particleMinDuration.toDouble(),
      initialMax: _particleMaxDuration.toDouble(),
      min: 100,
      max: 8000,
      title: "Animation duration",
      onChanged: (values) {
        setState(() {
          _particleMinDuration = values.start.round();
          _particleMaxDuration = values.end.round();
        });
      },
    );
  }

  Widget particlesPerEmitSection() {
    return SingleValueSelection(
      value: _particlesPerEmit.toDouble(),
      title: "Particles per emit",
      onChanged: (value) {
        setState(() {
          _particlesPerEmit = value.round();
        });
      },
      min: 1,
      max: 100,
    );
  }

  Widget emitDurationSection() {
    return SingleValueSelection(
      value: _emitDuration.toDouble(),
      title: "Emit duration",
      onChanged: (value) {
        setState(() {
          _emitDuration = value.round();
        });
      },
      min: 100,
      max: 5000,
    );
  }

  Widget particleDistanceSection() {
    return RangeSelection(
      initialMin: _particleMinDistance,
      initialMax: _particleMaxDistance,
      min: 100,
      max: 2000,
      title: "Particle distance",
      onChanged: (values) {
        setState(() {
          _particleMinDistance = values.start;
          _particleMaxDistance = values.end;
        });
      },
    );
  }

  Widget particleFadeoutProgressSection() {
    return RangeSelection(
      initialMin: _particleMinFadeOutThreshold,
      initialMax: _particleMaxFadeOutThreshold,
      min: 0,
      max: 1,
      title: "Particle fadeout threshold",
      onChanged: (values) {
        setState(() {
          _particleMinFadeOutThreshold = values.start;
          _particleMaxFadeOutThreshold = values.end;
        });
      },
      roundValue: false,
    );
  }

  Widget particleBeginScaleSection() {
    return RangeSelection(
      initialMin: _particleMinBeginScale,
      initialMax: _particleMaxBeginScale,
      min: 0,
      max: 10,
      divisions: 100,
      title: "Particle begin scale",
      onChanged: (values) {
        setState(() {
          _particleMinBeginScale = values.start;
          _particleMaxBeginScale = values.end;
        });
      },
      roundValue: false,
    );
  }

  Widget particleEndScaleSection() {
    return RangeSelection(
      initialMin: _particleMinEndScale,
      initialMax: _particleMaxEndScale,
      min: 0,
      max: 10,
      divisions: 100,
      title: "Particle end scale",
      onChanged: (values) {
        setState(() {
          _particleMinEndScale = values.start;
          _particleMaxEndScale = values.end;
        });
      },
      roundValue: false,
    );
  }
}
