import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saveup/models/category_model.dart';
import 'package:saveup/models/transaction_model.dart';
import 'package:saveup/models/wallet_model.dart';
import 'package:saveup/screens/category/category_list_screen.dart';
import 'package:saveup/screens/wallet/wallet_list_screen.dart';
import 'package:saveup/state/app_state.dart';

void main() {
  group('Wallet AppState logic', () {
    test('addWallet increases wallet count', () {
      final appState = AppState();
      final initialCount = appState.wallets.length;

      appState.addWallet(_wallet(id: 'wallet_test_add'));

      expect(appState.wallets.length, initialCount + 1);
      expect(appState.findWalletById('wallet_test_add'), isNotNull);
    });

    test('updateWallet updates wallet name', () {
      final appState = AppState();
      final wallet = appState.findWalletById('wallet_cash')!;

      appState.updateWallet(wallet.copyWith(name: 'Ví tiền mặt mới'));

      expect(appState.findWalletById('wallet_cash')?.name, 'Ví tiền mặt mới');
    });

    test('deleteWallet returns false when wallet has transactions', () {
      final appState = AppState();

      final didDelete = appState.deleteWallet('wallet_cash');

      expect(didDelete, isFalse);
      expect(appState.findWalletById('wallet_cash'), isNotNull);
    });

    test('deleteWallet removes wallet without transactions', () {
      final appState = AppState();
      appState.addWallet(_wallet(id: 'wallet_unused'));

      final didDelete = appState.deleteWallet('wallet_unused');

      expect(didDelete, isTrue);
      expect(appState.findWalletById('wallet_unused'), isNull);
    });

    test('walletIncome and walletExpense calculate totals', () {
      final appState = AppState();

      expect(appState.walletIncome('wallet_bank'), closeTo(8000000, 0.0001));
      expect(appState.walletExpense('wallet_bank'), closeTo(370000, 0.0001));
      expect(appState.walletIncome('wallet_missing'), 0);
      expect(appState.walletExpense('wallet_missing'), 0);
    });
  });

  group('Category AppState logic', () {
    test('addCategory increases category count', () {
      final appState = AppState();
      final initialCount = appState.categories.length;

      appState.addCategory(_category(id: 'category_test_add'));

      expect(appState.categories.length, initialCount + 1);
      expect(appState.findCategoryById('category_test_add'), isNotNull);
    });

    test('updateCategory updates category name', () {
      final appState = AppState();
      final category = appState.findCategoryById('category_food')!;

      appState.updateCategory(category.copyWith(name: 'Ăn vặt'));

      expect(appState.findCategoryById('category_food')?.name, 'Ăn vặt');
    });

    test('deleteCategory returns false when category has transactions', () {
      final appState = AppState();

      final didDelete = appState.deleteCategory('category_food');

      expect(didDelete, isFalse);
      expect(appState.findCategoryById('category_food'), isNotNull);
    });

    test('deleteCategory removes category without transactions', () {
      final appState = AppState();
      appState.addCategory(_category(id: 'category_unused'));

      final didDelete = appState.deleteCategory('category_unused');

      expect(didDelete, isTrue);
      expect(appState.findCategoryById('category_unused'), isNull);
    });
  });

  testWidgets('WalletListScreen renders wallet title and mock wallet', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(home: WalletListScreen(appState: AppState())),
    );

    expect(find.text('Ví tiền'), findsOneWidget);
    expect(find.text('Tiền mặt'), findsWidgets);
  });

  testWidgets('CategoryListScreen renders category title and mock category', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(home: CategoryListScreen(appState: AppState())),
    );

    expect(find.text('Danh mục'), findsOneWidget);
    expect(find.text('Ăn uống'), findsOneWidget);
  });
}

WalletModel _wallet({required String id}) {
  return WalletModel(
    id: id,
    name: 'Ví kiểm thử',
    balance: 100000,
    type: WalletType.cash,
    iconName: 'wallet',
    colorValue: 0xFF26B83F,
  );
}

CategoryModel _category({required String id}) {
  return CategoryModel(
    id: id,
    name: 'Danh mục kiểm thử',
    type: TransactionType.expense,
    iconName: 'receipt',
    colorValue: 0xFF1267E8,
  );
}
