import 'package:flutter/material.dart';

class Responsive {
  static const double maxContentWidth = 640;
  static const double tabletBreakpoint = 600;

  final double screenWidth;
  final double screenHeight;
  final double width;

  Responsive(BuildContext context)
      : screenWidth = MediaQuery.sizeOf(context).width,
        screenHeight = MediaQuery.sizeOf(context).height,
        width = MediaQuery.sizeOf(context).width.clamp(0, maxContentWidth).toDouble();

  bool get isTablet => screenWidth >= tabletBreakpoint;
  bool get isLandscape => screenWidth > screenHeight;

  double wp(double percent) {
    final val = width * percent / 100;
    return val > 0 ? val : 1.0;
  }

  double hp(double percent) {
    final val = screenHeight * percent / 100;
    return val > 0 ? val : 1.0;
  }

  double sp(double percent) {
    final val = width * percent / 100;
    // Berikan fallback minimal ukuran teks agar tidak pernah 0 atau negatif
    return val > 0 ? val : 12.0;
  }
}