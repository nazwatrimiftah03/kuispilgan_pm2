import 'dart:math';
import '../models/question.dart';
import 'questions.dart';

class DailyChallenge {
  DailyChallenge._();

  static const String category = 'Tantangan Harian';
  static const int questionCount = 5;
  static const int secondsPerQuestion = 20;
  static const int xpMultiplier = 2;

  static List<Question> questionsFor(DateTime date) {
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final list = List<Question>.of(allQuestions)..shuffle(Random(seed));
    return list.take(questionCount).toList();
  }

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