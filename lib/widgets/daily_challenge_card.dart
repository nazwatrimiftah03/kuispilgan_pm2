import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/daily_challenge.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../screens/quiz_screen.dart';
import '../utils/gamification.dart';
import '../utils/responsive.dart';

class DailyChallengeCard extends StatelessWidget {
  const DailyChallengeCard({super.key});

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];
  static const Color _purple = Color(0xFF6A1B9A);

  void _start(BuildContext context, {required bool resume}) {
    if (!resume) {
      context.read<QuizProvider>().startDaily(DailyChallenge.questionsFor(DateTime.now()));
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final user = context.watch<AuthProvider>().user;
    if (user == null) return const SizedBox.shrink();

    final quiz = context.watch<QuizProvider>();
    final now = DateTime.now();
    final done = DailyChallenge.doneEntry(quiz.historyOf(user.username), now);
    final inProgress = quiz.hasProgress && quiz.category == DailyChallenge.category;

    final colors = done != null
        ? const [Color(0xFF546E7A), Color(0xFF37474F)]
        : const [Color(0xFF6A1B9A), Color(0xFFAD1457)];

    return Container(
      padding: EdgeInsets.all(r.wp(4)),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(r.wp(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(done != null ? Icons.event_available : Icons.bolt, color: Colors.white, size: r.wp(8)),
              SizedBox(width: r.wp(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tantangan Harian',
                      style: TextStyle(fontSize: r.sp(4.4), fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    Text(
                      '${now.day} ${_months[now.month - 1]} ${now.year}',
                      style: TextStyle(fontSize: r.sp(3), color: Colors.white70),
                    ),
                  ],
                ),
              ),
              if (done != null) Icon(Icons.check_circle, color: Colors.white, size: r.wp(7)),
            ],
          ),
          SizedBox(height: r.wp(3)),
          if (done == null) ...[
            Text(
              '${DailyChallenge.questionCount} soal acak  |  ${DailyChallenge.secondsPerQuestion} detik per soal  |  bonus XP ${DailyChallenge.xpMultiplier}x',
              style: TextStyle(fontSize: r.sp(3), color: Colors.white70),
            ),
            SizedBox(height: r.wp(3)),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _purple,
                minimumSize: Size.fromHeight(r.wp(12)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.wp(4))),
                textStyle: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: r.sp(3.8)),
              ),
              onPressed: () => _start(context, resume: inProgress),
              child: Text(inProgress ? 'Lanjutkan Tantangan' : 'Mulai Tantangan'),
            ),
          ] else ...[
            Text(
              'Selesai! Skor ${done.score}/${done.total}  |  +${Gamification.xpOf(done)} XP',
              style: TextStyle(fontSize: r.sp(3.6), fontWeight: FontWeight.w600, color: Colors.white),
            ),
            SizedBox(height: r.wp(1)),
            Text(
              'Tantangan baru tersedia besok.',
              style: TextStyle(fontSize: r.sp(3), color: Colors.white70),
            ),
          ],
        ],
      ),
    );
  }
}