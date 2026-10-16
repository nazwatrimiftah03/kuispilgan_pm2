import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Kartu umpan balik yang muncul setelah menjawab pada mode latihan.
class FeedbackCard extends StatelessWidget {
  final bool correct;
  final String explanation;

  const FeedbackCard({super.key, required this.correct, required this.explanation});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final color = correct ? AppColors.success : AppColors.error;

    return Container(
      margin: EdgeInsets.only(bottom: r.wp(3)),
      padding: EdgeInsets.all(r.wp(4)),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(r.wp(4)),
        border: Border.all(color: color.withAlpha(120)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(correct ? Icons.celebration : Icons.lightbulb, color: color, size: r.wp(6)),
              SizedBox(width: r.wp(2)),
              Text(
                correct ? 'Benar!' : 'Kurang tepat',
                style: TextStyle(fontSize: r.sp(4), fontWeight: FontWeight.w700, color: color),
              ),
            ],
          ),
          SizedBox(height: r.wp(2)),
          Text(explanation, style: TextStyle(fontSize: r.sp(3.3))),
        ],
      ),
    );
  }
}