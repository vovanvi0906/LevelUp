import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:saveup/data/local_storage_service.dart';
import 'package:saveup/data/mock_data.dart';
import 'package:saveup/models/category_model.dart';
import 'package:saveup/models/saving_goal_model.dart';
import 'package:saveup/models/transaction_model.dart';
import 'package:saveup/models/wallet_model.dart';

class AppState extends ChangeNotifier {
  final DateTime _referenceDate;
  final List<WalletModel> _wallets;
  final List<CategoryModel> _categories;
  final List<TransactionModel> _transactions;
  final List<SavingGoalModel> _savingGoals;
  final LocalStorageService _storageService;

  AppState({DateTime? referenceDate, LocalStorageService? storageService})
    : _referenceDate = referenceDate ?? MockData.referenceDate,
      _wallets = List<WalletModel>.of(MockData.wallets),
      _categories = List<CategoryModel>.of(MockData.categories),
      _transactions = List<TransactionModel>.of(MockData.transactions),
      _savingGoals = List<SavingGoalModel>.of(MockData.savingGoals),
      _storageService = storageService ?? LocalStorageService();

  List<WalletModel> get wallets => List.unmodifiable(_wallets);

  List<CategoryModel> get categories => List.unmodifiable(_categories);

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  List<SavingGoalModel> get savingGoals => List.unmodifiable(_savingGoals);

  double get totalBalance {
    return _wallets.fold<double>(0, (sum, wallet) => sum + wallet.balance);
  }

  double get totalSavings {
    return _savingGoals.fold<double>(
      0,
      (sum, goal) => sum + goal.currentAmount,
    );
  }

  double get monthlyIncome => incomeByMonth(_referenceDate);

  double get monthlyExpense => expenseByMonth(_referenceDate);

  double get currentMonthBalance => balanceByMonth(_referenceDate);

  List<SavingGoalModel> get activeSavingGoals {
    final activeGoals = _savingGoals.where((goal) => !goal.isCompleted).toList()
      ..sort((left, right) => left.deadline.compareTo(right.deadline));
    return List.unmodifiable(activeGoals);
  }

  List<SavingGoalModel> get completedSavingGoals {
    final completedGoals =
        _savingGoals.where((goal) => goal.isCompleted).toList()
          ..sort((left, right) => left.deadline.compareTo(right.deadline));
    return List.unmodifiable(completedGoals);
  }

  List<TransactionModel> get recentTransactions {
    final sortedTransactions = List<TransactionModel>.of(_transactions)
      ..sort((left, right) => right.dateTime.compareTo(left.dateTime));
    return List.unmodifiable(sortedTransactions);
  }

  double walletIncome(String walletId) {
    if (findWalletById(walletId) == null) {
      return 0;
    }

    return transactionsByWallet(walletId).fold<double>(
      0,
      (sum, transaction) =>
          transaction.isIncome ? sum + transaction.amount : sum,
    );
  }

  double walletExpense(String walletId) {
    if (findWalletById(walletId) == null) {
      return 0;
    }

    return transactionsByWallet(walletId).fold<double>(
      0,
      (sum, transaction) =>
          transaction.isExpense ? sum + transaction.amount : sum,
    );
  }

  WalletModel? findWalletById(String id) {
    return _firstWhereOrNull(_wallets, (wallet) => wallet.id == id);
  }

  CategoryModel? findCategoryById(String id) {
    return _firstWhereOrNull(_categories, (category) => category.id == id);
  }

  TransactionModel? findTransactionById(String id) {
    return _firstWhereOrNull(
      _transactions,
      (transaction) => transaction.id == id,
    );
  }

  SavingGoalModel? findSavingGoalById(String id) {
    return _firstWhereOrNull(_savingGoals, (goal) => goal.id == id);
  }

  List<TransactionModel> transactionsByWallet(String walletId) {
    final filtered =
        _transactions
            .where((transaction) => transaction.walletId == walletId)
            .toList()
          ..sort((left, right) => right.dateTime.compareTo(left.dateTime));
    return List.unmodifiable(filtered);
  }

  List<TransactionModel> transactionsByType(TransactionType type) {
    final filtered =
        _transactions.where((transaction) => transaction.type == type).toList()
          ..sort((left, right) => right.dateTime.compareTo(left.dateTime));
    return List.unmodifiable(filtered);
  }

  List<TransactionModel> transactionsByMonth(DateTime month) {
    final filtered =
        _transactions
            .where(
              (transaction) =>
                  transaction.dateTime.year == month.year &&
                  transaction.dateTime.month == month.month,
            )
            .toList()
          ..sort((left, right) => right.dateTime.compareTo(left.dateTime));
    return List.unmodifiable(filtered);
  }

