import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/gamification.dart';
import '../utils/responsive.dart';

class LevelCard extends StatelessWidget {
  final String name;
  final PlayerLevel level;
  final int quizCount;
  final double? averagePercent;

  const LevelCard({
    super.key,
    required this.name,
    required this.level,
    required this.quizCount,
    required this.averagePercent,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final avgText = averagePercent == null ? '-' : '${(averagePercent! * 100).round()}%';

    return Container(
      padding: EdgeInsets.all(r.wp(5)),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(r.wp(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: r.wp(7),
                backgroundColor: AppColors.gold,
                child: Text(
                  name[0].toUpperCase(),
                  style: TextStyle(fontSize: r.sp(5.5), fontWeight: FontWeight.w700, color: Colors.black87),
                ),
              ),
              SizedBox(width: r.wp(4)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, $name',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: r.sp(4.4), fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    Text(
                      'Level ${level.level} - ${level.title}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: r.sp(3.2), color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: r.wp(4)),
          ClipRRect(
            borderRadius: BorderRadius.circular(r.wp(2)),
            child: LinearProgressIndicator(
              value: level.progress,
              minHeight: r.wp(2.5),
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(AppColors.gold),
            ),
          ),
          SizedBox(height: r.wp(1.5)),
          Text(
            '${level.xpInLevel}/${PlayerLevel.xpPerLevel} XP - ${level.xpToNext} XP lagi ke level berikutnya',
            style: TextStyle(fontSize: r.sp(2.8), color: Colors.white70),
          ),
          SizedBox(height: r.wp(4)),
          Row(
            children: [
              Expanded(child: _Stat(label: 'Kuis selesai', value: '$quizCount')),
              Expanded(child: _Stat(label: 'Rata-rata', value: avgText)),
              Expanded(child: _Stat(label: 'Total XP', value: '${level.xp}')),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: r.sp(4.6), fontWeight: FontWeight.w700, color: Colors.white)),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: r.sp(2.8), color: Colors.white70),
        ),
      ],
    );
  }
}