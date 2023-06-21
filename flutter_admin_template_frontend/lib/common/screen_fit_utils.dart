import 'dart:math';

class DesignSize {
  static const double designWidth = 1280;
  static const double designHeight = 720;
}

extension Fitness on num {
  double w(double width, {bool fixMinSize = false}) {
    if (fixMinSize) {
      if (this > width / DesignSize.designWidth * this) {
        return this * 1.0;
      }
    }

    return width / DesignSize.designWidth * this;
  }

  double h(double height, {bool fixMinSize = false}) {
    if (fixMinSize) {
      if (height / DesignSize.designHeight < this) {
        return this * 1.0;
      }
    }
    return height / DesignSize.designHeight * this;
  }

  double size(double height, double width) {
    return min(w(width), h(height));
  }

  double fixMinSize(double min) {
    if (this < min) {
      return min;
    }
    return toDouble();
  }

  /// FIXME
  ///
  /// unnecessary
  double loose() {
    return this - 5.5;
  }
}
