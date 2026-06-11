import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:saveup/data/local_storage_service.dart';
import 'package:saveup/models/category_model.dart';
import 'package:saveup/models/saving_goal_model.dart';
import 'package:saveup/models/transaction_model.dart';
import 'package:saveup/models/wallet_model.dart';
import 'package:saveup/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('TransactionModel toJson and fromJson keep data', () {
    final transaction = TransactionModel(
      id: 'transaction_json',
      title: 'Cà phê',
      amount: 35000,
      type: TransactionType.expense,
      categoryId: 'category_food',
      walletId: 'wallet_cash',
      note: 'Sáng',
      dateTime: DateTime(2026, 6, 11, 8),
    );

    final restored = TransactionModel.fromJson(transaction.toJson());

    expect(restored.id, transaction.id);
    expect(restored.title, transaction.title);
    expect(restored.amount, transaction.amount);
    expect(restored.type, transaction.type);
    expect(restored.dateTime, transaction.dateTime);
  });

  test('WalletModel toJson and fromJson keep data', () {
    const wallet = WalletModel(
      id: 'wallet_json',
      name: 'Ví JSON',
      balance: 120000,
      type: WalletType.eWallet,
      iconName: 'payment',
      colorValue: 0xFF1267E8,
    );

    final restored = WalletModel.fromJson(wallet.toJson());

    expect(restored.id, wallet.id);
    expect(restored.name, wallet.name);
    expect(restored.balance, wallet.balance);
    expect(restored.type, wallet.type);
    expect(restored.iconName, wallet.iconName);
    expect(restored.colorValue, wallet.colorValue);
  });

  test('CategoryModel toJson and fromJson keep data', () {
    const category = CategoryModel(
      id: 'category_json',
      name: 'Ăn uống',
      type: TransactionType.expense,
      iconName: 'restaurant',
      colorValue: 0xFF26B83F,
    );

    final restored = CategoryModel.fromJson(category.toJson());

    expect(restored.id, category.id);
    expect(restored.name, category.name);
    expect(restored.type, category.type);
    expect(restored.iconName, category.iconName);
    expect(restored.colorValue, category.colorValue);
  });

  test('SavingGoalModel toJson and fromJson keep data', () {
    final goal = SavingGoalModel(
      id: 'goal_json',
      name: 'Laptop',
      targetAmount: 20000000,
      currentAmount: 5000000,
      deadline: DateTime(2026, 12, 31),
      note: 'Công việc',
    );

    final restored = SavingGoalModel.fromJson(goal.toJson());

    expect(restored.id, goal.id);
    expect(restored.name, goal.name);
    expect(restored.targetAmount, goal.targetAmount);
    expect(restored.currentAmount, goal.currentAmount);
    expect(restored.deadline, goal.deadline);
    expect(restored.note, goal.note);
  });

  test('LocalStorageService saves and loads wallets', () async {
    final service = LocalStorageService();
    const wallet = WalletModel(
      id: 'wallet_saved',
      name: 'Ví đã lưu',
      balance: 90000,
      type: WalletType.cash,
      iconName: 'wallet',
      colorValue: 0xFF26B83F,
    );

    await service.saveWallets([wallet]);
    final wallets = await service.loadWallets();

    expect(wallets, isNotNull);
    expect(wallets!.single.id, wallet.id);
  });

  test('AppState resetToDefaultData and clearLocalData do not crash', () async {
    final appState = AppState();

    appState.addWallet(
      const WalletModel(
        id: 'wallet_extra',
        name: 'Ví thêm',
        balance: 1,
        type: WalletType.cash,
        iconName: 'wallet',
        colorValue: 0xFF26B83F,
      ),
    );

    await appState.resetToDefaultData();
    expect(appState.findWalletById('wallet_extra'), isNull);

    await appState.clearLocalData();
    expect(appState.wallets, isNotEmpty);
  });

  test('AppState export JSON is not empty', () async {
    final appState = AppState();

    final jsonText = await appState.exportJsonString();
    final decoded = jsonDecode(jsonText) as Map<String, dynamic>;

    expect(jsonText, isNotEmpty);
    expect(decoded['wallets'], isNotEmpty);
    expect(decoded['transactions'], isNotEmpty);
  });
}
