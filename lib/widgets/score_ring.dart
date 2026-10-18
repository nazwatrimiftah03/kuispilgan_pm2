import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class ScoreRing extends StatelessWidget {
  final double percent;
  final String label;
  final String caption;
  final Color color;

  const ScoreRing({
    super.key,
    required this.percent,
    required this.label,
    required this.caption,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final size = r.wp(50);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: percent),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: r.wp(3.2),
                  color: color,
                  backgroundColor: color.withAlpha(35),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(r.wp(8)),
                child: FittedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: TextStyle(fontSize: r.sp(10), fontWeight: FontWeight.w700, color: color),
                      ),
                      Text(caption, style: TextStyle(fontSize: r.sp(4))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}