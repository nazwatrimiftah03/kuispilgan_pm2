import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.only(bottom: r.wp(3)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.wp(4))),
      child: InkWell(
        borderRadius: BorderRadius.circular(r.wp(4)),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(r.wp(4)),
          child: Row(
            children: [
              CircleAvatar(
                radius: r.wp(6),
                backgroundColor: cs.primaryContainer,
                child: Icon(icon, color: cs.primary, size: r.wp(6)),
              ),
              SizedBox(width: r.wp(4)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: r.sp(3.9), fontWeight: FontWeight.w600)),
                    Text(subtitle, style: TextStyle(fontSize: r.sp(3.1), color: cs.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}