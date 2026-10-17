import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Bintang 0-3 untuk penilaian hasil kuis.
class StarRating extends StatelessWidget {
  final int stars;
  const StarRating({super.key, required this.stars});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 3; i++)
          Icon(
            i < stars ? Icons.star_rounded : Icons.star_border_rounded,
            color: AppColors.gold,
            size: r.wp(11),
          ),
      ],
    );
  }
}