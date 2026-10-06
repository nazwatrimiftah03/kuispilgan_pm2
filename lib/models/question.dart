class Question {
  final String category;
  final String text;
  final List<String> options;
  final int answerIndex;
  final String explanation;

  const Question({
    required this.category,
    required this.text,
    required this.options,
    required this.answerIndex,
    required this.explanation,
  });
}

class ScoreEntry {
  final String username;
  final String category;
  final int score;
  final int total;
  final DateTime date;

  const ScoreEntry({
    required this.username,
    required this.category,
    required this.score,
    required this.total,
    required this.date,
  });

  double get percent => total == 0 ? 0 : score / total;
}