import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../utils/gamification.dart';
import '../utils/responsive.dart';
import '../widgets/content_wrapper.dart';
import '../widgets/primary_button.dart';
import '../widgets/score_ring.dart';
import '../widgets/star_rating.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _onlyWrong = false;

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final quiz = context.watch<QuizProvider>();
    final user = context.watch<AuthProvider>().user!;
    final cs = Theme.of(context).colorScheme;

    final percent = quiz.total == 0 ? 0.0 : quiz.score / quiz.total;
    final stars = percent >= 0.8 ? 3 : percent >= 0.6 ? 2 : percent >= 0.4 ? 1 : 0;
    final ringColor = percent >= 0.8
        ? AppColors.success
        : percent >= 0.5
        ? AppColors.gold
        : AppColors.error;
    final message = percent >= 0.8
        ? 'Luar biasa! Kamu jago ilmu komputer!'
        : percent >= 0.5
        ? 'Bagus! Terus belajar ya.'
        : 'Ayo coba lagi, pasti bisa!';

    final wrong = <int>[
      for (int i = 0; i < quiz.total; i++)
        if (quiz.answers[i] != quiz.questions[i].answerIndex) i,
    ];
    final shown = _onlyWrong ? wrong : List<int>.generate(quiz.total, (i) => i);

    final xpText = quiz.isRetry || quiz.history.isEmpty
        ? 'Mode ulangi tidak menambah XP'
        : '+${Gamification.xpOf(quiz.history.first)} XP';

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(quiz.isRetry ? 'Hasil Ulangi Soal' : 'Hasil Kuis'),
          automaticallyImplyLeading: false,
        ),
        body: ContentWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                user.fullName,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: r.sp(5), fontWeight: FontWeight.w700),
              ),
              Text(
                quiz.category,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: r.sp(3.3), color: cs.onSurfaceVariant),
              ),
              SizedBox(height: r.wp(4)),
              Center(
                child: ScoreRing(
                  percent: percent,
                  label: '${quiz.score}/${quiz.total}',
                  caption: '${(percent * 100).round()}%',
                  color: ringColor,
                ),
              ),
              SizedBox(height: r.wp(3)),
              StarRating(stars: stars),
              SizedBox(height: r.wp(2)),
              Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: r.sp(3.7))),
              SizedBox(height: r.wp(2)),
              Center(
                child: Chip(
                  avatar: const Icon(Icons.bolt, color: AppColors.gold),
                  label: Text(xpText, style: TextStyle(fontSize: r.sp(3.2))),
                ),
              ),
              SizedBox(height: r.wp(5)),

              Text('Pembahasan', style: TextStyle(fontSize: r.sp(4.5), fontWeight: FontWeight.w600)),
              SizedBox(height: r.wp(2)),
              Wrap(
                spacing: r.wp(2),
                children: [
                  ChoiceChip(
                    label: Text('Semua (${quiz.total})', style: TextStyle(fontSize: r.sp(3.1))),
                    selected: !_onlyWrong,
                    onSelected: (_) => setState(() => _onlyWrong = false),
                  ),
                  ChoiceChip(
                    label: Text('Salah (${wrong.length})', style: TextStyle(fontSize: r.sp(3.1))),
                    selected: _onlyWrong,
                    onSelected: (_) => setState(() => _onlyWrong = true),
                  ),
                ],
              ),
              SizedBox(height: r.wp(3)),
              if (shown.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: r.wp(6)),
                  child: Text(
                    'Tidak ada jawaban yang salah. Sempurna!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: r.sp(3.5), color: AppColors.success),
                  ),
                )
              else
                for (final i in shown) _ReviewCard(index: i),

              SizedBox(height: r.wp(3)),
              if (wrong.isNotEmpty) ...[
                PrimaryButton(
                  label: 'Ulangi ${wrong.length} soal yang salah',
                  icon: Icons.replay,
                  onPressed: () {
                    context.read<QuizProvider>().retryWrong();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizScreen()),
                    );
                  },
                ),
                SizedBox(height: r.wp(3)),
              ],
              PrimaryButton(
                label: 'Kembali ke Beranda',
                icon: Icons.home,
                outlined: wrong.isNotEmpty,
                onPressed: () {
                  context.read<QuizProvider>().reset();
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final int index;
  const _ReviewCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final quiz = context.watch<QuizProvider>();
    final q = quiz.questions[index];
    final chosen = quiz.answers[index];
    final correct = chosen == q.answerIndex;
    final color = correct ? AppColors.success : AppColors.error;

    return Card(
      margin: EdgeInsets.only(bottom: r.wp(3)),
      child: Padding(
        padding: EdgeInsets.all(r.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(correct ? Icons.check_circle : Icons.cancel, color: color, size: r.wp(6)),
                SizedBox(width: r.wp(3)),
                Expanded(
                  child: Text(
                    q.text,
                    style: TextStyle(fontSize: r.sp(3.5), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(height: r.wp(2)),
            if (!correct)
              Text(
                chosen == null ? 'Jawabanmu: (tidak dijawab)' : 'Jawabanmu: ${q.options[chosen]}',
                style: TextStyle(fontSize: r.sp(3.1), color: AppColors.error),
              ),
            Text(
              'Jawaban benar: ${q.options[q.answerIndex]}',
              style: TextStyle(fontSize: r.sp(3.1), color: AppColors.success, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: r.wp(1)),
            Text(q.explanation, style: TextStyle(fontSize: r.sp(3))),
          ],
        ),
      ),
    );
  }
}