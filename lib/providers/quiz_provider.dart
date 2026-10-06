import 'package:flutter/material.dart';
import '../data/questions.dart';
import '../models/question.dart';

class QuizProvider extends ChangeNotifier {
  String _category = 'Semua Kategori';
  List<Question> _questions = [];
  List<int?> _answers = [];
  int _current = 0;
  bool _finished = false;

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

  int get score {
    int s = 0;
    for (int i = 0; i < total; i++) {
      if (_answers[i] == _questions[i].answerIndex) s++;
    }
    return s;
  }

  List<ScoreEntry> historyOf(String username) =>
      history.where((h) => h.username == username).toList();

  void start(String? category) {
    _category = category ?? 'Semua Kategori';
    _questions = questionsFor(category);
    _answers = List<int?>.filled(_questions.length, null);
    _current = 0;
    _finished = false;
    notifyListeners();
  }

  void select(int index) {
    _answers[_current] = index;
    notifyListeners();
  }

  void next() {
    if (_current < total - 1) {
      _current++;
      notifyListeners();
    }
  }

  void previous() {
    if (_current > 0) {
      _current--;
      notifyListeners();
    }
  }

  void finish(String username) {
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
    _questions = [];
    _answers = [];
    _current = 0;
    _finished = false;
    notifyListeners();
  }

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}