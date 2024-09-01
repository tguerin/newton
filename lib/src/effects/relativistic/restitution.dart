/// The `Restitution` extension type represents a restitution value, often referred to as the "bounciness"
/// of a material, on a scale from `0` (no bounce) to values greater than `1` (hyper-bouncy).
///
/// This extension type implements the `double` interface, making it usable wherever a `double` is expected.
/// It provides several predefined restitution values, ranging from no bounce at all to the legendary
/// bounciness of Flubber.
///
/// You can also create custom restitution values using the `Restitution.custom()` factory constructor.
///
/// Example usage:
///
/// ```dart
/// final r1 = Restitution.basketball;
/// final r2 = Restitution.custom(0.75);
/// print('Restitution: ${r1.value}'); // Output: Restitution: 0.6
/// print('Custom Restitution: ${r2.value}'); // Output: Custom Restitution: 0.75
/// ```
extension type const Restitution(double value) implements double {
  /// Creates a custom `Restitution` instance with the specified [value].
  ///
  /// The [value] parameter represents the restitution (bounciness).
  factory Restitution.custom(double value) => Restitution._(value);

  /// A private constructor used to create predefined `Restitution` instances.
  const Restitution._(this.value);

  /// A fine adjustment level for restitution, representing an increment of `0.0001`.
  static const fineAdjustment = 0.0001;

  /// A minor adjustment level for restitution, representing an increment of `0.001`.
  static const minorAdjustment = 0.001;

  /// A moderate adjustment level for restitution, representing an increment of `0.01`.
  static const moderateAdjustment = 0.01;

  /// A major adjustment level for restitution, representing an increment of `0.1`.
  static const majorAdjustment = 0.1;

  /// A coarse adjustment level for restitution, representing an increment of `0.5`.
  static const coarseAdjustment = 0.5;

  /// Represents no bounce at all, with a restitution value of `0`.
  static const noBounce = Restitution._(0);

  /// Represents a slightly bouncy material, with a restitution value of `0.1`.
  static const slightlyBouncy = Restitution._(0.1);

  /// Represents the bounce of a rubber ball, with a restitution value of `0.3`.
  static const rubberBall = Restitution._(0.3);

  /// Represents the bounce of a rubber chicken, with a restitution value of `0.4`.
  static const rubberChicken = Restitution._(0.4);

  /// Represents the bounce of a tennis ball, with a restitution value of `0.5`.
  static const tennisBall = Restitution._(0.5);

  /// Represents the bounce of a basketball, with a restitution value of `0.6`.
  static const basketball = Restitution._(0.6);

  /// Represents the bounce of a bouncy castle, with a restitution value of `0.8`.
  static const bouncyCastle = Restitution._(0.8);

  /// Represents the super-bouncy properties of a super ball, with a restitution value of `0.9`.
  static const superBall = Restitution._(0.9);

  /// Represents the elasticity of a trampoline, with a restitution value of `1`.
  static const trampoline = Restitution._(1);

  /// If you thought trampolines were fun, wait until you try Flubber. Just be careful—things might bounce
  /// so high they enter orbit! Warning: Not actually safe for real-world use (or movies).
  static const flubber = Restitution._(1.2);
}
