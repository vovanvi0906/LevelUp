import 'package:flutter_test/flutter_test.dart';
import 'package:saveup/core/utils/currency_formatter.dart';
import 'package:saveup/data/mock_data.dart';
import 'package:saveup/models/saving_goal_model.dart';
import 'package:saveup/models/transaction_model.dart';
import 'package:saveup/state/app_state.dart';

void main() {
  test('CurrencyFormatter formats VND correctly', () {
    expect(CurrencyFormatter.formatVnd(12560000), '12.560.000đ');
    expect(CurrencyFormatter.formatVnd(45000), '45.000đ');
  });

  test('SavingGoalModel calculates progress and remaining amount', () {
    final goal = SavingGoalModel(
      id: 'goal_test',
      name: 'Mục tiêu thử',
      targetAmount: 20000000,
      currentAmount: 5000000,
      deadline: DateTime(2026, 12, 31),
      note: 'Test',
    );

    expect(goal.progressPercent, closeTo(0.25, 0.0001));
    expect(goal.remainingAmount, closeTo(15000000, 0.0001));
    expect(goal.isCompleted, isFalse);
  });

  test('AppState computes balances and lookups from mock data', () {
    final appState = AppState();

    expect(appState.totalBalance, closeTo(8500000, 0.0001));
    expect(appState.totalSavings, closeTo(8500000, 0.0001));
    expect(appState.monthlyIncome, closeTo(8000000, 0.0001));
    expect(appState.monthlyExpense, closeTo(400000, 0.0001));
    expect(appState.currentMonthBalance, closeTo(7600000, 0.0001));

    expect(appState.recentTransactions, isNotEmpty);
    expect(appState.recentTransactions.first.id, 'transaction_coffee');
    expect(appState.findWalletById('wallet_cash')?.name, 'Tiền mặt');

    final expensesByCategory = appState.expensesByCategory(
      MockData.referenceDate,
    );
    expect(expensesByCategory['Ăn uống'], closeTo(80000, 0.0001));
    expect(expensesByCategory['Di chuyển'], closeTo(70000, 0.0001));

    final initialCount = appState.transactions.length;
    var notificationCount = 0;
    appState.addListener(() {
      notificationCount++;
    });

    appState.addTransaction(
      TransactionModel(
        id: 'transaction_test_add',
        title: 'Thử thêm',
        amount: 100000,
        type: TransactionType.expense,
        categoryId: 'category_food',
        walletId: 'wallet_cash',
        note: 'Test addTransaction',
        dateTime: DateTime.now(),
      ),
    );

    expect(notificationCount, 1);
    expect(appState.transactions.length, initialCount + 1);
    expect(appState.findTransactionById('transaction_test_add'), isNotNull);
  });

  test('MockData links transactions to existing wallets and categories', () {
    final lunch = MockData.transactions
        .where((transaction) => transaction.id == 'transaction_lunch')
        .single;

    expect(lunch.walletId, 'wallet_cash');
    expect(lunch.categoryId, 'category_food');
  });
}
