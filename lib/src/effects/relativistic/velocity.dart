/// The `Velocity` extension type represents a velocity value in meters per second (m/s)
/// and provides various predefined constants and adjustment levels for common velocities.
///
/// This extension type implements the `double` interface, allowing it to be used in any context
/// where a `double` is expected. It provides several predefined velocities, ranging from the
/// stationary state to the speed of light and beyond.
///
/// You can also create custom velocity values using the `Velocity.custom()` factory constructor.
extension type const Velocity(double value) implements double {
  /// Creates a custom `Velocity` instance with the specified [value] in meters per second (m/s).
  ///
  /// The [value] parameter represents the velocity in m/s.
  factory Velocity.custom(double value) => Velocity._(value);

  /// A private constructor used to create predefined `Velocity` instances.
  const Velocity._(this.value);

  /// A fine adjustment level for velocity, representing an increment of `0.01 m/s`.
  static const fineAdjustment = 0.01;

  /// A minor adjustment level for velocity, representing an increment of `0.1 m/s`.
  static const minorAdjustment = 0.1;

  /// A moderate adjustment level for velocity, representing an increment of `1.0 m/s`.
  static const moderateAdjustment = 1.0;

  /// A major adjustment level for velocity, representing an increment of `10.0 m/s`.
  static const majorAdjustment = 10.0;

  /// A coarse adjustment level for velocity, representing an increment of `100.0 m/s`.
  static const coarseAdjustment = 100.0;

  /// Represents a stationary state with a velocity of `0 m/s`.
  static const stationary = Velocity._(0);

  /// Represents the velocity of a snail, approximately `0.013 m/s`.
  static const snail = Velocity._(0.013);

  /// Represents the average walking speed of a human, approximately `1.4 m/s`.
  static const walking = Velocity._(1.4);

  /// Represents the average running speed of a human, approximately `5 m/s`.
  static const running = Velocity._(5);

  /// Represents the average speed of a cyclist, approximately `7 m/s`.
  static const cycling = Velocity._(7);

  /// Represents the velocity of a raindrop falling, approximately `8 m/s`.
  static const rainDrop = Velocity._(8);

  /// Represents the average speed of a car on a highway, approximately `27.78 m/s`.
  ///
  /// This corresponds to a speed of 100 km/h.
  static const car = Velocity._(27.78);

  /// Represents the top speed of a cheetah, approximately `30 m/s`.
  static const cheetah = Velocity._(30);

  /// Represents a high-speed highway velocity, approximately `33.33 m/s`.
  ///
  /// This corresponds to a speed of 120 km/h, often the speed limit on highways.
  static const highway = Velocity._(33.33);

  /// Represents the speed of sound at sea level, approximately `343 m/s`.
  ///
  /// This is the velocity at which sound travels in air under standard conditions.
  static const sound = Velocity._(343);

  /// Represents the top speed of the Concorde aircraft, approximately `588 m/s`.
  static const concorde = Velocity._(588);

  /// Represents a hypersonic speed, approximately `17,150 m/s`.
  ///
  /// This is the velocity associated with re-entry of spacecraft into Earth's atmosphere (Mach 25).
  static const hypersonic = Velocity._(17150);

  /// Represents the speed of light in a vacuum, approximately `299,792,458 m/s`.
  static const light = Velocity._(299792458);

  /// Represents the fictional speed of the superhero The Flash, approximately `599,584,916 m/s`.
  static const theFlash = Velocity._(299792458.0 * 2);

  /// Perfect for when you need a speed that matches your Monday morning motivation.
  static const procrastination = Velocity._(-0.01);
}
