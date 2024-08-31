import 'package:example/available_effect.dart';
import 'package:example/color_selection.dart';
import 'package:example/range_selection.dart';
import 'package:example/single_value_selection.dart';
import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

void main() {
  runApp(const NewtonExampleApp());
}

class NewtonExampleApp extends StatelessWidget {
  const NewtonExampleApp({super.key});

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
      home: const NewtonConfigurationPage(),
    );
  }
}

class NewtonConfigurationPage extends StatefulWidget {
  const NewtonConfigurationPage({super.key});

  @override
  State<NewtonConfigurationPage> createState() => _NewtonConfigurationPageState();
}

class _NewtonConfigurationPageState extends State<NewtonConfigurationPage> {
  final _scrollController = ScrollController();

  AvailableEffect _selectedAnimation = AvailableEffect.explode;
  EffectConfiguration _effectConfiguration = defaultEffectConfigurationsPerAnimation[AvailableEffect.explode]!;
  ParticleColor _currentParticleColor = const SingleParticleColor(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Newton(
            effectConfigurations: [currentActiveEffectConfiguration()],
            onEffectStateChanged: (effect, state) => {},
          ),
          configurationSection(),
        ],
      ),
    );
  }

  EffectConfiguration<ParticleConfiguration> currentActiveEffectConfiguration() {
    return _effectConfiguration.copyWith(
        particleConfiguration: _effectConfiguration.particleConfiguration.copyWith(color: _currentParticleColor));
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
              if (_selectedAnimation.supportParameter(AnimationParameter.trail)) ...[
                trailWidthSection(),
                trailProgressSection(),
              ],
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
            _effectConfiguration = defaultEffectConfigurationsPerAnimation[_selectedAnimation]!;
          });
        },
        items: AvailableEffect.values.map<DropdownMenuItem<String>>((AvailableEffect value) {
          return DropdownMenuItem<String>(
            value: value.label,
            child: Text(value.label),
          );
        }).toList(),
      ),
    );
  }

  Widget animationDurationSection() {
    return RangeSelection(
      initialMin: _effectConfiguration.minDuration.inMilliseconds.toDouble(),
      initialMax: _effectConfiguration.maxDuration.inMilliseconds.toDouble(),
      min: 100,
      max: 8000,
      title: 'Animation duration',
      onChanged: (values) {
        setState(() {
          _effectConfiguration = _effectConfiguration.copyWith(
            minDuration: Duration(milliseconds: values.start.round()),
            maxDuration: Duration(milliseconds: values.end.round()),
          );
        });
      },
    );
  }

  Widget particlesPerEmitSection() {
    return SingleValueSelection(
      value: _effectConfiguration.particlesPerEmit.toDouble(),
      title: 'Particles per emit',
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
      value: _effectConfiguration.emitDuration.inMilliseconds.toDouble(),
      title: 'Emit duration',
      onChanged: (value) {
        setState(() {
          _effectConfiguration = _effectConfiguration.copyWith(
            emitDuration: Duration(milliseconds: value.round()),
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
      initialMin: (_effectConfiguration as DeterministicEffectConfiguration).minDistance,
      initialMax: (_effectConfiguration as DeterministicEffectConfiguration).maxDistance,
      min: 100,
      max: 2000,
      title: 'Particle distance',
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
      title: 'Particle fadeout threshold',
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
      title: 'Particle begin scale',
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
      title: 'Particle end scale',
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
      title: 'Particle angle',
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
      title: 'Trail Progress',
      onChanged: (value) {
        setState(() {
          final trailWidth =
              _effectConfiguration.trail is NoTrail ? 0.0 : (_effectConfiguration.trail as StraightTrail).trailWidth;
          _effectConfiguration = _effectConfiguration.copyWith(
            trail: StraightTrail(trailProgress: value, trailWidth: trailWidth),
          );
        });
      },
      roundValue: false,
      precision: 3,
      min: 0,
      max: 1,
    );
  }

  Widget trailWidthSection() {
    final trailWidth =
        _effectConfiguration.trail is NoTrail ? 0.0 : (_effectConfiguration.trail as StraightTrail).trailWidth;
    return SingleValueSelection(
      value: trailWidth,
      title: 'Trail Width',
      onChanged: (value) {
        setState(() {
          _effectConfiguration = _effectConfiguration.copyWith(
            trail: StraightTrail(trailProgress: _effectConfiguration.trail.trailProgress, trailWidth: value),
          );
        });
      },
      precision: 3,
      min: 0,
      max: 10,
    );
  }

  Widget colorSelection() {
    return ColorSelection(
      onChanged: (color) {
        setState(() {
          _currentParticleColor = color;
        });
      },
    );
  }
}
