enum ColorType {
  single("Single color"),
  linearInterpolation("Linear interpolation");

  const ColorType(this.label);

  final String label;

  static ColorType of(String label) {
    return ColorType.values.firstWhere((effect) => effect.label == label);
  }
}
