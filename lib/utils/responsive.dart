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

  double wp(double percent) => width * percent / 100;

  double hp(double percent) => screenHeight * percent / 100;

  double sp(double percent) => width * percent / 100;
}