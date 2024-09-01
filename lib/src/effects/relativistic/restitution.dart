extension type const Restitution(double value) implements double {
  // Private constructor to restrict instantiation
  const Restitution._(this.value);

  // Custom value
  factory Restitution.custom(double value) => Restitution._(value);

  static const fineAdjustment = 0.0001;
  static const minorAdjustment = 0.001;
  static const moderateAdjustment = 0.1;
  static const majorAdjustment = 0.1;
  static const coarseAdjustment = 0.5;

  // Predefined values ordered from least bouncy to most bouncy
  static const noBounce = Restitution._(0);
  static const slightlyBouncy = Restitution._(0.1);
  static const rubberBall = Restitution._(0.3);
  static const rubberChicken = Restitution._(0.4);
  static const tennisBall = Restitution._(0.5);
  static const basketball = Restitution._(0.6);
  static const bouncyCastle = Restitution._(0.8);
  static const superBall = Restitution._(0.9);
  static const trampoline = Restitution._(1);
  static const flubber = Restitution._(1.2);
}
