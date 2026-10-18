import 'dart:math';
import '../models/question.dart';
import 'questions.dart';

/// Aturan Tantangan Harian: soal ditentukan dari tanggal, sehingga semua akun
/// mendapat soal yang sama pada hari yang sama.
class DailyChallenge {
  DailyChallenge._();

  static const String category = 'Tantangan Harian';
  static const int questionCount = 5;
  static const int secondsPerQuestion = 20;
  static const int xpMultiplier = 2;

  /// Memilih soal dengan pengacakan berbiji tanggal (hasil sama sepanjang hari).
  static List<Question> questionsFor(DateTime date) {
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final list = List<Question>.of(allQuestions)..shuffle(Random(seed));
    return list.take(questionCount).toList();
  }

  /// Hasil tantangan hari ini milik pengguna, atau null jika belum dikerjakan.
  static ScoreEntry? doneEntry(List<ScoreEntry> userHistory, DateTime now) {
    for (final h in userHistory) {
      if (h.category == category &&
          h.date.year == now.year &&
          h.date.month == now.month &&
          h.date.day == now.day) {
        return h;
      }
    }
    return null;
  }
}