enum QuizMode { latihan, ujian }

class QuizSettings {
  final int? questionCount;
  final QuizMode mode;
  final bool timerEnabled;
  final int secondsPerQuestion;

  const QuizSettings({
    this.questionCount,
    this.mode = QuizMode.ujian,
    this.timerEnabled = false,
    this.secondsPerQuestion = 30,
  });
}