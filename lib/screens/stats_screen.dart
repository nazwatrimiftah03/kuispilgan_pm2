import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/courses.dart';
import '../models/course.dart';
import '../models/question.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../utils/gamification.dart';
import '../utils/responsive.dart';
import '../widgets/content_wrapper.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  double _avg(List<ScoreEntry> l) =>
      l.map((e) => e.percent).reduce((a, b) => a + b) / l.length;

  Future<void> _confirmClear(BuildContext context, String username) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus riwayat?'),
        content: const Text('Semua riwayat skor akunmu akan dihapus dan level kembali ke awal.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<QuizProvider>().clearHistory(username);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final user = context.watch<AuthProvider>().user;
    if (user == null) return const SizedBox.shrink();
    final quiz = context.watch<QuizProvider>();
    final cs = Theme.of(context).colorScheme;

    final history = quiz.historyOf(user.username);
    final level = Gamification.levelFor(Gamification.totalXp(history));

    // Statistik per mata kuliah
    final perCourse = <Course, List<ScoreEntry>>{};
    for (final c in courses) {
      perCourse[c] = history.where((h) => h.category == c.name).toList();
    }
    final attempted = perCourse.entries.where((e) => e.value.isNotEmpty).toList();

    MapEntry<Course, List<ScoreEntry>>? strongest;
    MapEntry<Course, List<ScoreEntry>>? weakest;
    if (attempted.length >= 2) {
      strongest = attempted.reduce((a, b) => _avg(a.value) >= _avg(b.value) ? a : b);
      weakest = attempted.reduce((a, b) => _avg(a.value) <= _avg(b.value) ? a : b);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      body: ContentWrapper(
        child: history.isEmpty
            ? Padding(
          padding: EdgeInsets.symmetric(vertical: r.wp(20)),
          child: Column(
            children: [
              Icon(Icons.bar_chart, size: r.wp(20), color: cs.onSurfaceVariant),
              SizedBox(height: r.wp(3)),
              Text(
                'Belum ada data.\nSelesaikan satu kuis untuk melihat statistikmu.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: r.sp(3.6), color: cs.onSurfaceVariant),
              ),
            ],
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: _SummaryTile(icon: Icons.quiz, label: 'Kuis', value: '${history.length}')),
                SizedBox(width: r.wp(3)),
                Expanded(
                  child: _SummaryTile(
                    icon: Icons.percent,
                    label: 'Rata-rata',
                    value: '${(_avg(history) * 100).round()}%',
                  ),
                ),
                SizedBox(width: r.wp(3)),
                Expanded(child: _SummaryTile(icon: Icons.bolt, label: 'Level', value: '${level.level}')),
              ],
            ),
            if (strongest != null && weakest != null) ...[
              SizedBox(height: r.wp(4)),
              _Insight(
                icon: Icons.trending_up,
                color: AppColors.success,
                title: 'Paling kamu kuasai',
                text: '${strongest.key.name} (${(_avg(strongest.value) * 100).round()}%)',
              ),
              SizedBox(height: r.wp(2)),
              _Insight(
                icon: Icons.fitness_center,
                color: AppColors.gold,
                title: 'Perlu lebih banyak latihan',
                text: '${weakest.key.name} (${(_avg(weakest.value) * 100).round()}%)',
              ),
            ],
            SizedBox(height: r.wp(6)),
            Text('Per Mata Kuliah', style: TextStyle(fontSize: r.sp(4.6), fontWeight: FontWeight.w600)),
            SizedBox(height: r.wp(3)),
            for (final e in perCourse.entries) _CourseStat(course: e.key, entries: e.value),
            SizedBox(height: r.wp(4)),
            OutlinedButton.icon(
              onPressed: () => _confirmClear(context, user.username),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Hapus Riwayat'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _SummaryTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: r.wp(4)),
        child: Column(
          children: [
            Icon(icon, color: cs.primary, size: r.wp(7)),
            SizedBox(height: r.wp(1)),
            Text(value, style: TextStyle(fontSize: r.sp(5.5), fontWeight: FontWeight.w700)),
            Text(label, style: TextStyle(fontSize: r.sp(3), color: cs.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _Insight extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String text;
  const _Insight({required this.icon, required this.color, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Container(
      padding: EdgeInsets.all(r.wp(4)),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(r.wp(4)),
        border: Border.all(color: color.withAlpha(120)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: r.wp(7)),
          SizedBox(width: r.wp(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: r.sp(3), fontWeight: FontWeight.w600)),
                Text(text, style: TextStyle(fontSize: r.sp(3.4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseStat extends StatelessWidget {
  final Course course;
  final List<ScoreEntry> entries;
  const _CourseStat({required this.course, required this.entries});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    final tried = entries.isNotEmpty;
    final best = tried ? entries.map((e) => e.percent).reduce((a, b) => a > b ? a : b) : 0.0;

    return Padding(
      padding: EdgeInsets.only(bottom: r.wp(3)),
      child: Row(
        children: [
          CircleAvatar(
            radius: r.wp(5),
            backgroundColor: course.color.withAlpha(40),
            child: Icon(course.icon, color: course.color, size: r.wp(5)),
          ),
          SizedBox(width: r.wp(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: r.sp(3.4), fontWeight: FontWeight.w600),
                ),
                SizedBox(height: r.wp(1)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(r.wp(1)),
                  child: LinearProgressIndicator(
                    value: best,
                    minHeight: r.wp(2),
                    color: course.color,
                    backgroundColor: course.color.withAlpha(35),
                  ),
                ),
                SizedBox(height: r.wp(1)),
                Text(
                  tried ? '${entries.length}x dicoba  |  terbaik ${(best * 100).round()}%' : 'Belum dicoba',
                  style: TextStyle(fontSize: r.sp(2.8), color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}