extension type Friction(double value) {
  // Private constructor to restrict instantiation
  const Friction._(this.value);

  // Custom value
  factory Friction.custom(double value) => Friction._(value);

  static const  fineAdjustment = 0.0001;
  static const  minorAdjustment = 0.001;
  static const  moderateAdjustment = 0.1;
  static const  majorAdjustment = 0.1;
  static const  coarseAdjustment = 0.5;
  // Predefined friction values
  static const ice = Friction._(0.01);
  static const bananaPeel = Friction._(0.03);
  static const teflon = Friction._(0.04);
  static const oil = Friction._(0.1);
  static const polishedWood = Friction._(0.3);
  static const leather = Friction._(0.5);
  static const steelOnSteel = Friction._(0.6);
  static const rubber = Friction._(0.8);
  static const sandpaper = Friction._(1.5);
  static const ductTape = Friction._(2);
}
