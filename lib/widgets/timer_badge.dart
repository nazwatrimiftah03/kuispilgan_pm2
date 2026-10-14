import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Lingkaran hitung mundur; berubah merah saat waktu tinggal 5 detik.
class TimerBadge extends StatelessWidget {
  final int secondsLeft;
  final int totalSeconds;

  const TimerBadge({super.key, required this.secondsLeft, required this.totalSeconds});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    final color = secondsLeft <= 5 ? AppColors.error : cs.primary;
    final value = totalSeconds == 0 ? 0.0 : secondsLeft / totalSeconds;

    return SizedBox(
      width: r.wp(14),
      height: r.wp(14),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: r.wp(1.2),
              color: color,
              backgroundColor: color.withAlpha(40),
            ),
          ),
          Text(
            '$secondsLeft',
            style: TextStyle(fontSize: r.sp(4.2), fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }
}