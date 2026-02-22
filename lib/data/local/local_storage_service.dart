import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistence layer using SharedPreferences.
/// Stores JSON-encoded lists for each entity type.
/// Designed to be replaced by a remote API + sync layer later.
class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // Storage keys
  static const _transactionsKey = 'local_transactions';
  static const _categoriesKey = 'local_categories';
  static const _budgetsKey = 'local_budgets';
  static const _userProfileKey = 'local_user_profile';

  // === Generic helpers ===

  List<Map<String, dynamic>> _getJsonList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return [];
    final decoded = json.decode(raw) as List;
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> _saveJsonList(String key, List<Map<String, dynamic>> list) {
    return _prefs.setString(key, json.encode(list));
  }

  // === Transactions ===

  List<Map<String, dynamic>> getTransactions() => _getJsonList(_transactionsKey);

  Future<void> saveTransactions(List<Map<String, dynamic>> transactions) =>
      _saveJsonList(_transactionsKey, transactions);

  // === Categories ===

  List<Map<String, dynamic>> getCategories() => _getJsonList(_categoriesKey);

  Future<void> saveCategories(List<Map<String, dynamic>> categories) =>
      _saveJsonList(_categoriesKey, categories);

  // === Budgets ===

  List<Map<String, dynamic>> getBudgets() => _getJsonList(_budgetsKey);

  Future<void> saveBudgets(List<Map<String, dynamic>> budgets) =>
      _saveJsonList(_budgetsKey, budgets);

  // === User Profile ===

  Map<String, dynamic>? getUserProfile() {
    final raw = _prefs.getString(_userProfileKey);
    if (raw == null) return null;
    return json.decode(raw) as Map<String, dynamic>;
  }

  Future<void> saveUserProfile(Map<String, dynamic> user) =>
      _prefs.setString(_userProfileKey, json.encode(user));

  Future<void> clearUserProfile() => _prefs.remove(_userProfileKey);

  // === Clear all data (for logout) ===

  Future<void> clearAll() async {
    await _prefs.remove(_transactionsKey);
    await _prefs.remove(_categoriesKey);
    await _prefs.remove(_budgetsKey);
    await _prefs.remove(_userProfileKey);
  }
}
