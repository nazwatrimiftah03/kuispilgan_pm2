import 'package:kuispilgan_pm2/data/courses.dart';

import '../models/question.dart';
import 'courses.dart';
import 'questions_dasar.dart';
import 'questions_menengah.dart';

final List<Question> allQuestions = [
  ...questionsDasar,
  ...questionsMenengah,
];

final List<String> categoryNames = courses.map((c) => c.name).toList();

List<Question> questionsFor(String? category, {int? limit}) {
  final list = category == null
      ? List<Question>.of(allQuestions)
      : allQuestions.where((q) => q.category == category).toList();
  list.shuffle();
  if (limit != null && limit < list.length) {
    return list.take(limit).toList();
  }
  return list;
}