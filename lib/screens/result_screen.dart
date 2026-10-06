import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/content_wrapper.dart';
import '../widgets/primary_button.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final quiz = context.watch<QuizProvider>();
    final user = context.watch<AuthProvider>().user!;
    final cs = Theme.of(context).colorScheme;

    final percent = quiz.total == 0 ? 0.0 : quiz.score / quiz.total;
    final message = percent >= 0.8
        ? 'Luar biasa! Kamu jago ilmu komputer!'
        : percent >= 0.5
        ? 'Bagus! Terus belajar ya.'
        : 'Ayo coba lagi, pasti bisa!';

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hasil Kuis'),
          automaticallyImplyLeading: false,
        ),
        body: ContentWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.emoji_events, size: r.wp(24), color: AppColors.gold),
              Text(
                user.fullName,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: r.sp(5.3), fontWeight: FontWeight.w700),
              ),
              SizedBox(height: r.wp(2)),
              Text(
                '${quiz.score} / ${quiz.total}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: r.sp(12), fontWeight: FontWeight.w700, color: cs.primary),
              ),
              Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: r.sp(3.7))),
              SizedBox(height: r.wp(6)),
              Text('Pembahasan', style: TextStyle(fontSize: r.sp(4.5), fontWeight: FontWeight.w600)),
              SizedBox(height: r.wp(2)),
              for (int i = 0; i < quiz.total; i++) _ReviewCard(index: i),
              SizedBox(height: r.wp(3)),
              PrimaryButton(
                label: 'Kembali ke Beranda',
                icon: Icons.home,
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
            if (!correct && chosen != null)
              Text(
                'Jawabanmu: ${q.options[chosen]}',
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