  double incomeByMonth(DateTime month) {
    return transactionsByMonth(month).fold<double>(
      0,
      (sum, transaction) =>
          transaction.isIncome ? sum + transaction.amount : sum,
    );
  }

  double expenseByMonth(DateTime month) {
    return transactionsByMonth(month).fold<double>(
      0,
      (sum, transaction) =>
          transaction.isExpense ? sum + transaction.amount : sum,
    );
  }

  double balanceByMonth(DateTime month) {
    return incomeByMonth(month) - expenseByMonth(month);
  }

  Map<String, double> expensesByCategory(DateTime month) {
    final expenses = <String, double>{};

    for (final transaction in transactionsByMonth(month)) {
      if (!transaction.isExpense) {
        continue;
      }

      final category =
          findCategoryById(transaction.categoryId)?.name ??
          transaction.categoryId;
      expenses[category] = (expenses[category] ?? 0) + transaction.amount;
    }

    return Map.unmodifiable(expenses);
  }

  CategoryModel? topExpenseCategory(DateTime month) {
    final totalsByCategoryId = _expenseTotalsByCategoryId(month);

    if (totalsByCategoryId.isEmpty) {
      return null;
    }

    String? topCategoryId;
    var topAmount = 0.0;

    for (final entry in totalsByCategoryId.entries) {
      if (entry.value > topAmount) {
        topCategoryId = entry.key;
        topAmount = entry.value;
      }
    }

    if (topCategoryId == null) {
      return null;
    }

    return findCategoryById(topCategoryId);
  }

  double expensePercentByCategory(String categoryId, DateTime month) {
    final totalExpense = expenseByMonth(month);

    if (totalExpense <= 0) {
      return 0;
    }

    final categoryExpense = _expenseTotalsByCategoryId(month)[categoryId] ?? 0;
    return (categoryExpense / totalExpense).clamp(0.0, 1.0).toDouble();
  }

  Map<String, double> _expenseTotalsByCategoryId(DateTime month) {
    final expenses = <String, double>{};

    for (final transaction in transactionsByMonth(month)) {
      if (!transaction.isExpense) {
        continue;
      }

      expenses[transaction.categoryId] =
          (expenses[transaction.categoryId] ?? 0) + transaction.amount;
    }

    return expenses;
  }

  Future<void> loadFromLocalStorage() async {
    final wallets = await _storageService.loadWallets();
    final categories = await _storageService.loadCategories();
    final transactions = await _storageService.loadTransactions();
    final savingGoals = await _storageService.loadSavingGoals();

    _wallets
      ..clear()
      ..addAll(wallets ?? MockData.wallets);
    _categories
      ..clear()
      ..addAll(categories ?? MockData.categories);
    _transactions
      ..clear()
      ..addAll(transactions ?? MockData.transactions);
    _savingGoals
      ..clear()
      ..addAll(savingGoals ?? MockData.savingGoals);

    notifyListeners();
  }

  Future<void> saveToLocalStorage() async {
    await Future.wait([
      _storageService.saveWallets(_wallets),
      _storageService.saveCategories(_categories),
      _storageService.saveTransactions(_transactions),
      _storageService.saveSavingGoals(_savingGoals),
    ]);
  }

  Future<void> resetToDefaultData() async {
    _wallets
      ..clear()
      ..addAll(MockData.wallets);
    _categories
      ..clear()
      ..addAll(MockData.categories);
    _transactions
      ..clear()
      ..addAll(MockData.transactions);
    _savingGoals
      ..clear()
      ..addAll(MockData.savingGoals);

    await saveToLocalStorage();
    notifyListeners();
  }

  Future<void> clearLocalData() async {
    await _storageService.clearAll();
    _wallets
      ..clear()
      ..addAll(MockData.wallets);
    _categories
      ..clear()
      ..addAll(MockData.categories);
    _transactions
      ..clear()
      ..addAll(MockData.transactions);
    _savingGoals
      ..clear()
      ..addAll(MockData.savingGoals);
    notifyListeners();
  }

  Future<String> exportJsonString() {
    return _storageService.exportJsonString(
      wallets: _wallets,
      categories: _categories,
      transactions: _transactions,
      savingGoals: _savingGoals,
    );
  }

  void addWallet(WalletModel wallet) {
    _wallets.add(wallet);
    _saveSafely();
    notifyListeners();
  }

  void updateWallet(WalletModel updatedWallet) {
    final walletIndex = _wallets.indexWhere(
      (wallet) => wallet.id == updatedWallet.id,
    );

    if (walletIndex == -1) {
      return;
    }

    _wallets[walletIndex] = updatedWallet;
    _saveSafely();
    notifyListeners();
  }

