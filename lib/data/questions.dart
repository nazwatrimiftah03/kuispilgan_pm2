import '../models/question.dart';

const List<String> categoryNames = [
  'Dasar Komputer',
  'Pemrograman',
  'Jaringan & Basis Data',
];

const List<Question> allQuestions = [
  // ---------- Dasar Komputer ----------
  Question(
    category: 'Dasar Komputer',
    text: 'Apa kepanjangan dari CPU?',
    options: ['Central Processing Unit', 'Computer Personal Unit', 'Central Program Utility', 'Control Processing Upgrade'],
    answerIndex: 0,
    explanation: 'CPU adalah "otak" komputer yang menjalankan instruksi program.',
  ),
  Question(
    category: 'Dasar Komputer',
    text: 'Satuan data terkecil dalam komputer adalah...',
    options: ['Byte', 'Bit', 'Kilobyte', 'Word'],
    answerIndex: 1,
    explanation: 'Bit hanya bernilai 0 atau 1, dan menjadi dasar semua data digital.',
  ),
  Question(
    category: 'Dasar Komputer',
    text: '1 byte sama dengan berapa bit?',
    options: ['4', '16', '8', '10'],
    answerIndex: 2,
    explanation: '1 byte tersusun dari 8 bit.',
  ),
  Question(
    category: 'Dasar Komputer',
    text: 'Memori yang isinya hilang ketika komputer dimatikan adalah...',
    options: ['ROM', 'SSD', 'Hard Disk', 'RAM'],
    answerIndex: 3,
    explanation: 'RAM bersifat volatile: datanya hanya bertahan selama ada aliran listrik.',
  ),
  Question(
    category: 'Dasar Komputer',
    text: 'Perangkat lunak yang mengelola hardware dan menjalankan aplikasi disebut...',
    options: ['Compiler', 'Sistem Operasi', 'Driver', 'Firmware'],
    answerIndex: 1,
    explanation: 'Sistem operasi (contoh: Windows, Linux, Android) menjadi perantara antara hardware dan aplikasi.',
  ),

  Question(
    category: 'Pemrograman',
    text: 'Kompleksitas waktu pencarian binary search adalah...',
    options: ['O(n)', 'O(log n)', 'O(n²)', 'O(1)'],
    answerIndex: 1,
    explanation: 'Binary search membagi ruang pencarian menjadi dua di setiap langkah, sehingga O(log n).',
  ),
  Question(
    category: 'Pemrograman',
    text: 'Struktur data dengan prinsip LIFO (Last In First Out) adalah...',
    options: ['Queue', 'Array', 'Stack', 'Graph'],
    answerIndex: 2,
    explanation: 'Pada stack, elemen yang terakhir masuk adalah yang pertama keluar.',
  ),
  Question(
    category: 'Pemrograman',
    text: 'Bahasa pemrograman yang digunakan pada framework Flutter adalah...',
    options: ['Kotlin', 'Dart', 'Swift', 'Java'],
    answerIndex: 1,
    explanation: 'Flutter dibuat oleh Google dan menggunakan bahasa Dart.',
  ),
  Question(
    category: 'Pemrograman',
    text: 'Konsep OOP yang membungkus data dan method dalam satu kelas serta membatasi akses langsung disebut...',
    options: ['Inheritance', 'Polymorphism', 'Encapsulation', 'Recursion'],
    answerIndex: 2,
    explanation: 'Encapsulation melindungi data internal objek dengan membatasi akses dari luar kelas.',
  ),
  Question(
    category: 'Pemrograman',
    text: 'Teknik di mana sebuah fungsi memanggil dirinya sendiri disebut...',
    options: ['Iterasi', 'Rekursi', 'Pewarisan', 'Kompilasi'],
    answerIndex: 1,
    explanation: 'Rekursi memecah masalah menjadi submasalah yang lebih kecil dan butuh kondisi berhenti (base case).',
  ),

  // ---------- Jaringan & Basis Data ----------
  Question(
    category: 'Jaringan & Basis Data',
    text: 'Protokol yang digunakan untuk mengakses halaman web secara aman adalah...',
    options: ['HTTP', 'FTP', 'HTTPS', 'SMTP'],
    answerIndex: 2,
    explanation: 'HTTPS adalah HTTP yang dienkripsi dengan TLS.',
  ),
  Question(
    category: 'Jaringan & Basis Data',
    text: 'Perintah SQL untuk mengambil data dari tabel adalah...',
    options: ['INSERT', 'SELECT', 'DELETE', 'UPDATE'],
    answerIndex: 1,
    explanation: 'SELECT dipakai untuk membaca data; INSERT menambah, UPDATE mengubah, DELETE menghapus.',
  ),
  Question(
    category: 'Jaringan & Basis Data',
    text: 'Alamat IPv4 terdiri dari berapa bit?',
    options: ['32', '64', '128', '16'],
    answerIndex: 0,
    explanation: 'IPv4 berukuran 32 bit (4 oktet), sedangkan IPv6 berukuran 128 bit.',
  ),
  Question(
    category: 'Jaringan & Basis Data',
    text: 'Kolom yang mengidentifikasi setiap baris secara unik dalam tabel disebut...',
    options: ['Foreign Key', 'Index', 'Primary Key', 'View'],
    answerIndex: 2,
    explanation: 'Primary key harus unik dan tidak boleh bernilai NULL.',
  ),
  Question(
    category: 'Jaringan & Basis Data',
    text: 'Perangkat yang meneruskan paket data antar jaringan yang berbeda adalah...',
    options: ['Hub', 'Repeater', 'Router', 'Kabel UTP'],
    answerIndex: 2,
    explanation: 'Router menentukan jalur terbaik untuk paket data antar jaringan.',
  ),
];

List<Question> questionsFor(String? category) {
  final list = category == null
      ? List<Question>.of(allQuestions)
      : allQuestions.where((q) => q.category == category).toList();
  list.shuffle();
  return list;
}