/// The `Density` extension type represents the density of various materials and substances,
/// expressed in kilograms per square meter (kg/m²).
///
/// This extension type implements the `double` interface, allowing it to be used in any context
/// where a `double` is expected. It provides predefined density values for a wide range of
/// materials, from the lightest gases to hypothetical celestial objects.
///
/// You can also create custom density values using the `Density.custom()` factory constructor.
extension type const Density(double value) implements double {
  /// Creates a custom `Density` instance with the specified [value].
  ///
  /// The [value] parameter represents the density in kilograms per square meter (kg/m²).
  factory Density.custom(double value) => Density._(value);

  /// A private constructor used to create predefined `Density` instances.
  const Density._(this.value);

  /// A fine adjustment level for density, representing an increment of `0.01 kg/m²`.
  static const fineAdjustment = 0.01;

  /// A minor adjustment level for density, representing an increment of `0.1 kg/m²`.
  static const minorAdjustment = 0.1;

  /// A moderate adjustment level for density, representing an increment of `10 kg/m²`.
  static const moderateAdjustment = 10.0;

  /// A major adjustment level for density, representing an increment of `100 kg/m²`.
  static const majorAdjustment = 100.0;

  /// A coarse adjustment level for density, representing an increment of `1000 kg/m²`.
  static const coarseAdjustment = 1000.0;

  /// Default density, `1 kg/m²`
  static const defaultDensity = Density(1);
}
