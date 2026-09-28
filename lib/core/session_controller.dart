import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionController extends ChangeNotifier {
  static const _tokenKey = 'session_token';
  static const _nameKey = 'session_name';
  static const _languageKey = 'language_code';

  SharedPreferences? _preferences;
  String? token;
  String? name;
  String languageCode = 'id';
  bool isReady = false;

  Future<void> restore() async {
    try {
      _preferences = await SharedPreferences.getInstance();
      token = _preferences?.getString(_tokenKey);
      name = _preferences?.getString(_nameKey);
      final savedLanguage = _preferences?.getString(_languageKey);
      if (savedLanguage == 'id' || savedLanguage == 'en') {
        languageCode = savedLanguage!;
      }
    } catch (_) {
      token = null;
      name = null;
    } finally {
      isReady = true;
      notifyListeners();
    }
  }

  Future<void> saveSession({
    required String token,
    required String name,
  }) async {
    final preferences = _preferences ?? await SharedPreferences.getInstance();
    _preferences = preferences;
    await preferences.setString(_tokenKey, token);
    await preferences.setString(_nameKey, name);
    this.token = token;
    this.name = name;
    isReady = true;
    notifyListeners();
  }

  Future<void> clearSession() async {
    try {
      final preferences = _preferences ?? await SharedPreferences.getInstance();
      _preferences = preferences;
      await preferences.remove(_tokenKey);
      await preferences.remove(_nameKey);
    } finally {
      token = null;
      name = null;
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if ((languageCode != 'id' && languageCode != 'en') ||
        this.languageCode == languageCode) {
      return;
    }
    final preferences = _preferences ?? await SharedPreferences.getInstance();
    _preferences = preferences;
    await preferences.setString(_languageKey, languageCode);
    this.languageCode = languageCode;
    notifyListeners();
  }
}
