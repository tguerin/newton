extension type Velocity(double value) {
  // Custom value
  factory Velocity.custom(double value) => Velocity._(value);

  // Private constructor to restrict instantiation
  const Velocity._(this.value);

  // Adjustment levels
  static const fineAdjustment = 0.01;
  static const minorAdjustment = 0.1;
  static const moderateAdjustment = 1.0;
  static const majorAdjustment = 10.0;
  static const coarseAdjustment = 100.0;

  // Predefined velocities in meters per second (m/s)
  static const stationary = Velocity._(0);
  static const snail = Velocity._(0.013);
  static const walking = Velocity._(1.4);
  static const running = Velocity._(5);
  static const cycling = Velocity._(7);
  static const rainDrop = Velocity._(8);
  static const cheetah = Velocity._(30);
  static const car = Velocity._(27.78);
  static const highway = Velocity._(33.33);
  static const sound = Velocity._(343);
  static const concorde = Velocity._(588);
  static const hypersonic = Velocity._(17150);
  static const light = Velocity._(299792458);
  static const theFlash = Velocity._(299792458.0 * 2);
  static const ludicrousSpeed = Velocity._(1000000000);
  static const procrastination = Velocity._(-0.01); // Moving backwards (just kidding)
}
