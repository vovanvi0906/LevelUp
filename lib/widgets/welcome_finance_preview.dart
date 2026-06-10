import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/core/utils/currency_formatter.dart';
import 'package:saveup/widgets/finance_item.dart';
import 'package:saveup/widgets/side_card.dart';

class WelcomeFinancePreview extends StatelessWidget {
  const WelcomeFinancePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final cashAmount = CurrencyFormatter.formatVnd(2000000);
    final currentBalance = CurrencyFormatter.formatVnd(12560000);
    final monthlyIncome = CurrencyFormatter.formatVnd(8250000);
    final monthlyExpense = CurrencyFormatter.formatVnd(4230000);
    final savingAmount = CurrencyFormatter.formatVnd(6000000);

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 6,
            bottom: 55,
            child: SideCard(
              icon: Icons.savings_rounded,
              title: 'Ví tiền',
              amount: cashAmount,
              color: AppColors.primaryGreen,
            ),
          ),
          Positioned(
            right: 4,
            top: 60,
            child: Icon(
              Icons.trending_up_rounded,
              size: 88,
              color: AppColors.primaryGreen.withValues(alpha: 0.8),
            ),
          ),
          Container(
            width: 245,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(34),
              border: Border.all(color: AppColors.phoneBorder, width: 5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 30,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 62,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.phoneSpeaker,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Số dư hiện tại',
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  currentBalance,
                  style: const TextStyle(
                    color: AppColors.darkBlue,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 18),
                FinanceItem(
                  icon: Icons.arrow_upward_rounded,
                  title: 'Thu nhập',
                  amount: monthlyIncome,
                  color: AppColors.primaryGreen,
                  backgroundColor: AppColors.incomeBackground,
                ),
                const SizedBox(height: 12),
                FinanceItem(
                  icon: Icons.arrow_downward_rounded,
                  title: 'Chi tiêu',
                  amount: monthlyExpense,
                  color: AppColors.expenseRed,
                  backgroundColor: AppColors.expenseBackground,
                ),
                const SizedBox(height: 12),
                FinanceItem(
                  icon: Icons.flag_rounded,
                  title: 'Tiết kiệm',
                  amount: savingAmount,
                  color: AppColors.primaryBlue,
                  backgroundColor: AppColors.savingBackground,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
