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
  static const web = 'Pemrograman Web';
  static const daa = 'Desain & Analisis Algoritma';
  static const imk = 'Interaksi Manusia & Komputer';
  static const otomata = 'Teori Bahasa & Otomata';
  static const cloud = 'Komputasi Awan & DevOps';
  static const sainsData = 'Sains Data';
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
  Course(
    name: CourseName.jaringan,
    description: 'Model OSI, TCP/IP, pengalamatan IP, dan protokol.',
    level: 'Semester 5-6',
    icon: Icons.lan,
    color: Color(0xFF0277BD),
  ),
  Course(
    name: CourseName.rpl,
    description: 'SDLC, Agile, UML, pengujian, dan Git.',
    level: 'Semester 5-6',
    icon: Icons.engineering,
    color: Color(0xFF558B2F),
  ),
  Course(
    name: CourseName.ai,
    description: 'Machine learning, jaringan saraf, dan pencarian heuristik.',
    level: 'Semester 5-6',
    icon: Icons.psychology,
    color: Color(0xFFD84315),
  ),
  Course(
    name: CourseName.keamanan,
    description: 'Kriptografi, serangan siber, dan pertahanan sistem.',
    level: 'Semester 5-6',
    icon: Icons.security,
    color: Color(0xFFC62828),
  ),
  Course(
    name: CourseName.mobile,
    description: 'Flutter, widget, state management, dan layout.',
    level: 'Semester 5-6',
    icon: Icons.phone_android,
    color: Color(0xFF283593),
  ),
  Course(
    name: CourseName.web,
    description: 'HTML, CSS, JavaScript, HTTP, dan arsitektur web.',
    level: 'Semester 3-4',
    icon: Icons.language,
    color: Color(0xFF00695C),
  ),
  Course(
    name: CourseName.daa,
    description: 'Greedy, divide and conquer, dynamic programming, dan graf.',
    level: 'Semester 3-4',
    icon: Icons.speed,
    color: Color(0xFF512DA8),
  ),
  Course(
    name: CourseName.imk,
    description: 'Usability, prinsip desain antarmuka, dan aksesibilitas.',
    level: 'Semester 5-6',
    icon: Icons.touch_app,
    color: Color(0xFF827717),
  ),
  Course(
    name: CourseName.otomata,
    description: 'Automata, ekspresi reguler, tata bahasa, dan kompilator.',
    level: 'Semester 5-6',
    icon: Icons.device_hub,
    color: Color(0xFF0097A7),
  ),
  Course(
    name: CourseName.cloud,
    description: 'Model layanan cloud, Docker, Kubernetes, dan CI/CD.',
    level: 'Semester 7-8',
    icon: Icons.cloud,
    color: Color(0xFF1976D2),
  ),
  Course(
    name: CourseName.sainsData,
    description: 'Statistik dasar, pembersihan data, dan model prediksi.',
    level: 'Semester 7-8',
    icon: Icons.analytics,
    color: Color(0xFFBF360C),
  ),
];