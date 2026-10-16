import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

enum OptionStatus { normal, selected, correct, wrong, dimmed }

class OptionTile extends StatelessWidget {
  final String label;
  final String text;
  final OptionStatus status;
  final VoidCallback? onTap;

  const OptionTile({
    super.key,
    required this.label,
    required this.text,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;

    Color background;
    Color border;
    Color badge;
    Color badgeText;
    IconData? trailing;
    Color? trailingColor;

    switch (status) {
      case OptionStatus.selected:
        background = cs.primaryContainer;
        border = cs.primary;
        badge = cs.primary;
        badgeText = cs.onPrimary;
        trailing = Icons.check_circle;
        trailingColor = cs.primary;
        break;
      case OptionStatus.correct:
        background = AppColors.success.withAlpha(40);
        border = AppColors.success;
        badge = AppColors.success;
        badgeText = Colors.white;
        trailing = Icons.check_circle;
        trailingColor = AppColors.success;
        break;
      case OptionStatus.wrong:
        background = AppColors.error.withAlpha(40);
        border = AppColors.error;
        badge = AppColors.error;
        badgeText = Colors.white;
        trailing = Icons.cancel;
        trailingColor = AppColors.error;
        break;
      case OptionStatus.dimmed:
        background = cs.surfaceContainerHighest.withAlpha(60);
        border = Colors.transparent;
        badge = cs.outlineVariant;
        badgeText = cs.onSurface;
        break;
      case OptionStatus.normal:
        background = cs.surfaceContainerHighest.withAlpha(120);
        border = Colors.transparent;
        badge = cs.outlineVariant;
        badgeText = cs.onSurface;
        break;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: r.wp(3)),
      child: Opacity(
        opacity: status == OptionStatus.dimmed ? 0.55 : 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(r.wp(4)),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(r.wp(4)),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(r.wp(4)),
              border: Border.all(color: border, width: 2),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: r.wp(4.5),
                  backgroundColor: badge,
                  child: Text(
                    label,
                    style: TextStyle(fontSize: r.sp(3.3), fontWeight: FontWeight.w600, color: badgeText),
                  ),
                ),
                SizedBox(width: r.wp(3)),
                Expanded(child: Text(text, style: TextStyle(fontSize: r.sp(3.7)))),
                if (trailing != null) Icon(trailing, color: trailingColor, size: r.wp(6)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}