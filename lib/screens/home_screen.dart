import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/questions.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/category_card.dart';
import '../widgets/content_wrapper.dart';
import '../widgets/primary_button.dart';
import '../widgets/theme_toggle_button.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Map<String, IconData> _icons = {
    'Dasar Komputer': Icons.computer,
    'Pemrograman': Icons.code,
    'Jaringan & Basis Data': Icons.storage,
  };

  void _open(BuildContext context, String? category) {
    context.read<QuizProvider>().start(category);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final user = context.watch<AuthProvider>().user!;
    final quiz = context.watch<QuizProvider>();
    final cs = Theme.of(context).colorScheme;

    final history = quiz.historyOf(user.username);
    final best = history.isEmpty
        ? null
        : history.reduce((a, b) => a.percent >= b.percent ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuis Ilkom'),
        actions: [
          const ThemeToggleButton(),
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<QuizProvider>().reset();
              context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
      body: ContentWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kartu sapaan
            Container(
              padding: EdgeInsets.all(r.wp(5)),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(r.wp(5)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: r.wp(8),
                    backgroundColor: AppColors.gold,
                    child: Text(
                      user.fullName[0].toUpperCase(),
                      style: TextStyle(fontSize: r.sp(6), fontWeight: FontWeight.w700, color: Colors.black87),
                    ),
                  ),
                  SizedBox(width: r.wp(4)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, ${user.fullName}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: r.sp(4.6), fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        SizedBox(height: r.wp(1)),
                        Text(
                          best == null
                              ? 'Belum ada skor. Yuk mulai kuis!'
                              : 'Skor terbaik: ${best.score}/${best.total} (${best.category})',
                          style: TextStyle(fontSize: r.sp(3.1), color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Lanjutkan kuis yang belum selesai
            if (quiz.hasProgress) ...[
              SizedBox(height: r.wp(4)),
              PrimaryButton(
                label: 'Lanjutkan: ${quiz.category}',
                icon: Icons.restore,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizScreen()),
                ),
              ),
            ],

            SizedBox(height: r.wp(6)),
            Text('Pilih Kategori', style: TextStyle(fontSize: r.sp(4.6), fontWeight: FontWeight.w600)),
            SizedBox(height: r.wp(3)),
            CategoryCard(
              icon: Icons.apps,
              title: 'Semua Kategori',
              subtitle: '${allQuestions.length} soal acak',
              onTap: () => _open(context, null),
            ),
            for (final c in categoryNames)
              CategoryCard(
                icon: _icons[c] ?? Icons.quiz,
                title: c,
                subtitle: '${allQuestions.where((q) => q.category == c).length} soal',
                onTap: () => _open(context, c),
              ),

            // Riwayat skor
            if (history.isNotEmpty) ...[
              SizedBox(height: r.wp(3)),
              Text('Riwayat Skor', style: TextStyle(fontSize: r.sp(4.6), fontWeight: FontWeight.w600)),
              SizedBox(height: r.wp(2)),
              for (final h in history)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.emoji_events, color: AppColors.gold),
                    title: Text(h.category, style: TextStyle(fontSize: r.sp(3.5))),
                    subtitle: Text(
                      '${h.date.day}/${h.date.month}/${h.date.year}',
                      style: TextStyle(fontSize: r.sp(3), color: cs.onSurfaceVariant),
                    ),
                    trailing: Text(
                      '${h.score}/${h.total}',
                      style: TextStyle(fontSize: r.sp(4), fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}