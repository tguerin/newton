/// The `Friction` extension type represents a friction coefficient, indicating how much resistance
/// a material or surface provides against motion. The values range from very slippery (like ice)
/// to extremely grippy (like duct tape).
///
/// This extension type implements the `double` interface, making it usable wherever a `double` is expected.
/// It provides several predefined friction values, from the near-frictionless ice to the super sticky duct tape.
///
/// You can also create custom friction values using the `Friction.custom()` factory constructor.
extension type const Friction(double value) implements double {
  /// Creates a custom `Friction` instance with the specified [value].
  ///
  /// The [value] parameter represents the friction coefficient.
  factory Friction.custom(double value) => Friction._(value);

  /// A private constructor used to create predefined `Friction` instances.
  const Friction._(this.value);

  /// A fine adjustment level for friction, representing an increment of `0.0001`.
  static const fineAdjustment = 0.0001;

  /// A minor adjustment level for friction, representing an increment of `0.001`.
  static const minorAdjustment = 0.001;

  /// A moderate adjustment level for friction, representing an increment of `0.01`.
  static const moderateAdjustment = 0.01;

  /// A major adjustment level for friction, representing an increment of `0.1`.
  static const majorAdjustment = 0.1;

  /// A coarse adjustment level for friction, representing an increment of `0.5`.
  static const coarseAdjustment = 0.5;

  /// Represents the near-frictionless surface of ice, with a friction coefficient of `0.01`.
  static const ice = Friction._(0.01);

  /// Represents the notoriously slippery banana peel, with a friction coefficient of `0.03`.
  static const bananaPeel = Friction._(0.03);

  /// Represents the friction of Teflon, with a friction coefficient of `0.04`.
  static const teflon = Friction._(0.04);

  /// Represents the friction of oil, with a friction coefficient of `0.1`.
  static const oil = Friction._(0.1);

  /// Represents the friction of polished wood, with a friction coefficient of `0.3`.
  static const polishedWood = Friction._(0.3);

  /// Represents the friction of leather, with a friction coefficient of `0.5`.
  static const leather = Friction._(0.5);

  /// Represents the friction of steel on steel, with a friction coefficient of `0.6`.
  static const steelOnSteel = Friction._(0.6);

  /// Represents the friction of rubber, with a friction coefficient of `0.8`.
  static const rubber = Friction._(0.8);

  /// Represents the friction of sandpaper, with a friction coefficient of `1.5`.
  static const sandpaper = Friction._(1.5);

  /// Duct tape: the universal solution to everything. When in doubt, just tape it.
  static const ductTape = Friction._(2);
}
