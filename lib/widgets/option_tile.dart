import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class OptionTile extends StatelessWidget {
  final String label;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.label,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: r.wp(3)),
      child: InkWell(
        borderRadius: BorderRadius.circular(r.wp(4)),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(r.wp(4)),
          decoration: BoxDecoration(
            color: selected ? cs.primaryContainer : cs.surfaceContainerHighest.withAlpha(120),
            borderRadius: BorderRadius.circular(r.wp(4)),
            border: Border.all(color: selected ? cs.primary : Colors.transparent, width: 2),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: r.wp(4.5),
                backgroundColor: selected ? cs.primary : cs.outlineVariant,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: r.sp(3.3),
                    fontWeight: FontWeight.w600,
                    color: selected ? cs.onPrimary : cs.onSurface,
                  ),
                ),
              ),
              SizedBox(width: r.wp(3)),
              Expanded(child: Text(text, style: TextStyle(fontSize: r.sp(3.7)))),
              if (selected) Icon(Icons.check_circle, color: cs.primary, size: r.wp(6)),
            ],
          ),
        ),
      ),
    );
  }
}