import 'dart:async';
import 'package:flutter/material.dart';
import '../data/questions.dart';
import '../models/question.dart';
import '../models/quiz_settings.dart';

/// State management (Provider). Dipasang di root aplikasi sehingga progres
/// jawaban dan timer tidak hilang saat layar dirotasi atau pindah halaman.
class QuizProvider extends ChangeNotifier {
  String _category = 'Semua Kategori';
  List<Question> _questions = [];
  List<int?> _answers = [];
  int _current = 0;
  bool _finished = false;

  QuizSettings _settings = const QuizSettings();
  Timer? _timer;
  int _secondsLeft = 0;
  bool _expired = false;

  ThemeMode themeMode = ThemeMode.light;
  final List<ScoreEntry> history = [];

  String get category => _category;
  List<Question> get questions => _questions;
  List<int?> get answers => _answers;
  int get current => _current;
  int get total => _questions.length;
  bool get isLast => _current == total - 1;
  bool get hasProgress => _questions.isNotEmpty && !_finished;
  int? get selected => _answers[_current];

  QuizSettings get settings => _settings;
  bool get timerEnabled => _settings.timerEnabled;
  int get secondsLeft => _secondsLeft;

  /// true saat waktu soal terakhir habis; layar kuis lalu menyelesaikan kuis.
  bool get expired => _expired;

  /// Pada mode timer, tombol kembali dinonaktifkan agar adil.
  bool get canGoBack => _current > 0 && !timerEnabled;

  int get score {
    int s = 0;
    for (int i = 0; i < total; i++) {
      if (_answers[i] == _questions[i].answerIndex) s++;
    }
    return s;
  }

  List<ScoreEntry> historyOf(String username) =>
      history.where((h) => h.username == username).toList();

  double? bestPercentFor(String username, String category) {
    final list = history.where((h) => h.username == username && h.category == category);
    if (list.isEmpty) return null;
    return list.map((h) => h.percent).reduce((a, b) => a > b ? a : b);
  }

  void start(String? category, {QuizSettings settings = const QuizSettings()}) {
    pauseTimer();
    _settings = settings;
    _category = category ?? 'Semua Kategori';
    _questions = questionsFor(category, limit: settings.questionCount);
    _answers = List<int?>.filled(_questions.length, null);
    _current = 0;
    _finished = false;
    _expired = false;
    _secondsLeft = settings.secondsPerQuestion;
    resumeTimer();
    notifyListeners();
  }

  void select(int index) {
    if (_expired) return;
    _answers[_current] = index;
    notifyListeners();
  }

  void next() {
    if (_current < total - 1) {
      _current++;
      _secondsLeft = _settings.secondsPerQuestion;
      notifyListeners();
    }
  }

  void previous() {
    if (canGoBack) {
      _current--;
      notifyListeners();
    }
  }

  // ---------- Timer ----------

  void resumeTimer() {
    if (!timerEnabled || _finished || _expired || _questions.isEmpty || _timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _tick() {
    if (_secondsLeft > 0) _secondsLeft--;
    if (_secondsLeft == 0) {
      if (isLast) {
        pauseTimer();
        _expired = true;
      } else {
        _current++; // soal dilewati (dianggap salah)
        _secondsLeft = _settings.secondsPerQuestion;
      }
    }
    notifyListeners();
  }

  // ---------- Selesai & reset ----------

  void finish(String username) {
    pauseTimer();
    _finished = true;
    history.insert(
      0,
      ScoreEntry(
        username: username,
        category: _category,
        score: score,
        total: total,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void reset() {
    pauseTimer();
    _questions = [];
    _answers = [];
    _current = 0;
    _finished = false;
    _expired = false;
    notifyListeners();
  }

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}