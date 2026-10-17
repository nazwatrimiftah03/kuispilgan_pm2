import 'package:flutter/material.dart';
import '../data/avatars.dart';

class UserAvatar extends StatelessWidget {
  final int index;
  final double radius;

  const UserAvatar({super.key, required this.index, required this.radius});

  @override
  Widget build(BuildContext context) {
    final style = avatarStyles[index % avatarStyles.length];
    return CircleAvatar(
      radius: radius,
      backgroundColor: style.color,
      child: Icon(style.icon, color: Colors.white, size: radius * 1.1),
    );
  }
}