import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/achievements.dart';
import '../utils/responsive.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({super.key});

  static const List<String> _dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  static const Color _fire = Color(0xFFEF6C00);

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    final user = context.watch<AuthProvider>().user;
    if (user == null) return const SizedBox.shrink();

    final quiz = context.watch<QuizProvider>();
    final stats = UserStats.from(quiz.historyOf(user.username));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final playedToday = stats.activeDays.contains(today);
    final last7 = [
      for (int i = 6; i >= 0; i--) DateTime(today.year, today.month, today.day - i),
    ];

    final hint = playedToday
        ? 'Mantap! Streak hari ini aman.'
        : stats.currentStreak > 0
        ? 'Kerjakan 1 kuis hari ini agar streak tidak putus.'
        : 'Mulai satu kuis hari ini untuk memulai streak.';

    return Card(
      child: Padding(
        padding: EdgeInsets.all(r.wp(4)),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  size: r.wp(11),
                  color: stats.currentStreak > 0 ? _fire : cs.outlineVariant,
                ),
                SizedBox(width: r.wp(3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${stats.currentStreak} hari beruntun',
                        style: TextStyle(fontSize: r.sp(4.2), fontWeight: FontWeight.w700),
                      ),
                      Text(hint, style: TextStyle(fontSize: r.sp(2.9), color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
                SizedBox(width: r.wp(2)),
                Column(
                  children: [
                    Text('Terbaik', style: TextStyle(fontSize: r.sp(2.8), color: cs.onSurfaceVariant)),
                    Text('${stats.bestStreak} hr', style: TextStyle(fontSize: r.sp(3.6), fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
            SizedBox(height: r.wp(3)),
            Row(
              children: [
                for (final d in last7)
                  Expanded(
                    child: _DayDot(
                      label: _dayNames[d.weekday - 1],
                      active: stats.activeDays.contains(d),
                      isToday: d == today,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  final String label;
  final bool active;
  final bool isToday;

  const _DayDot({required this.label, required this.active, required this.isToday});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: r.sp(2.7),
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
            color: isToday ? cs.primary : cs.onSurfaceVariant,
          ),
        ),
        SizedBox(height: r.wp(1)),
        Container(
          padding: EdgeInsets.all(r.wp(0.6)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: isToday ? cs.primary : Colors.transparent, width: 2),
          ),
          child: CircleAvatar(
            radius: r.wp(3.6),
            backgroundColor: active ? StreakCard._fire : cs.surfaceContainerHighest,
            child: active ? Icon(Icons.check, size: r.wp(4), color: Colors.white) : null,
          ),
        ),
      ],
    );
  }
}