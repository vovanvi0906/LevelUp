import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saveup/models/transaction_model.dart';
import 'package:saveup/screens/transaction/add_transaction_screen.dart';
import 'package:saveup/screens/transaction/transaction_list_screen.dart';
import 'package:saveup/state/app_state.dart';

void main() {
  test('adding expense transaction decreases wallet balance', () {
    final appState = AppState();
    final initialBalance = appState.findWalletById('wallet_cash')!.balance;

    appState.addTransaction(
      _transaction(
        id: 'transaction_test_expense',
        amount: 100000,
        type: TransactionType.expense,
        walletId: 'wallet_cash',
      ),
    );

    expect(
      appState.findWalletById('wallet_cash')!.balance,
      closeTo(initialBalance - 100000, 0.0001),
    );
  });

  test('adding income transaction increases wallet balance', () {
    final appState = AppState();
    final initialBalance = appState.findWalletById('wallet_bank')!.balance;

    appState.addTransaction(
      _transaction(
        id: 'transaction_test_income',
        amount: 500000,
        type: TransactionType.income,
        walletId: 'wallet_bank',
        categoryId: 'category_salary',
      ),
    );

    expect(
      appState.findWalletById('wallet_bank')!.balance,
      closeTo(initialBalance + 500000, 0.0001),
    );
  });

  test('deleting expense transaction restores wallet balance', () {
    final appState = AppState();
    final initialBalance = appState.findWalletById('wallet_cash')!.balance;
    final transaction = _transaction(
      id: 'transaction_delete_expense',
      amount: 120000,
      type: TransactionType.expense,
      walletId: 'wallet_cash',
    );

    appState.addTransaction(transaction);
    appState.deleteTransaction(transaction.id);

    expect(
      appState.findWalletById('wallet_cash')!.balance,
      closeTo(initialBalance, 0.0001),
    );
  });

  test('deleting income transaction removes wallet balance increase', () {
    final appState = AppState();
    final initialBalance = appState.findWalletById('wallet_bank')!.balance;
    final transaction = _transaction(
      id: 'transaction_delete_income',
      amount: 300000,
      type: TransactionType.income,
      walletId: 'wallet_bank',
      categoryId: 'category_salary',
    );

    appState.addTransaction(transaction);
    appState.deleteTransaction(transaction.id);

    expect(
      appState.findWalletById('wallet_bank')!.balance,
      closeTo(initialBalance, 0.0001),
    );
  });

  test(
    'updating transaction rolls back old wallet impact and applies new one',
    () {
      final appState = AppState();
      final initialCash = appState.findWalletById('wallet_cash')!.balance;
      final initialBank = appState.findWalletById('wallet_bank')!.balance;
      final oldTransaction = _transaction(
        id: 'transaction_update',
        amount: 100000,
        type: TransactionType.expense,
        walletId: 'wallet_cash',
      );

      appState.addTransaction(oldTransaction);
      appState.updateTransaction(
        oldTransaction.copyWith(
          amount: 250000,
          type: TransactionType.income,
          walletId: 'wallet_bank',
          categoryId: 'category_salary',
        ),
      );

      expect(
        appState.findWalletById('wallet_cash')!.balance,
        closeTo(initialCash, 0.0001),
      );
      expect(
        appState.findWalletById('wallet_bank')!.balance,
        closeTo(initialBank + 250000, 0.0001),
      );
    },
  );

  test('transaction filters return expected data', () {
    final appState = AppState();

    expect(
      appState.transactionsByType(TransactionType.expense),
      everyElement(
        predicate<TransactionModel>((transaction) => transaction.isExpense),
      ),
    );
    expect(appState.transactionsByMonth(DateTime.now()), isNotEmpty);
  });

  testWidgets('TransactionListScreen renders transaction list title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TransactionListScreen(
          appState: AppState(),
          onAddTransactionTap: () {},
          onTransactionChanged: () {},
        ),
      ),
    );

    expect(find.text('Giao dịch'), findsWidgets);
  });

  testWidgets('AddTransactionScreen validates missing amount', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: AddTransactionScreen(
          appState: AppState(),
          onTransactionSaved: () {},
        ),
      ),
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Lưu giao dịch'));
    await tester.pump();

    expect(find.text('Số tiền không được để trống'), findsOneWidget);
  });
}

TransactionModel _transaction({
  required String id,
  required double amount,
  required TransactionType type,
  required String walletId,
  String categoryId = 'category_food',
}) {
  return TransactionModel(
    id: id,
    title: 'Giao dịch test',
    amount: amount,
    type: type,
    categoryId: categoryId,
    walletId: walletId,
    note: 'Test',
    dateTime: DateTime.now(),
  );
}
