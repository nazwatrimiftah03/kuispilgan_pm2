import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/courses.dart';
import '../data/questions.dart';
import '../models/course.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../utils/gamification.dart';
import '../utils/responsive.dart';
import '../widgets/category_card.dart';
import '../widgets/content_wrapper.dart';
import '../widgets/course_card.dart';
import '../widgets/level_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/theme_toggle_button.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> _levels = ['Semua', 'Semester 1-2', 'Semester 3-4', 'Semester 5-6'];

  final _search = TextEditingController();
  String _query = '';
  String _level = 'Semua';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _open(String? category) {
    context.read<QuizProvider>().start(category);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen()));
  }

  int _count(String courseName) =>
      allQuestions.where((q) => q.category == courseName).length;

  List<Course> get _filtered {
    final q = _query.trim().toLowerCase();
    return courses.where((c) {
      final matchQuery = q.isEmpty ||
          c.name.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q);
      final matchLevel = _level == 'Semua' || c.level == _level;
      return matchQuery && matchLevel;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final user = context.watch<AuthProvider>().user!;
    final quiz = context.watch<QuizProvider>();
    final cs = Theme.of(context).colorScheme;

    final history = quiz.historyOf(user.username);
    final level = Gamification.levelFor(Gamification.totalXp(history));
    final average = history.isEmpty
        ? null
        : history.map((h) => h.percent).reduce((a, b) => a + b) / history.length;
    final filtered = _filtered;

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
            LevelCard(
              name: user.fullName,
              level: level,
              quizCount: history.length,
              averagePercent: average,
            ),

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

            SizedBox(height: r.wp(5)),
            CategoryCard(
              icon: Icons.shuffle,
              title: 'Acak Semua Mata Kuliah',
              subtitle: '${allQuestions.length} soal dari ${courses.length} mata kuliah',
              onTap: () => _open(null),
            ),

            SizedBox(height: r.wp(2)),
            Text('Mata Kuliah', style: TextStyle(fontSize: r.sp(4.6), fontWeight: FontWeight.w600)),
            SizedBox(height: r.wp(3)),

            // Pencarian
            TextField(
              controller: _search,
              onChanged: (v) => setState(() => _query = v),
              style: TextStyle(fontSize: r.sp(3.6)),
              decoration: InputDecoration(
                hintText: 'Cari mata kuliah...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _search.clear();
                    setState(() => _query = '');
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(r.wp(4))),
              ),
            ),
            SizedBox(height: r.wp(3)),

            // Filter semester
            Wrap(
              spacing: r.wp(2),
              runSpacing: r.wp(1),
              children: [
                for (final l in _levels)
                  ChoiceChip(
                    label: Text(l, style: TextStyle(fontSize: r.sp(3))),
                    selected: _level == l,
                    onSelected: (_) => setState(() => _level = l),
                  ),
              ],
            ),
            SizedBox(height: r.wp(4)),

            // Grid mata kuliah (Wrap agar tinggi mengikuti isi, tanpa overflow)
            if (filtered.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: r.wp(8)),
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: r.wp(14), color: cs.onSurfaceVariant),
                    SizedBox(height: r.wp(2)),
                    Text(
                      'Mata kuliah tidak ditemukan',
                      style: TextStyle(fontSize: r.sp(3.6), color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final gap = r.wp(3);
                  final cardWidth = ((constraints.maxWidth - gap) / 2).floorToDouble();
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (final c in filtered)
                        SizedBox(
                          width: cardWidth,
                          child: CourseCard(
                            course: c,
                            questionCount: _count(c.name),
                            bestPercent: quiz.bestPercentFor(user.username, c.name),
                            onTap: () => _open(c.name),
                          ),
                        ),
                    ],
                  );
                },
              ),

            if (history.isNotEmpty) ...[
              SizedBox(height: r.wp(6)),
              Text('Riwayat Terbaru', style: TextStyle(fontSize: r.sp(4.6), fontWeight: FontWeight.w600)),
              SizedBox(height: r.wp(2)),
              for (final h in history.take(5))
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.emoji_events, color: AppColors.gold),
                    title: Text(h.category, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: r.sp(3.5))),
                    subtitle: Text(
                      '${h.date.day}/${h.date.month}/${h.date.year}  |  +${Gamification.xpOf(h)} XP',
                      style: TextStyle(fontSize: r.sp(3), color: cs.onSurfaceVariant),
                    ),
                    trailing: Text('${h.score}/${h.total}', style: TextStyle(fontSize: r.sp(4), fontWeight: FontWeight.w700)),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}