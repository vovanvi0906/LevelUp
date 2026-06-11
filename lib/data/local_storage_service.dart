import 'dart:convert';

import 'package:saveup/models/category_model.dart';
import 'package:saveup/models/saving_goal_model.dart';
import 'package:saveup/models/transaction_model.dart';
import 'package:saveup/models/wallet_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _walletsKey = 'levelup_wallets';
  static const _categoriesKey = 'levelup_categories';
  static const _transactionsKey = 'levelup_transactions';
  static const _savingGoalsKey = 'levelup_saving_goals';

  Future<void> saveWallets(List<WalletModel> wallets) async {
    await _saveList(_walletsKey, wallets.map((wallet) => wallet.toJson()));
  }

  Future<List<WalletModel>?> loadWallets() async {
    final items = await _loadList(_walletsKey);
    return items?.map(WalletModel.fromJson).toList();
  }

  Future<void> saveCategories(List<CategoryModel> categories) async {
    await _saveList(
      _categoriesKey,
      categories.map((category) => category.toJson()),
    );
  }

  Future<List<CategoryModel>?> loadCategories() async {
    final items = await _loadList(_categoriesKey);
    return items?.map(CategoryModel.fromJson).toList();
  }

  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    await _saveList(
      _transactionsKey,
      transactions.map((transaction) => transaction.toJson()),
    );
  }

  Future<List<TransactionModel>?> loadTransactions() async {
    final items = await _loadList(_transactionsKey);
    return items?.map(TransactionModel.fromJson).toList();
  }

  Future<void> saveSavingGoals(List<SavingGoalModel> savingGoals) async {
    await _saveList(_savingGoalsKey, savingGoals.map((goal) => goal.toJson()));
  }

  Future<List<SavingGoalModel>?> loadSavingGoals() async {
    final items = await _loadList(_savingGoalsKey);
    return items?.map(SavingGoalModel.fromJson).toList();
  }

  Future<String> exportJsonString({
    required List<WalletModel> wallets,
    required List<CategoryModel> categories,
    required List<TransactionModel> transactions,
    required List<SavingGoalModel> savingGoals,
  }) async {
    final data = {
      'wallets': wallets.map((wallet) => wallet.toJson()).toList(),
      'categories': categories.map((category) => category.toJson()).toList(),
      'transactions': transactions
          .map((transaction) => transaction.toJson())
          .toList(),
      'savingGoals': savingGoals.map((goal) => goal.toJson()).toList(),
      'exportedAt': DateTime.now().toIso8601String(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  Future<void> clearAll() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.wait([
      preferences.remove(_walletsKey),
      preferences.remove(_categoriesKey),
      preferences.remove(_transactionsKey),
      preferences.remove(_savingGoalsKey),
    ]);
  }

  Future<void> _saveList(
    String key,
    Iterable<Map<String, dynamic>> items,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, jsonEncode(items.toList()));
  }

  Future<List<Map<String, dynamic>>?> _loadList(String key) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final rawValue = preferences.getString(key);

      if (rawValue == null || rawValue.isEmpty) {
        return null;
      }

      final decoded = jsonDecode(rawValue);
      if (decoded is! List) {
        return null;
      }

      return decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (_) {
      // Invalid local data should not crash the app; AppState falls back to
      // MockData when this returns null.
      return null;
    }
  }
}
