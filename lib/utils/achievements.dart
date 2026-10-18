import 'package:flutter/material.dart';
import '../data/courses.dart';
import '../models/question.dart';
import 'gamification.dart';
import '../data/daily_challenge.dart';

/// Ringkasan aktivitas pengguna, dihitung dari riwayat skor.
class UserStats {
  final int quizCount;
  final int perfectCount;
  final int courseCount;
  final int totalXp;
  final int currentStreak;
  final int bestStreak;
  final int maxQuizzesInDay;
  final Set<DateTime> activeDays;
  final int dailyCount;

  const UserStats({
    required this.quizCount,
    required this.perfectCount,
    required this.courseCount,
    required this.totalXp,
    required this.currentStreak,
    required this.bestStreak,
    required this.maxQuizzesInDay,
    required this.activeDays,
    required this.dailyCount,
  });

  factory UserStats.from(List<ScoreEntry> history, {DateTime? now}) {
    final today = now ?? DateTime.now();
    final days = <DateTime>{};
    final perDay = <DateTime, int>{};
    for (final h in history) {
      final d = DateTime(h.date.year, h.date.month, h.date.day);
      days.add(d);
      perDay[d] = (perDay[d] ?? 0) + 1;
    }
    final courseNames = courses.map((c) => c.name).toSet();

    return UserStats(
      quizCount: history.length,
      perfectCount: history.where((h) => h.total >= 5 && h.score == h.total).length,
      courseCount: history.map((h) => h.category).where(courseNames.contains).toSet().length,
      totalXp: Gamification.totalXp(history),
      currentStreak: _current(days, today),
      bestStreak: _best(days),
      maxQuizzesInDay:
      perDay.values.isEmpty ? 0 : perDay.values.reduce((a, b) => a > b ? a : b),
      activeDays: days,
      dailyCount: history.where((h) => h.category == DailyChallenge.category).length,
    );
  }

  /// Streak berjalan: tetap hidup jika kemarin masih ada kuis (hari ini belum).
  static int _current(Set<DateTime> days, DateTime now) {
    var cursor = DateTime(now.year, now.month, now.day);
    if (!days.contains(cursor)) {
      cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    }
    var count = 0;
    while (days.contains(cursor)) {
      count++;
      cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    }
    return count;
  }

  static int _best(Set<DateTime> days) {
    final sorted = days.toList()..sort();
    var best = 0;
    var run = 0;
    DateTime? prev;
    for (final d in sorted) {
      if (prev != null && DateTime(prev.year, prev.month, prev.day + 1) == d) {
        run++;
      } else {
        run = 1;
      }
      if (run > best) best = run;
      prev = d;
    }
    return best;
  }
}

class Achievement {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int target;
  final int Function(UserStats) value;

  const Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.target,
    required this.value,
  });

  bool unlocked(UserStats s) => value(s) >= target;

  /// Nilai saat ini, dibatasi sampai target (untuk tampilan "3/10").
  int current(UserStats s) => value(s) > target ? target : value(s);

  double progress(UserStats s) =>
      target == 0 ? 1.0 : (value(s) / target).clamp(0.0, 1.0).toDouble();
}

final List<Achievement> achievements = [
  Achievement(
    title: 'Langkah Pertama',
    description: 'Selesaikan 1 kuis',
    icon: Icons.flag,
    color: const Color(0xFF1565C0),
    target: 1,
    value: (s) => s.quizCount,
  ),
  Achievement(
    title: 'Rajin Belajar',
    description: 'Selesaikan 10 kuis',
    icon: Icons.menu_book,
    color: const Color(0xFF2E7D32),
    target: 10,
    value: (s) => s.quizCount,
  ),
  Achievement(
    title: 'Kutu Buku',
    description: 'Selesaikan 25 kuis',
    icon: Icons.local_library,
    color: const Color(0xFF6A1B9A),
    target: 25,
    value: (s) => s.quizCount,
  ),
  Achievement(
    title: 'Nilai Sempurna',
    description: 'Raih nilai 100% (minimal 5 soal)',
    icon: Icons.star,
    color: const Color(0xFFF9A825),
    target: 1,
    value: (s) => s.perfectCount,
  ),
  Achievement(
    title: 'Perfeksionis',
    description: 'Raih nilai 100% sebanyak 5 kali',
    icon: Icons.workspace_premium,
    color: const Color(0xFFEF6C00),
    target: 5,
    value: (s) => s.perfectCount,
  ),
  Achievement(
    title: 'Penjelajah',
    description: 'Coba 5 mata kuliah berbeda',
    icon: Icons.explore,
    color: const Color(0xFF00838F),
    target: 5,
    value: (s) => s.courseCount,
  ),
  Achievement(
    title: 'Polimatik',
    description: 'Coba 10 mata kuliah berbeda',
    icon: Icons.public,
    color: const Color(0xFF283593),
    target: 10,
    value: (s) => s.courseCount,
  ),
  Achievement(
    title: 'Master Ilkom',
    description: 'Coba semua mata kuliah',
    icon: Icons.school,
    color: const Color(0xFFAD1457),
    target: courses.length,
    value: (s) => s.courseCount,
  ),
  Achievement(
    title: 'Api Semangat',
    description: 'Main 3 hari berturut-turut',
    icon: Icons.local_fire_department,
    color: const Color(0xFFEF6C00),
    target: 3,
    value: (s) => s.bestStreak,
  ),
  Achievement(
    title: 'Konsisten',
    description: 'Main 7 hari berturut-turut',
    icon: Icons.whatshot,
    color: const Color(0xFFC62828),
    target: 7,
    value: (s) => s.bestStreak,
  ),
  Achievement(
    title: 'Maraton',
    description: 'Selesaikan 3 kuis dalam sehari',
    icon: Icons.directions_run,
    color: const Color(0xFF37474F),
    target: 3,
    value: (s) => s.maxQuizzesInDay,
  ),
  Achievement(
    title: 'Pemburu XP',
    description: 'Kumpulkan 500 XP',
    icon: Icons.bolt,
    color: const Color(0xFFBF8F00),
    target: 500,
    value: (s) => s.totalXp,
  ),
  Achievement(
    title: 'Pejuang Harian',
    description: 'Selesaikan 3 Tantangan Harian',
    icon: Icons.event_available,
    color: const Color(0xFF6A1B9A),
    target: 3,
    value: (s) => s.dailyCount,
  ),
];