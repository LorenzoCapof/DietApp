// lib/core/services/storage_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/daily_log.dart';

/// Service per gestione persistenza locale con SharedPreferences
class StorageService {
  static const String _userKey = 'current_user';
  static const String _dailyLogsPrefix = 'daily_log_';

  // ============ USER OPERATIONS ============

  /// Verifica se esiste un utente salvato (per controllo primo avvio)
  Future<bool> hasUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userKey);
  }

  /// Recupera l'utente corrente (null se non esiste)
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  /// Salva l'utente
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  /// Elimina l'utente corrente (per logout o reset)
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // ============ DAILY LOG OPERATIONS ============

  /// Recupera il log giornaliero per una data
  Future<DailyLog?> getDailyLog(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getDailyLogKey(date);
    final logJson = prefs.getString(key);
    if (logJson == null) return null;
    return DailyLog.fromJson(jsonDecode(logJson));
  }

  /// Salva un log giornaliero
  Future<void> saveDailyLog(DailyLog log) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getDailyLogKey(log.date);
    await prefs.setString(key, jsonEncode(log.toJson()));
  }

  /// Genera la chiave storage per una data
  String _getDailyLogKey(DateTime date) {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return '$_dailyLogsPrefix$dateStr';
  }

  // ============ CLEAR ALL ============

  /// Cancella tutti i dati (user + logs) - per reset completo
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}