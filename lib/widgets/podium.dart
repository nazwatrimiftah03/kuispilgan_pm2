import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/leaderboard.dart';
import '../utils/responsive.dart';
import 'user_avatar.dart';

class Podium extends StatelessWidget {
  final List<LeaderboardEntry> entries;
  final String myUsername;

  const Podium({super.key, required this.entries, required this.myUsername});

  @override
  Widget build(BuildContext context) {
    const order = [1, 0, 2];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final i in order)
          Expanded(
            child: i < entries.length
                ? _PodiumColumn(
              entry: entries[i],
              place: i + 1,
              isMe: entries[i].user.username == myUsername,
            )
                : const SizedBox.shrink(),
          ),
      ],
    );
  }
}

class _PodiumColumn extends StatelessWidget {
  final LeaderboardEntry entry;
  final int place;
  final bool isMe;

  const _PodiumColumn({required this.entry, required this.place, required this.isMe});

  static const List<Color> _medal = [AppColors.gold, Color(0xFF90A4AE), Color(0xFFA1887F)];

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    final color = _medal[place - 1];
    final standHeight = place == 1 ? r.wp(24) : place == 2 ? r.wp(17) : r.wp(12);
    final avatarRadius = place == 1 ? r.wp(9) : r.wp(7);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (place == 1) Icon(Icons.workspace_premium, color: color, size: r.wp(8)),
        Container(
          padding: EdgeInsets.all(r.wp(0.8)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
          ),
          child: UserAvatar(index: entry.user.avatarIndex, radius: avatarRadius),
        ),
        SizedBox(height: r.wp(1.5)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: r.wp(1)),
          child: Text(
            isMe ? '${entry.user.fullName} (Kamu)' : entry.user.fullName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: r.sp(3), fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          '${entry.xp} XP',
          style: TextStyle(fontSize: r.sp(3.2), fontWeight: FontWeight.w700, color: cs.primary),
        ),
        SizedBox(height: r.wp(1.5)),
        Container(
          height: standHeight,
          margin: EdgeInsets.symmetric(horizontal: r.wp(1)),
          padding: EdgeInsets.only(top: r.wp(2)),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: color.withAlpha(70),
            borderRadius: BorderRadius.vertical(top: Radius.circular(r.wp(3))),
            border: Border.all(color: color),
          ),
          child: Text(
            '$place',
            style: TextStyle(fontSize: r.sp(7), fontWeight: FontWeight.w800, color: color),
          ),
        ),
      ],
    );
  }
}