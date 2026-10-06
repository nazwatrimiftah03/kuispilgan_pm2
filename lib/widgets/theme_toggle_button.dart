import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<QuizProvider>().themeMode == ThemeMode.dark;
    return IconButton(
      tooltip: 'Ganti tema',
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      onPressed: () => context.read<QuizProvider>().toggleTheme(),
    );
  }
}