  bool deleteWallet(String walletId) {
    if (!canDeleteWallet(walletId)) {
      return false;
    }

    final walletIndex = _wallets.indexWhere((wallet) => wallet.id == walletId);

    if (walletIndex == -1) {
      return false;
    }

    _wallets.removeAt(walletIndex);
    _saveSafely();
    notifyListeners();
    return true;
  }

  bool canDeleteWallet(String walletId) {
    final walletExists = _wallets.any((wallet) => wallet.id == walletId);

    if (!walletExists) {
      return false;
    }

    return !_transactions.any(
      (transaction) => transaction.walletId == walletId,
    );
  }

  void addCategory(CategoryModel category) {
    _categories.add(category);
    _saveSafely();
    notifyListeners();
  }

  void updateCategory(CategoryModel updatedCategory) {
    final categoryIndex = _categories.indexWhere(
      (category) => category.id == updatedCategory.id,
    );

    if (categoryIndex == -1) {
      return;
    }

    _categories[categoryIndex] = updatedCategory;
    _saveSafely();
    notifyListeners();
  }

  bool deleteCategory(String categoryId) {
    if (!canDeleteCategory(categoryId)) {
      return false;
    }

    final categoryIndex = _categories.indexWhere(
      (category) => category.id == categoryId,
    );

    if (categoryIndex == -1) {
      return false;
    }

    _categories.removeAt(categoryIndex);
    _saveSafely();
    notifyListeners();
    return true;
  }

  bool canDeleteCategory(String categoryId) {
    final categoryExists = _categories.any(
      (category) => category.id == categoryId,
    );

    if (!categoryExists) {
      return false;
    }

    return !_transactions.any(
      (transaction) => transaction.categoryId == categoryId,
    );
  }

  void addSavingGoal(SavingGoalModel goal) {
    _savingGoals.add(goal);
    _saveSafely();
    notifyListeners();
  }

  void updateSavingGoal(SavingGoalModel updatedGoal) {
    final goalIndex = _savingGoals.indexWhere(
      (goal) => goal.id == updatedGoal.id,
    );

    if (goalIndex == -1) {
      return;
    }

    _savingGoals[goalIndex] = updatedGoal;
    _saveSafely();
    notifyListeners();
  }

  bool deleteSavingGoal(String goalId) {
    final goalIndex = _savingGoals.indexWhere((goal) => goal.id == goalId);

    if (goalIndex == -1) {
      return false;
    }

    _savingGoals.removeAt(goalIndex);
    _saveSafely();
    notifyListeners();
    return true;
  }

  void addTransaction(TransactionModel transaction) {
    _transactions.add(transaction);
    _applyTransactionToWallet(transaction);
    _saveSafely();
    notifyListeners();
  }

  void updateTransaction(TransactionModel updatedTransaction) {
    final transactionIndex = _transactions.indexWhere(
      (transaction) => transaction.id == updatedTransaction.id,
    );

    if (transactionIndex == -1) {
      return;
    }

    final oldTransaction = _transactions[transactionIndex];
    _rollbackTransactionFromWallet(oldTransaction);
    _transactions[transactionIndex] = updatedTransaction;
    _applyTransactionToWallet(updatedTransaction);
    _saveSafely();
    notifyListeners();
  }

  void deleteTransaction(String transactionId) {
    final transactionIndex = _transactions.indexWhere(
      (transaction) => transaction.id == transactionId,
    );

    if (transactionIndex == -1) {
      return;
    }

    final transaction = _transactions.removeAt(transactionIndex);
    _rollbackTransactionFromWallet(transaction);
    _saveSafely();
    notifyListeners();
  }

  void _applyTransactionToWallet(TransactionModel transaction) {
    _changeWalletBalance(transaction.walletId, transaction.signedAmount);
  }

  void _rollbackTransactionFromWallet(TransactionModel transaction) {
    _changeWalletBalance(transaction.walletId, -transaction.signedAmount);
  }

  void _changeWalletBalance(String walletId, double amountChange) {
    final walletIndex = _wallets.indexWhere((wallet) => wallet.id == walletId);

    if (walletIndex == -1) {
      return;
    }

    final wallet = _wallets[walletIndex];
    _wallets[walletIndex] = wallet.copyWith(
      balance: wallet.balance + amountChange,
    );
  }

  void _saveSafely() {
    unawaited(saveToLocalStorage().catchError((_) {}));
  }

  T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T item) test) {
    for (final item in items) {
      if (test(item)) {
        return item;
      }
    }
    return null;
  }
}
