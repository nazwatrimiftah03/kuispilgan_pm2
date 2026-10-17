import 'package:flutter/material.dart';

class AvatarStyle {
  final IconData icon;
  final Color color;
  const AvatarStyle(this.icon, this.color);
}

/// Pilihan avatar bawaan (tanpa file gambar, jadi ringan dan konsisten).
const List<AvatarStyle> avatarStyles = [
  AvatarStyle(Icons.face, Color(0xFF1565C0)),
  AvatarStyle(Icons.rocket_launch, Color(0xFFEF6C00)),
  AvatarStyle(Icons.sports_esports, Color(0xFF6A1B9A)),
  AvatarStyle(Icons.psychology, Color(0xFFD81B60)),
  AvatarStyle(Icons.terminal, Color(0xFF37474F)),
  AvatarStyle(Icons.android, Color(0xFF2E7D32)),
  AvatarStyle(Icons.bolt, Color(0xFFF9A825)),
  AvatarStyle(Icons.pets, Color(0xFF00838F)),
];