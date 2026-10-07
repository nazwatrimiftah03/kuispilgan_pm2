import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseName {
  CourseName._();
  static const pengantar = 'Pengantar Ilmu Komputer';
  static const algoritma = 'Algoritma & Pemrograman';
  static const matdis = 'Matematika Diskrit';
  static const strukdat = 'Struktur Data';
  static const basisData = 'Basis Data';
  static const pbo = 'Pemrograman Berorientasi Objek';
  static const arsitektur = 'Arsitektur Komputer';
  static const sistemOperasi = 'Sistem Operasi';
  static const jaringan = 'Jaringan Komputer';
  static const rpl = 'Rekayasa Perangkat Lunak';
  static const ai = 'Kecerdasan Buatan';
  static const keamanan = 'Keamanan Informasi';
  static const mobile = 'Pemrograman Mobile';
}

const List<Course> courses = [
  Course(
    name: CourseName.pengantar,
    description: 'Sejarah komputer, sistem bilangan, dan logika digital.',
    level: 'Semester 1-2',
    icon: Icons.computer,
    color: Color(0xFF1565C0),
  ),
  Course(
    name: CourseName.algoritma,
    description: 'Logika pemrograman, perulangan, dan kompleksitas.',
    level: 'Semester 1-2',
    icon: Icons.code,
    color: Color(0xFF2E7D32),
  ),
  Course(
    name: CourseName.matdis,
    description: 'Himpunan, logika, kombinatorika, dan graf.',
    level: 'Semester 1-2',
    icon: Icons.functions,
    color: Color(0xFF6A1B9A),
  ),
  Course(
    name: CourseName.strukdat,
    description: 'Stack, queue, linked list, tree, graph, dan hashing.',
    level: 'Semester 1-2',
    icon: Icons.account_tree,
    color: Color(0xFFEF6C00),
  ),
  Course(
    name: CourseName.basisData,
    description: 'SQL, normalisasi, relasi antar tabel, dan transaksi.',
    level: 'Semester 3-4',
    icon: Icons.storage,
    color: Color(0xFF00838F),
  ),
  Course(
    name: CourseName.pbo,
    description: 'Class, objek, pewarisan, dan polimorfisme.',
    level: 'Semester 3-4',
    icon: Icons.data_object,
    color: Color(0xFFAD1457),
  ),
  Course(
    name: CourseName.arsitektur,
    description: 'CPU, hierarki memori, bus, dan siklus instruksi.',
    level: 'Semester 3-4',
    icon: Icons.memory,
    color: Color(0xFF455A64),
  ),
  Course(
    name: CourseName.sistemOperasi,
    description: 'Proses, penjadwalan CPU, memori virtual, dan deadlock.',
    level: 'Semester 3-4',
    icon: Icons.terminal,
    color: Color(0xFF4E342E),
  ),
];