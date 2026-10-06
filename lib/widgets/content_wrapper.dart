import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class ContentWrapper extends StatelessWidget {
  final Widget child;
  const ContentWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(r.wp(5)),
            child: child,
          ),
        ),
      ),
    );
  }
}