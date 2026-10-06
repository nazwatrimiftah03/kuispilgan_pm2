import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  final String fullName;
  final String username;
  const AppUser(this.fullName, this.username);
}

class AuthProvider extends ChangeNotifier {
  static const _usersKey = 'users';
  static const _sessionKey = 'session';

  Map<String, Map<String, String>> _users = {};
  AppUser? _current;

  AppUser? get user => _current;
  bool get isLoggedIn => _current != null;

  AppUser _toUser(String username) =>
      AppUser(_users[username]!['name']!, username);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw != null) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      _users = decoded.map(
            (k, v) => MapEntry(k, Map<String, String>.from(v as Map)),
      );
    }
    final session = prefs.getString(_sessionKey);
    if (session != null && _users.containsKey(session)) {
      _current = _toUser(session);
    }
  }

  Future<String?> register(String fullName, String username, String password) async {
    final key = username.trim().toLowerCase();
    if (_users.containsKey(key)) return 'Username sudah dipakai';

    _users[key] = {'name': fullName.trim(), 'password': password};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(_users));
    await prefs.setString(_sessionKey, key);

    _current = _toUser(key);
    notifyListeners();
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
}