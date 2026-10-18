import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/daily_challenge.dart';
import '../data/questions.dart';
import '../models/question.dart';
import '../models/quiz_settings.dart';

class QuizProvider extends ChangeNotifier {
  static const _historyKey = 'history';
  static const _themeKey = 'theme_dark';

  String _category = 'Semua Kategori';
  List<Question> _questions = [];
  List<int?> _answers = [];
  int _current = 0;
  bool _finished = false;
  bool _isRetry = false;

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

  bool get isRetry => _isRetry;

  QuizSettings get settings => _settings;
  bool get timerEnabled => _settings.timerEnabled;
  int get secondsLeft => _secondsLeft;
  bool get expired => _expired;

  bool get canGoBack => _current > 0 && !timerEnabled;

  bool get isPractice => _settings.mode == QuizMode.latihan;

  bool get isLocked => isPractice && _answers.isNotEmpty && _answers[_current] != null;

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

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    themeMode = (prefs.getBool(_themeKey) ?? false) ? ThemeMode.dark : ThemeMode.light;
    final raw = prefs.getString(_historyKey);
    history.clear();
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        history.addAll(list.map((e) => ScoreEntry.fromJson(e as Map<String, dynamic>)));
      } catch (_) {
        history.clear(); // data rusak: mulai dari nol
      }
    }
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_historyKey, jsonEncode(history.map((e) => e.toJson()).toList()));
  }

  void clearHistory(String username) {
    history.removeWhere((h) => h.username == username);
    _saveHistory();
    notifyListeners();
  }

  void start(String? category, {QuizSettings settings = const QuizSettings()}) {
    pauseTimer();
    _settings = settings;
    _category = category ?? 'Semua Kategori';
    _questions = questionsFor(category, limit: settings.questionCount);
    _answers = List<int?>.filled(_questions.length, null);
    _current = 0;
    _finished = false;
    _isRetry = false;
    _expired = false;
    _secondsLeft = settings.secondsPerQuestion;
    resumeTimer();
    notifyListeners();
  }

  void startDaily(List<Question> dailyQuestions) {
    pauseTimer();
    _settings = const QuizSettings(
      mode: QuizMode.latihan,
      timerEnabled: true,
      secondsPerQuestion: DailyChallenge.secondsPerQuestion,
    );
    _category = DailyChallenge.category;
    _questions = List<Question>.of(dailyQuestions);
    _answers = List<int?>.filled(_questions.length, null);
    _current = 0;
    _finished = false;
    _isRetry = false;
    _expired = false;
    _secondsLeft = DailyChallenge.secondsPerQuestion;
    resumeTimer();
    notifyListeners();
  }

  void retryWrong() {
    final wrong = <Question>[];
    for (int i = 0; i < total; i++) {
      if (_answers[i] != _questions[i].answerIndex) wrong.add(_questions[i]);
    }
    if (wrong.isEmpty) return;
    pauseTimer();
    wrong.shuffle();
    _questions = wrong;
    _answers = List<int?>.filled(wrong.length, null);
    _current = 0;
    _finished = false;
    _isRetry = true;
    _expired = false;
    _secondsLeft = _settings.secondsPerQuestion;
    resumeTimer();
    notifyListeners();
  }

  void select(int index) {
    if (_expired || isLocked) return;
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
    if (isLocked) return;
    if (_secondsLeft > 0) _secondsLeft--;
    if (_secondsLeft == 0) {
      if (isLast) {
        pauseTimer();
        _expired = true;
      } else {
        _current++;
        _secondsLeft = _settings.secondsPerQuestion;
      }
    }
    notifyListeners();
  }

  void finish(String username) {
    pauseTimer();
    _finished = true;
    if (!_isRetry) {
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
      _saveHistory();
    }
    notifyListeners();
  }

  void reset() {
    pauseTimer();
    _questions = [];
    _answers = [];
    _current = 0;
    _finished = false;
    _isRetry = false;
    _expired = false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, themeMode == ThemeMode.dark);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}