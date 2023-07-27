import 'package:flutter/material.dart';

extension TextThemeExtension on State {
  TextTheme get textTheme {
    return Theme.of(context).textTheme;
  }
}
