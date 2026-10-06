import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool outlined;

  const PrimaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size.fromHeight(r.wp(13))),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.wp(4))),
      ),
      textStyle: WidgetStatePropertyAll(
        TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: r.sp(3.8)),
      ),
    );
    final text = Text(label, textAlign: TextAlign.center);

    if (outlined) {
      return icon == null
          ? OutlinedButton(onPressed: onPressed, style: style, child: text)
          : OutlinedButton.icon(onPressed: onPressed, style: style, icon: Icon(icon), label: text);
    }
    return icon == null
        ? FilledButton(onPressed: onPressed, style: style, child: text)
        : FilledButton.icon(onPressed: onPressed, style: style, icon: Icon(icon), label: text);
  }
}