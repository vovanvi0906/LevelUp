import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/core/utils/currency_formatter.dart';
import 'package:saveup/widgets/app_card.dart';

class StatisticsSummaryCard extends StatelessWidget {
  final double income;
  final double expense;
  final double balance;
  final int transactionCount;

  const StatisticsSummaryCard({
    super.key,
    required this.income,
    required this.expense,
    required this.balance,
    required this.transactionCount,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tổng quan tháng',
            style: TextStyle(
              color: AppColors.darkBlue,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          _SummaryRow(
            icon: Icons.arrow_downward_rounded,
            label: 'Tổng thu',
            value: CurrencyFormatter.formatVnd(income),
            color: AppColors.primaryGreen,
          ),
          _SummaryRow(
            icon: Icons.arrow_upward_rounded,
            label: 'Tổng chi',
            value: CurrencyFormatter.formatVnd(expense),
            color: AppColors.expenseRed,
          ),
          _SummaryRow(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Còn lại',
            value: CurrencyFormatter.formatVnd(balance),
            color: balance >= 0 ? AppColors.primaryBlue : AppColors.expenseRed,
          ),
          const Divider(height: 24),
          Text(
            '$transactionCount giao dịch trong tháng',
            style: const TextStyle(
              color: AppColors.textGray,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textGray,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
