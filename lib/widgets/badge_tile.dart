import 'package:flutter/material.dart';
import '../utils/achievements.dart';
import '../utils/responsive.dart';

class BadgeTile extends StatelessWidget {
  final Achievement achievement;
  final UserStats stats;

  const BadgeTile({super.key, required this.achievement, required this.stats});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    final a = achievement;
    final unlocked = a.unlocked(stats);

    return Card(
      margin: EdgeInsets.only(bottom: r.wp(3)),
      child: Padding(
        padding: EdgeInsets.all(r.wp(4)),
        child: Row(
          children: [
            CircleAvatar(
              radius: r.wp(7),
              backgroundColor: unlocked ? a.color : cs.surfaceContainerHighest,
              child: Icon(
                unlocked ? a.icon : Icons.lock_outline,
                color: unlocked ? Colors.white : cs.onSurfaceVariant,
                size: r.wp(7),
              ),
            ),
            SizedBox(width: r.wp(4)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a.title, style: TextStyle(fontSize: r.sp(3.7), fontWeight: FontWeight.w600)),
                  Text(a.description, style: TextStyle(fontSize: r.sp(3), color: cs.onSurfaceVariant)),
                  SizedBox(height: r.wp(2)),
                  if (unlocked)
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: a.color, size: r.wp(4)),
                        SizedBox(width: r.wp(1.5)),
                        Text('Terbuka', style: TextStyle(fontSize: r.sp(3), color: a.color, fontWeight: FontWeight.w600)),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(r.wp(1)),
                            child: LinearProgressIndicator(
                              value: a.progress(stats),
                              minHeight: r.wp(1.8),
                              color: a.color,
                              backgroundColor: a.color.withAlpha(35),
                            ),
                          ),
                        ),
                        SizedBox(width: r.wp(2)),
                        Text('${a.current(stats)}/${a.target}', style: TextStyle(fontSize: r.sp(2.9))),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}