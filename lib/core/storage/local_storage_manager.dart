import 'package:shared_preferences/shared_preferences.dart';
part 'key_name_storage.dart';

class LocalStorageManager {
  static LocalStorageManager? _instance;
  static SharedPreferences? _preferences;

  LocalStorageManager._internal();

  static Future<LocalStorageManager> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageManager._internal();
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  Future<void> saveString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  String? getString(String key) {
    return _preferences?.getString(key);
  }

  Future<void> saveInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  int? getInt(String key) {
    return _preferences?.getInt(key);
  }

  Future<void> saveBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  Future<void> saveDouble(String key, double value) async {
    await _preferences?.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _preferences?.getDouble(key);
  }

  Future<void> saveStringList(String key, List<String> value) async {
    await _preferences?.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _preferences?.getStringList(key);
  }

  Future<void> remove(String key) async {
    await _preferences?.remove(key);
  }

  Future<void> clear() async {
    await _preferences?.clear();
  }

  bool containsKey(String key) {
    return _preferences?.containsKey(key) ?? false;
  }

  String? getToken() {
    return _preferences?.getString(KeyNameStorage.accessToken);
  }

  String? getRefreshToken() {
    return _preferences?.getString(KeyNameStorage.refreshToken);
  }

  Future<void> saveToken(String token) async {
    await _preferences?.setString(KeyNameStorage.accessToken, token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _preferences?.setString(KeyNameStorage.refreshToken, token);
  }

  Future<void> saveUserId(String userId) async {
    await _preferences?.setString(KeyNameStorage.userId, userId);
  }

  String? getUserId() {
    return _preferences?.getString(KeyNameStorage.userId);
  }
}
