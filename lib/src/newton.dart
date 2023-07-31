library newton;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:newton_particles/src/effects/effect.dart';
import 'package:newton_particles/src/newton_painter.dart';

class Newton extends StatefulWidget {
  final List<Effect> activeEffects;

  const Newton({this.activeEffects = const [], super.key});

  @override
  State<Newton> createState() => NewtonState();
}

class NewtonState extends State<Newton> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  int _lastElapsedMillis = 0;
  final List<Effect> _activeEffects = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _activeEffects.addAll(widget.activeEffects);
    _ticker = createTicker((elapsed) {
      _activeEffects.removeWhere((effect) => effect.isDead);
      if(_activeEffects.isNotEmpty) {
        for (var element in _activeEffects) {
          element.forward(elapsed.inMilliseconds - _lastElapsedMillis);
        }
        _lastElapsedMillis = elapsed.inMilliseconds;
        setState(() {});
      }
    });
    _ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      for (var effect in _activeEffects) {
        effect.surfaceSize = constraints.biggest;
      }
      return CustomPaint(
        painter: NewtonPainter(
          effects: _activeEffects,
        ),
      );
    });
  }

  addEffect(Effect effect) {
    setState(() {
      effect.surfaceSize = MediaQuery.of(context).size;
      _activeEffects.add(effect);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _ticker.stop();
  }

  void clearEffects() {
    _activeEffects.clear();
  }

  @override
  void didUpdateWidget(Newton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _activeEffects.clear();
    _activeEffects.addAll(widget.activeEffects);
  }
}
