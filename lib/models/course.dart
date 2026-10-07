import 'package:flutter/material.dart';

class Course {
  final String name;
  final String description;
  final String level;
  final IconData icon;
  final Color color;

  const Course({
    required this.name,
    required this.description,
    required this.level,
    required this.icon,
    required this.color,
  });
}