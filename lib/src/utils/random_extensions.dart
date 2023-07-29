import 'dart:math';

extension RandomRange on Random {
  int nextIntRange(int min, int max) {
    if (min == max) {
      return min;
    } else {
      return min + nextInt(max - min);
    }
  }

  double nextDoubleRange(double min, double max) {
    if (min == max) {
      return min;
    } else {
      return min + nextDouble() * (max - min);
    }
  }
}
