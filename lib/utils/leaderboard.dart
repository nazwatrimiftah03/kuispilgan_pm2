import '../models/question.dart';
import '../providers/auth_provider.dart';
import 'gamification.dart';

class LeaderboardEntry {
  final AppUser user;
  final int xp;
  final int quizCount;
  final double? average;

  const LeaderboardEntry({
    required this.user,
    required this.xp,
    required this.quizCount,
    required this.average,
  });
}

class Leaderboard {
  Leaderboard._();

  /// Menyusun peringkat dari semua akun. [since] membatasi riwayat sejak
  /// tanggal tertentu (null = semua waktu). Urutan: XP, jumlah kuis, nama.
  static List<LeaderboardEntry> build(
      List<AppUser> users,
      List<ScoreEntry> history, {
        DateTime? since,
      }) {
    final entries = users.map((u) {
      final mine = history
          .where((h) => h.username == u.username && (since == null || !h.date.isBefore(since)))
          .toList();
      final avg = mine.isEmpty
          ? null
          : mine.map((h) => h.percent).reduce((a, b) => a + b) / mine.length;
      return LeaderboardEntry(
        user: u,
        xp: Gamification.totalXp(mine),
        quizCount: mine.length,
        average: avg,
      );
    }).toList();

    entries.sort((a, b) {
      final byXp = b.xp.compareTo(a.xp);
      if (byXp != 0) return byXp;
      final byCount = b.quizCount.compareTo(a.quizCount);
      if (byCount != 0) return byCount;
      return a.user.fullName.toLowerCase().compareTo(b.user.fullName.toLowerCase());
    });
    return entries;
  }
}