import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/leaderboard.dart';
import '../utils/responsive.dart';
import '../widgets/content_wrapper.dart';
import '../widgets/podium.dart';
import '../widgets/rank_tile.dart';
import '../widgets/user_avatar.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool _weekly = false;

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    final auth = context.watch<AuthProvider>();
    final me = auth.user;
    if (me == null) return const SizedBox.shrink();

    final quiz = context.watch<QuizProvider>();
    final since = _weekly ? DateTime.now().subtract(const Duration(days: 7)) : null;
    final entries = Leaderboard.build(auth.allUsers, quiz.history, since: since);
    final myIndex = entries.indexWhere((e) => e.user.username == me.username);

    String hint = '';
    if (myIndex == 0) {
      hint = entries.length == 1
          ? 'Kamu satu-satunya pemain. Buat akun lain untuk bersaing!'
          : 'Kamu di puncak! Pertahankan posisimu.';
    } else if (myIndex > 0) {
      final above = entries[myIndex - 1];
      final gap = above.xp - entries[myIndex].xp;
      hint = 'Butuh ${gap + 1} XP lagi untuk melewati ${above.user.fullName}.';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Papan Peringkat')),
      body: ContentWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<bool>(
              style: ButtonStyle(
                textStyle: WidgetStatePropertyAll(TextStyle(fontSize: r.sp(3.2))),
              ),
              segments: const [
                ButtonSegment(value: false, label: Text('Semua waktu')),
                ButtonSegment(value: true, label: Text('7 hari terakhir')),
              ],
              selected: {_weekly},
              onSelectionChanged: (s) => setState(() => _weekly = s.first),
            ),
            SizedBox(height: r.wp(6)),

            Podium(entries: entries, myUsername: me.username),
            SizedBox(height: r.wp(4)),

            if (myIndex >= 0)
              Card(
                child: ListTile(
                  leading: UserAvatar(index: me.avatarIndex, radius: r.wp(6)),
                  title: Text(
                    'Peringkatmu: #${myIndex + 1} dari ${entries.length}',
                    style: TextStyle(fontSize: r.sp(3.7), fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(hint, style: TextStyle(fontSize: r.sp(3))),
                ),
              ),
            SizedBox(height: r.wp(3)),

            if (entries.length > 3) ...[
              Text('Peringkat Lainnya', style: TextStyle(fontSize: r.sp(4.2), fontWeight: FontWeight.w600)),
              SizedBox(height: r.wp(2)),
              for (int i = 3; i < entries.length; i++)
                RankTile(
                  entry: entries[i],
                  rank: i + 1,
                  isMe: entries[i].user.username == me.username,
                ),
            ],

            SizedBox(height: r.wp(2)),
            Text(
              'Peringkat hanya mencakup akun yang terdaftar di perangkat ini.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: r.sp(2.8), color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}