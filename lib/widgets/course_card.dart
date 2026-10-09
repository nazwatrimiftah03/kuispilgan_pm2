import 'package:flutter/material.dart';
import '../models/course.dart';
import '../utils/responsive.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final int questionCount;
  final double? bestPercent;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.course,
    required this.questionCount,
    required this.bestPercent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final radius = BorderRadius.circular(r.wp(4));
    final dark = Color.alphaBlend(Colors.black.withAlpha(70), course.color);

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [course.color, dark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: radius,
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: SizedBox(
            height: r.wp(42),
            child: Padding(
              padding: EdgeInsets.all(r.wp(3.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(r.wp(2)),
                        decoration: BoxDecoration(color: Colors.white.withAlpha(45), shape: BoxShape.circle),
                        child: Icon(course.icon, color: Colors.white, size: r.wp(6)),
                      ),
                      const Spacer(),
                      if (bestPercent != null)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: r.wp(2), vertical: r.wp(0.8)),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(45),
                            borderRadius: BorderRadius.circular(r.wp(4)),
                          ),
                          child: Text(
                            '${(bestPercent! * 100).round()}%',
                            style: TextStyle(fontSize: r.sp(2.8), fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: r.wp(2)),
                  Expanded(
                    child: Text(
                      course.name,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: r.sp(3.5), fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                  Text('$questionCount soal', style: TextStyle(fontSize: r.sp(2.9), color: Colors.white70)),
                  SizedBox(height: r.wp(1.5)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(r.wp(1)),
                    child: LinearProgressIndicator(
                      value: bestPercent ?? 0,
                      minHeight: r.wp(1.5),
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}