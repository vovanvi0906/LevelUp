import 'package:saveup/models/category_model.dart';
import 'package:saveup/models/saving_goal_model.dart';
import 'package:saveup/models/transaction_model.dart';
import 'package:saveup/models/wallet_model.dart';

class MockData {
  MockData._();

  static final DateTime referenceDate = DateTime.now();

  static DateTime _todayAt(int hour, int minute) {
    return DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
      hour,
      minute,
    );
  }

  static DateTime _daysAgoAt(int daysAgo, int hour, int minute) {
    return _todayAt(hour, minute).subtract(Duration(days: daysAgo));
  }

  static DateTime _lastMonthAt(int hour, int minute) {
    return _todayAt(hour, minute).subtract(const Duration(days: 35));
  }

  static final List<WalletModel> wallets = [
    const WalletModel(
      id: 'wallet_cash',
      name: 'Tiền mặt',
      balance: 2000000,
      type: WalletType.cash,
      iconName: 'wallet',
      colorValue: 0xFF26B83F,
    ),
    const WalletModel(
      id: 'wallet_bank',
      name: 'Ngân hàng',
      balance: 5000000,
      type: WalletType.bank,
      iconName: 'account_balance',
      colorValue: 0xFF1267E8,
    ),
    const WalletModel(
      id: 'wallet_momo',
      name: 'Momo',
      balance: 500000,
      type: WalletType.eWallet,
      iconName: 'payment',
      colorValue: 0xFFE93655,
    ),
    const WalletModel(
      id: 'wallet_saving',
      name: 'Ví tiết kiệm',
      balance: 1000000,
      type: WalletType.saving,
      iconName: 'savings',
      colorValue: 0xFF0D1B45,
    ),
  ];

  static final List<CategoryModel> categories = [
    const CategoryModel(
      id: 'category_food',
      name: 'Ăn uống',
      type: TransactionType.expense,
      iconName: 'restaurant',
      colorValue: 0xFF26B83F,
    ),
    const CategoryModel(
      id: 'category_transport',
      name: 'Di chuyển',
      type: TransactionType.expense,
      iconName: 'directions_car',
      colorValue: 0xFF1267E8,
    ),
    const CategoryModel(
      id: 'category_shopping',
      name: 'Mua sắm',
      type: TransactionType.expense,
      iconName: 'shopping_bag',
      colorValue: 0xFFE93655,
    ),
    const CategoryModel(
      id: 'category_bills',
      name: 'Hóa đơn',
      type: TransactionType.expense,
      iconName: 'receipt',
      colorValue: 0xFF8B5CF6,
    ),
    const CategoryModel(
      id: 'category_entertainment',
      name: 'Giải trí',
      type: TransactionType.expense,
      iconName: 'movie',
      colorValue: 0xFFF59E0B,
    ),
    const CategoryModel(
      id: 'category_study',
      name: 'Học tập',
      type: TransactionType.expense,
      iconName: 'school',
      colorValue: 0xFF14B8A6,
    ),
    const CategoryModel(
      id: 'category_health',
      name: 'Sức khỏe',
      type: TransactionType.expense,
      iconName: 'health_and_safety',
      colorValue: 0xFFEF4444,
    ),
    const CategoryModel(
      id: 'category_home',
      name: 'Nhà cửa',
      type: TransactionType.expense,
      iconName: 'home',
      colorValue: 0xFF64748B,
    ),
    const CategoryModel(
      id: 'category_saving',
      name: 'Tiết kiệm',
      type: TransactionType.expense,
      iconName: 'savings',
      colorValue: 0xFF0D1B45,
    ),
    const CategoryModel(
      id: 'category_other_expense',
      name: 'Khác',
      type: TransactionType.expense,
      iconName: 'more_horiz',
      colorValue: 0xFF94A3B8,
    ),
    const CategoryModel(
      id: 'category_salary',
      name: 'Lương',
      type: TransactionType.income,
      iconName: 'payments',
      colorValue: 0xFF26B83F,
    ),
    const CategoryModel(
      id: 'category_bonus',
      name: 'Thưởng',
      type: TransactionType.income,
      iconName: 'redeem',
      colorValue: 0xFF1267E8,
    ),
    const CategoryModel(
      id: 'category_investment',
      name: 'Đầu tư',
      type: TransactionType.income,
      iconName: 'trending_up',
      colorValue: 0xFF14B8A6,
    ),
    const CategoryModel(
      id: 'category_gift',
      name: 'Quà tặng',
      type: TransactionType.income,
      iconName: 'card_giftcard',
      colorValue: 0xFFF59E0B,
    ),
    const CategoryModel(
      id: 'category_other_income',
      name: 'Khác',
      type: TransactionType.income,
      iconName: 'more_horiz',
      colorValue: 0xFF94A3B8,
    ),
  ];

  static final List<TransactionModel> transactions = [
    TransactionModel(
      id: 'transaction_coffee',
      title: 'Cà phê',
      amount: 35000,
      type: TransactionType.expense,
      categoryId: 'category_food',
      walletId: 'wallet_momo',
      note: 'Cà phê sáng',
      dateTime: _todayAt(15, 30),
    ),
    TransactionModel(
      id: 'transaction_lunch',
      title: 'Cơm trưa',
      amount: 45000,
      type: TransactionType.expense,
      categoryId: 'category_food',
      walletId: 'wallet_cash',
      note: 'Cơm trưa với đồng nghiệp',
      dateTime: _todayAt(12, 10),
    ),
    TransactionModel(
      id: 'transaction_fuel',
      title: 'Xăng xe',
      amount: 70000,
      type: TransactionType.expense,
      categoryId: 'category_transport',
      walletId: 'wallet_cash',
      note: 'Đổ xăng xe máy',
      dateTime: _todayAt(8, 5),
    ),
    TransactionModel(
      id: 'transaction_salary',
      title: 'Lương tháng',
      amount: 8000000,
      type: TransactionType.income,
      categoryId: 'category_salary',
      walletId: 'wallet_bank',
      note: 'Lương tháng này',
      dateTime: _daysAgoAt(1, 9, 0),
    ),
    TransactionModel(
      id: 'transaction_shirt',
      title: 'Mua áo',
      amount: 250000,
      type: TransactionType.expense,
      categoryId: 'category_shopping',
      walletId: 'wallet_bank',
      note: 'Mua áo sơ mi',
      dateTime: _daysAgoAt(3, 18, 15),
    ),
    TransactionModel(
      id: 'transaction_electricity_last_month',
      title: 'Tiền điện tháng trước',
      amount: 120000,
      type: TransactionType.expense,
      categoryId: 'category_bills',
      walletId: 'wallet_bank',
      note: 'Thanh toán tiền điện',
      dateTime: _lastMonthAt(20, 0),
    ),
  ];

  static final List<SavingGoalModel> savingGoals = [
    SavingGoalModel(
      id: 'goal_laptop',
      name: 'Mua laptop',
      targetAmount: 20000000,
      currentAmount: 5000000,
      deadline: DateTime(referenceDate.year, 12, 31),
      note: 'Dành cho công việc và học tập',
    ),
    SavingGoalModel(
      id: 'goal_dalat',
      name: 'Du lịch Đà Lạt',
      targetAmount: 5000000,
      currentAmount: 2000000,
      deadline: DateTime(referenceDate.year, 9, 30),
      note: 'Chuyến đi nghỉ ngắn cuối năm',
    ),
    SavingGoalModel(
      id: 'goal_emergency',
      name: 'Quỹ khẩn cấp',
      targetAmount: 10000000,
      currentAmount: 1500000,
      deadline: DateTime(referenceDate.year, 11, 30),
      note: 'Dự phòng cho chi phí phát sinh',
    ),
  ];
}
