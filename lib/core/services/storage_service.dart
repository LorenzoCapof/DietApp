import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/daily_log.dart';

class StorageService {
  static const String _userKey = 'current_user';
  static const String _dailyLogsPrefix = 'daily_log_';

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<DailyLog?> getDailyLog(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getDailyLogKey(date);
    final logJson = prefs.getString(key);
    if (logJson == null) return null;
    return DailyLog.fromJson(jsonDecode(logJson));
  }

  Future<void> saveDailyLog(DailyLog log) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getDailyLogKey(log.date);
    await prefs.setString(key, jsonEncode(log.toJson()));
  }

  String _getDailyLogKey(DateTime date) {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return '$_dailyLogsPrefix$dateStr';
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
