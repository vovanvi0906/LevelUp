import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/models/category_model.dart';
import 'package:saveup/screens/statistics/widgets/category_expense_item.dart';
import 'package:saveup/screens/statistics/widgets/month_selector.dart';
import 'package:saveup/screens/statistics/widgets/statistics_summary_card.dart';
import 'package:saveup/screens/statistics/widgets/top_category_card.dart';
import 'package:saveup/state/app_state.dart';
import 'package:saveup/widgets/app_card.dart';
import 'package:saveup/widgets/empty_state.dart';

class StatisticsScreen extends StatefulWidget {
  final AppState appState;

  const StatisticsScreen({super.key, required this.appState});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Thống kê'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: widget.appState,
          builder: (context, _) {
            final income = widget.appState.incomeByMonth(_selectedMonth);
            final expense = widget.appState.expenseByMonth(_selectedMonth);
            final balance = widget.appState.balanceByMonth(_selectedMonth);
            final transactions = widget.appState.transactionsByMonth(
              _selectedMonth,
            );
            final topCategory = widget.appState.topExpenseCategory(
              _selectedMonth,
            );
            final topCategoryAmount = topCategory == null
                ? 0.0
                : expense *
                      widget.appState.expensePercentByCategory(
                        topCategory.id,
                        _selectedMonth,
                      );
            final categoryExpenses = _categoryExpenses;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MonthSelector(
                    selectedMonth: _selectedMonth,
                    onPreviousMonth: _goToPreviousMonth,
                    onNextMonth: _goToNextMonth,
                  ),
                  const SizedBox(height: 16),
                  StatisticsSummaryCard(
                    income: income,
                    expense: expense,
                    balance: balance,
                    transactionCount: transactions.length,
                  ),
                  const SizedBox(height: 16),
                  TopCategoryCard(
                    category: topCategory,
                    amount: topCategoryAmount,
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Chi tiêu theo danh mục',
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (categoryExpenses.isEmpty)
                          const EmptyState(
                            icon: Icons.category_rounded,
                            title: 'Chưa có khoản chi',
                            message:
                                'Các danh mục chi tiêu trong tháng sẽ hiển thị tại đây.',
                          )
                        else
                          ...categoryExpenses.map(
                            (item) => CategoryExpenseItem(
                              category: item.category,
                              fallbackName: item.categoryId,
                              amount: item.amount,
                              percent: item.percent,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<_CategoryExpenseData> get _categoryExpenses {
    final totalsByCategoryId = <String, double>{};

    for (final transaction in widget.appState.transactionsByMonth(
      _selectedMonth,
    )) {
      if (!transaction.isExpense) {
        continue;
      }

      totalsByCategoryId[transaction.categoryId] =
          (totalsByCategoryId[transaction.categoryId] ?? 0) +
          transaction.amount;
    }

    final totalExpense = widget.appState.expenseByMonth(_selectedMonth);
    final items = totalsByCategoryId.entries.map((entry) {
      final percent = totalExpense <= 0
          ? 0.0
          : (entry.value / totalExpense).clamp(0.0, 1.0).toDouble();

      return _CategoryExpenseData(
        categoryId: entry.key,
        category: widget.appState.findCategoryById(entry.key),
        amount: entry.value,
        percent: percent,
      );
    }).toList()..sort((left, right) => right.amount.compareTo(left.amount));

    return items;
  }

  void _goToPreviousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }
}

class _CategoryExpenseData {
  final String categoryId;
  final CategoryModel? category;
  final double amount;
  final double percent;

  const _CategoryExpenseData({
    required this.categoryId,
    required this.category,
    required this.amount,
    required this.percent,
  });
}
