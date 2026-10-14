import 'package:flutter/material.dart';
import '../models/quiz_settings.dart';
import '../utils/responsive.dart';
import 'primary_button.dart';

/// Menampilkan bottom sheet pengaturan. Mengembalikan null jika ditutup.
Future<QuizSettings?> showQuizSettingsSheet(
    BuildContext context, {
      required String title,
      required int available,
    }) {
  return showModalBottomSheet<QuizSettings>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => QuizSettingsSheet(title: title, available: available),
  );
}

class QuizSettingsSheet extends StatefulWidget {
  final String title;
  final int available;

  const QuizSettingsSheet({super.key, required this.title, required this.available});

  @override
  State<QuizSettingsSheet> createState() => _QuizSettingsSheetState();
}

class _QuizSettingsSheetState extends State<QuizSettingsSheet> {
  static const List<int> _countOptions = [5, 10, 15, 20, 30];
  static const List<int> _secondOptions = [15, 30, 45, 60];

  late int? _count = widget.available > 20 ? 10 : null;
  bool _timer = false;
  int _seconds = 30;

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    final options = _countOptions.where((n) => n < widget.available).toList();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(r.wp(5), 0, r.wp(5), r.wp(5)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontSize: r.sp(5), fontWeight: FontWeight.w700, color: cs.primary),
              ),
              Text(
                'Atur kuis sebelum dimulai',
                style: TextStyle(fontSize: r.sp(3.2), color: cs.onSurfaceVariant),
              ),
              SizedBox(height: r.wp(5)),

              Text('Jumlah soal', style: TextStyle(fontSize: r.sp(3.8), fontWeight: FontWeight.w600)),
              SizedBox(height: r.wp(2)),
              Wrap(
                spacing: r.wp(2),
                children: [
                  for (final n in options)
                    ChoiceChip(
                      label: Text('$n soal', style: TextStyle(fontSize: r.sp(3.2))),
                      selected: _count == n,
                      onSelected: (_) => setState(() => _count = n),
                    ),
                  ChoiceChip(
                    label: Text('Semua (${widget.available})', style: TextStyle(fontSize: r.sp(3.2))),
                    selected: _count == null,
                    onSelected: (_) => setState(() => _count = null),
                  ),
                ],
              ),
              SizedBox(height: r.wp(4)),

              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Timer per soal', style: TextStyle(fontSize: r.sp(3.8), fontWeight: FontWeight.w600)),
                subtitle: Text(
                  'Soal berpindah otomatis saat waktu habis',
                  style: TextStyle(fontSize: r.sp(3)),
                ),
                value: _timer,
                onChanged: (v) => setState(() => _timer = v),
              ),
              if (_timer)
                Wrap(
                  spacing: r.wp(2),
                  children: [
                    for (final s in _secondOptions)
                      ChoiceChip(
                        label: Text('$s detik', style: TextStyle(fontSize: r.sp(3.2))),
                        selected: _seconds == s,
                        onSelected: (_) => setState(() => _seconds = s),
                      ),
                  ],
                ),
              SizedBox(height: r.wp(5)),

              PrimaryButton(
                label: 'Mulai Kuis',
                icon: Icons.play_arrow,
                onPressed: () => Navigator.pop(
                  context,
                  QuizSettings(
                    questionCount: _count,
                    timerEnabled: _timer,
                    secondsPerQuestion: _seconds,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}