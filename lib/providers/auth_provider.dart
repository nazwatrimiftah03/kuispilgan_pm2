import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  final String fullName;
  final String username;
  final int avatarIndex;
  final DateTime joinedAt;

  const AppUser({
    required this.fullName,
    required this.username,
    required this.avatarIndex,
    required this.joinedAt,
  });
}

class AuthProvider extends ChangeNotifier {
  static const _usersKey = 'users';
  static const _sessionKey = 'session';

  Map<String, Map<String, String>> _users = {};
  AppUser? _current;

  AppUser? get user => _current;
  bool get isLoggedIn => _current != null;

  List<AppUser> get allUsers => _users.keys.map(_toUser).toList();

  AppUser _toUser(String username) {
    final d = _users[username]!;
    return AppUser(
      fullName: d['name']!,
      username: username,
      avatarIndex: int.tryParse(d['avatar'] ?? '') ?? 0,
      joinedAt: DateTime.tryParse(d['joined'] ?? '') ?? DateTime.now(),
    );
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(_users));
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw != null) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      _users = decoded.map(
            (k, v) => MapEntry(k, Map<String, String>.from(v as Map)),
      );
    }

    var dirty = false;
    for (final d in _users.values) {
      if (d['joined'] == null) {
        d['joined'] = DateTime.now().toIso8601String();
        dirty = true;
      }
    }
    if (dirty) await _saveUsers();

    final session = prefs.getString(_sessionKey);
    if (session != null && _users.containsKey(session)) {
      _current = _toUser(session);
    }
  }

  Future<String?> register(String fullName, String username, String password) async {
    final key = username.trim().toLowerCase();
    if (_users.containsKey(key)) return 'Username sudah dipakai';

    _users[key] = {
      'name': fullName.trim(),
      'password': password,
      'avatar': '0',
      'joined': DateTime.now().toIso8601String(),
    };
    await _saveUsers();
    return null;
  }

  Future<String?> login(String username, String password) async {
    final key = username.trim().toLowerCase();
    final data = _users[key];
    if (data == null || data['password'] != password) {
      return 'Username atau password salah';
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, key);

    _current = _toUser(key);
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    _current = null;
    notifyListeners();
  }

  // ---------- Profil ----------

  Future<void> updateName(String name) async {
    final u = _current;
    if (u == null) return;
    _users[u.username]!['name'] = name.trim();
    await _saveUsers();
    _current = _toUser(u.username);
    notifyListeners();
  }

  Future<void> updateAvatar(int index) async {
    final u = _current;
    if (u == null) return;
    _users[u.username]!['avatar'] = index.toString();
    await _saveUsers();
    _current = _toUser(u.username);
    notifyListeners();
  }

  Future<String?> changePassword(String oldPass, String newPass) async {
    final u = _current;
    if (u == null) return 'Kamu belum masuk';
    if (_users[u.username]!['password'] != oldPass) return 'Password lama salah';
    _users[u.username]!['password'] = newPass;
    await _saveUsers();
    return null;
  }
}