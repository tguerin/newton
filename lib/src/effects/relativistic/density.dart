extension type Density(double value) {
  // Private constructor to restrict instantiation
  const Density._(this.value);

  // Custom value
  factory Density.custom(double value) => Density._(value);

  static const fineAdjustment = 0.00001;
  static const minorAdjustment = 0.0001;
  static const moderateAdjustment = 0.01;
  static const majorAdjustment = 0.1;
  static const coarseAdjustment = 1.0;

  // Predefined values ordered from lightest to heaviest
  static const hydrogen = Density._(0.00009);
  static const helium = Density._(0.00018);
  static const saturnClouds = Density._(0.0006);
  static const air = Density._(0.001);
  static const cottonCandy = Density._(0.002); // Fluffy and light
  static const marshmallow = Density._(0.005); // Squishy and light
  static const venusianAtmosphere = Density._(0.065);
  static const styrofoam = Density._(0.05);
  static const woodBalsa = Density._(0.16);
  static const cork = Density._(0.24);
  static const ethylAlcohol = Density._(0.79);
  static const oliveOil = Density._(0.92);
  static const ice = Density._(0.92);
  static const humanFat = Density._(0.9);
  static const water = Density._(1);
  static const seaWater = Density._(1.03);
  static const milk = Density._(1.03);
  static const blood = Density._(1.06);
  static const humanMuscle = Density._(1.06);
  static const rubber = Density._(1.2);
  static const plastic = Density._(1.4);
  static const bone = Density._(1.85);
  static const sandstone = Density._(2.2);
  static const concrete = Density._(2.4);
  static const glass = Density._(2.6);
  static const aluminum = Density._(2.7);
  static const limestone = Density._(2.7);
  static const granite = Density._(2.75);
  static const moonRock = Density._(3.34);
  static const meteorite = Density._(3.5);
  static const martianSoil = Density._(3.93);
  static const iron = Density._(7.8);
  static const brass = Density._(8.4);
  static const copper = Density._(8.96);
  static const lead = Density._(11.3);
  static const mercury = Density._(13.6);
  static const uranium = Density._(18.95);
  static const depletedUranium = Density._(19.05);
  static const gold = Density._(19.3);
  static const platinum = Density._(21.45);
  static const iridium = Density._(22.56);
  static const osmium = Density._(22.59);
  static const jupiterCore = Density._(25); // Hypothetical
  static const whiteDwarfStar = Density._(1000000); // Extremely dense star
  static const neutronStarCore = Density._(400000000000000000); // Ridiculously dense!
  static const blackHoleFragment = Density._(double.infinity); // Super dense and not even measurable!
}
