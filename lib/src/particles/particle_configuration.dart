import 'package:flutter/material.dart';
import 'package:newton/src/particles/shape.dart';

class ParticleConfiguration {
  final Shape shape;
  final Size size;
  final Color color;

  ParticleConfiguration({
    required this.shape,
    required this.size,
    this.color = Colors.black,
  });
}
