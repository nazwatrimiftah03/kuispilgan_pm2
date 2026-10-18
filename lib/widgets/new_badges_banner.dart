import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../utils/achievements.dart';
import '../utils/responsive.dart';

class NewBadgesBanner extends StatelessWidget {
  const NewBadgesBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final user = context.watch<AuthProvider>().user;
    final quiz = context.watch<QuizProvider>();
    if (user == null || quiz.isRetry) return const SizedBox.shrink();

    final history = quiz.historyOf(user.username); // terbaru di indeks 0
    if (history.isEmpty) return const SizedBox.shrink();

    final before = UserStats.from(history.skip(1).toList());
    final after = UserStats.from(history);
    final fresh = achievements.where((a) => !a.unlocked(before) && a.unlocked(after)).toList();
    if (fresh.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: r.wp(3)),
      padding: EdgeInsets.all(r.wp(4)),
      decoration: BoxDecoration(
        color: AppColors.gold.withAlpha(35),
        borderRadius: BorderRadius.circular(r.wp(4)),
        border: Border.all(color: AppColors.gold),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: AppColors.gold, size: r.wp(6)),
              SizedBox(width: r.wp(2)),
              Text(
                'Lencana baru terbuka!',
                style: TextStyle(fontSize: r.sp(4), fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(height: r.wp(2)),
          for (final a in fresh)
            Padding(
              padding: EdgeInsets.only(top: r.wp(2)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: r.wp(4.5),
                    backgroundColor: a.color,
                    child: Icon(a.icon, color: Colors.white, size: r.wp(4.5)),
                  ),
                  SizedBox(width: r.wp(3)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.title, style: TextStyle(fontSize: r.sp(3.5), fontWeight: FontWeight.w600)),
                        Text(a.description, style: TextStyle(fontSize: r.sp(2.9))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}