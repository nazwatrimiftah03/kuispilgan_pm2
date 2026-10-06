import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/responsive.dart';
import '../widgets/content_wrapper.dart';
import '../widgets/option_tile.dart';
import '../widgets/primary_button.dart';
import '../widgets/progress_header.dart';
import 'result_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  static const List<String> _labels = ['A', 'B', 'C', 'D', 'E'];

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final quiz = context.watch<QuizProvider>();

    if (quiz.questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final q = quiz.questions[quiz.current];

    return Scaffold(
      appBar: AppBar(title: Text(quiz.category)),
      body: ContentWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProgressHeader(current: quiz.current, total: quiz.total),
            SizedBox(height: r.wp(5)),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.wp(4))),
              child: Padding(
                padding: EdgeInsets.all(r.wp(5)),
                child: Text(
                  q.text,
                  style: TextStyle(fontSize: r.sp(4.2), fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: r.wp(4)),
            for (int i = 0; i < q.options.length; i++)
              OptionTile(
                label: _labels[i],
                text: q.options[i],
                selected: quiz.selected == i,
                onTap: () => context.read<QuizProvider>().select(i),
              ),
            SizedBox(height: r.wp(2)),
            Row(
              children: [
                if (quiz.current > 0) ...[
                  Expanded(
                    child: PrimaryButton(
                      label: 'Kembali',
                      icon: Icons.arrow_back,
                      outlined: true,
                      onPressed: quiz.previous,
                    ),
                  ),
                  SizedBox(width: r.wp(3)),
                ],
                Expanded(
                  child: PrimaryButton(
                    label: quiz.isLast ? 'Selesai' : 'Lanjut',
                    icon: quiz.isLast ? Icons.flag : Icons.arrow_forward,
                    onPressed: quiz.selected == null
                        ? null
                        : () {
                      if (quiz.isLast) {
                        final username = context.read<AuthProvider>().user!.username;
                        quiz.finish(username);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const ResultScreen()),
                        );
                      } else {
                        quiz.next();
                      }
                    },
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