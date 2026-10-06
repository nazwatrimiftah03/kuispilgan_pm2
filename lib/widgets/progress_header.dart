import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class ProgressHeader extends StatelessWidget {
  final int current;
  final int total;

  const ProgressHeader({super.key, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Soal ${current + 1} dari $total',
          style: TextStyle(fontSize: r.sp(3.5), fontWeight: FontWeight.w600),
        ),
        SizedBox(height: r.wp(2)),
        ClipRRect(
          borderRadius: BorderRadius.circular(r.wp(2)),
          child: LinearProgressIndicator(
            value: (current + 1) / total,
            minHeight: r.wp(2.5),
          ),
        ),
      ],
    );
  }
}