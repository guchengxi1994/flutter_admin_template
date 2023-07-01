import 'package:shared_preferences/shared_preferences.dart';

/// `Fat` for `flutter admin template`
class FatLocalStorage {
  static final _instance = FatLocalStorage._init();

  factory FatLocalStorage() => _instance;

  static SharedPreferences? _storage;

  FatLocalStorage._init() {
    _initStorage();
  }

  _initStorage() async {
    _storage ??= await SharedPreferences.getInstance();
  }

  Future<String> getToken() async {
    await _initStorage();
    return _storage!.getString("token") ?? "";
  }

  Future<void> setToken(String token) async {
    await _initStorage();
    _storage!.setString("token", token);
  }

  Future<void> setMenuAuth(List<String> s) async {
    await _initStorage();
    _storage!.setStringList("menuAuth", s);
  }

  Future<List<String>> getMenuAuth() async {
    await _initStorage();
    return _storage!.getStringList("menuAuth") ?? [];
  }
}
