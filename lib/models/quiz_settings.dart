/// Latihan: jawaban langsung dikoreksi (dipakai di Step 6).
/// Ujian: jawaban baru dikoreksi di halaman hasil.
enum QuizMode { latihan, ujian }

class QuizSettings {
  /// null = semua soal yang tersedia.
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