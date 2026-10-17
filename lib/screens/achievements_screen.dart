import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/achievements.dart';
import '../utils/responsive.dart';
import '../widgets/badge_tile.dart';
import '../widgets/content_wrapper.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    final user = context.watch<AuthProvider>().user;
    if (user == null) return const SizedBox.shrink();

    final stats = UserStats.from(context.watch<QuizProvider>().historyOf(user.username));
    final unlocked = achievements.where((a) => a.unlocked(stats)).toList();
    final locked = achievements.where((a) => !a.unlocked(stats)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Lencana')),
      body: ContentWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(r.wp(4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${unlocked.length} dari ${achievements.length} lencana terbuka',
                      style: TextStyle(fontSize: r.sp(3.9), fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: r.wp(2)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(r.wp(2)),
                      child: LinearProgressIndicator(
                        value: unlocked.length / achievements.length,
                        minHeight: r.wp(2.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: r.wp(2)),
            Row(
              children: [
                Expanded(child: _Mini(label: 'Streak saat ini', value: '${stats.currentStreak} hari')),
                SizedBox(width: r.wp(3)),
                Expanded(child: _Mini(label: 'Streak terbaik', value: '${stats.bestStreak} hari')),
              ],
            ),
            SizedBox(height: r.wp(5)),
            if (unlocked.isNotEmpty) ...[
              Text('Terbuka', style: TextStyle(fontSize: r.sp(4.4), fontWeight: FontWeight.w600)),
              SizedBox(height: r.wp(2)),
              for (final a in unlocked) BadgeTile(achievement: a, stats: stats),
            ],
            if (locked.isNotEmpty) ...[
              SizedBox(height: r.wp(2)),
              Text('Belum terbuka', style: TextStyle(fontSize: r.sp(4.4), fontWeight: FontWeight.w600, color: cs.onSurfaceVariant)),
              SizedBox(height: r.wp(2)),
              for (final a in locked) BadgeTile(achievement: a, stats: stats),
            ],
          ],
        ),
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  final String label;
  final String value;
  const _Mini({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: r.wp(3), horizontal: r.wp(3)),
        child: Column(
          children: [
            Icon(Icons.local_fire_department, color: const Color(0xFFEF6C00), size: r.wp(7)),
            Text(value, style: TextStyle(fontSize: r.sp(4), fontWeight: FontWeight.w700)),
            Text(label, style: TextStyle(fontSize: r.sp(2.8), color: cs.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}