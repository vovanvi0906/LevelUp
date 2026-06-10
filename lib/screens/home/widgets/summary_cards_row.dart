import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/core/utils/currency_formatter.dart';

class SummaryCardsRow extends StatelessWidget {
  final double monthlyIncome;
  final double monthlyExpense;
  final double totalSavings;

  const SummaryCardsRow({
    super.key,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.totalSavings,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _SummaryItem(
        title: 'Tổng thu',
        amount: monthlyIncome,
        icon: Icons.arrow_downward_rounded,
        color: AppColors.primaryGreen,
      ),
      _SummaryItem(
        title: 'Tổng chi',
        amount: monthlyExpense,
        icon: Icons.arrow_upward_rounded,
        color: AppColors.expenseRed,
      ),
      _SummaryItem(
        title: 'Tiền tiết kiệm',
        amount: totalSavings,
        icon: Icons.flag_rounded,
        color: AppColors.primaryBlue,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items
              .map((item) => SizedBox(width: itemWidth, child: item))
              .toList(),
        );
      },
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;

  const _SummaryItem({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7ECF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textGray,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              CurrencyFormatter.formatVnd(amount),
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
