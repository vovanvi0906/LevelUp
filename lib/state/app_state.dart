import 'package:flutter/foundation.dart';
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

  AppState({DateTime? referenceDate})
    : _referenceDate = referenceDate ?? MockData.referenceDate,
      _wallets = List<WalletModel>.of(MockData.wallets),
      _categories = List<CategoryModel>.of(MockData.categories),
      _transactions = List<TransactionModel>.of(MockData.transactions),
      _savingGoals = List<SavingGoalModel>.of(MockData.savingGoals);

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

  double get monthlyIncome {
    return transactionsByMonth(_referenceDate).fold<double>(
      0,
      (sum, transaction) =>
          transaction.isIncome ? sum + transaction.amount : sum,
    );
  }

  double get monthlyExpense {
    return transactionsByMonth(_referenceDate).fold<double>(
      0,
      (sum, transaction) =>
          transaction.isExpense ? sum + transaction.amount : sum,
    );
  }

  double get currentMonthBalance => monthlyIncome - monthlyExpense;

  List<TransactionModel> get recentTransactions {
    final sortedTransactions = List<TransactionModel>.of(_transactions)
      ..sort((left, right) => right.dateTime.compareTo(left.dateTime));
    return List.unmodifiable(sortedTransactions);
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

  void addTransaction(TransactionModel transaction) {
    _transactions.add(transaction);
    _applyTransactionToWallet(transaction);
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

  T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T item) test) {
    for (final item in items) {
      if (test(item)) {
        return item;
      }
    }
    return null;
  }
}
