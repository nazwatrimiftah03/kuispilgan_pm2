import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/achievements.dart';
import '../utils/responsive.dart';

class BadgePreviewCard extends StatelessWidget {
  final VoidCallback onTap;
  const BadgePreviewCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    final user = context.watch<AuthProvider>().user;
    if (user == null) return const SizedBox.shrink();

    final stats = UserStats.from(context.watch<QuizProvider>().historyOf(user.username));
    final unlockedCount = achievements.where((a) => a.unlocked(stats)).length;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(r.wp(3)),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(r.wp(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Lencana', style: TextStyle(fontSize: r.sp(3.8), fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text(
                    '$unlockedCount/${achievements.length}',
                    style: TextStyle(fontSize: r.sp(3.4), fontWeight: FontWeight.w700, color: cs.primary),
                  ),
                  Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                ],
              ),
              SizedBox(height: r.wp(3)),
              Wrap(
                spacing: r.wp(2.5),
                runSpacing: r.wp(2.5),
                children: [
                  for (final a in achievements)
                    CircleAvatar(
                      radius: r.wp(5),
                      backgroundColor: a.unlocked(stats) ? a.color : cs.surfaceContainerHighest,
                      child: Icon(
                        a.unlocked(stats) ? a.icon : Icons.lock_outline,
                        size: r.wp(5),
                        color: a.unlocked(stats) ? Colors.white : cs.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}