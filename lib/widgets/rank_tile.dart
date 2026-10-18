import 'package:flutter/material.dart';
import '../utils/leaderboard.dart';
import '../utils/responsive.dart';
import 'user_avatar.dart';

/// Baris peringkat untuk posisi ke-4 dan seterusnya.
class RankTile extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  final bool isMe;

  const RankTile({super.key, required this.entry, required this.rank, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    final avg = entry.average == null ? '-' : '${(entry.average! * 100).round()}%';

    return Card(
      color: isMe ? cs.primaryContainer : null,
      margin: EdgeInsets.only(bottom: r.wp(2.5)),
      child: Padding(
        padding: EdgeInsets.all(r.wp(3)),
        child: Row(
          children: [
            SizedBox(
              width: r.wp(8),
              child: Text(
                '$rank',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: r.sp(4), fontWeight: FontWeight.w700, color: cs.onSurfaceVariant),
              ),
            ),
            UserAvatar(index: entry.user.avatarIndex, radius: r.wp(5)),
            SizedBox(width: r.wp(3)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isMe ? '${entry.user.fullName} (Kamu)' : entry.user.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: r.sp(3.5), fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${entry.quizCount} kuis | rata-rata $avg',
                    style: TextStyle(fontSize: r.sp(2.9), color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            SizedBox(width: r.wp(2)),
            Text('${entry.xp} XP', style: TextStyle(fontSize: r.sp(3.6), fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}