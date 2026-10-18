import '../models/question.dart';
import '../data/daily_challenge.dart';

class PlayerLevel {
  static const int xpPerLevel = 100;

  final int level;
  final String title;
  final int xp;
  final int xpInLevel;

  const PlayerLevel({
    required this.level,
    required this.title,
    required this.xp,
    required this.xpInLevel,
  });

  double get progress => xpInLevel / xpPerLevel;
  int get xpToNext => xpPerLevel - xpInLevel;
}

class Gamification {
  Gamification._();

  static int xpOf(ScoreEntry e) {
    final base = e.score * 10 + ((e.total > 0 && e.score == e.total) ? 20 : 0);
    return e.category == DailyChallenge.category ? base * DailyChallenge.xpMultiplier : base;
  }

  static int totalXp(List<ScoreEntry> entries) =>
      entries.fold(0, (sum, e) => sum + xpOf(e));

  static PlayerLevel levelFor(int xp) {
    final level = xp ~/ PlayerLevel.xpPerLevel + 1;
    return PlayerLevel(
      level: level,
      title: _title(level),
      xp: xp,
      xpInLevel: xp % PlayerLevel.xpPerLevel,
    );
  }

  static String _title(int level) {
    if (level < 3) return 'Mahasiswa Baru';
    if (level < 6) return 'Coder Muda';
    if (level < 10) return 'Programmer';
    if (level < 15) return 'Software Engineer';
    return 'Arsitek Sistem';
  }
}