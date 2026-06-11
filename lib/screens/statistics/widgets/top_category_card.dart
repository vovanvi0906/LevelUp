import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/core/utils/currency_formatter.dart';
import 'package:saveup/core/utils/model_display.dart';
import 'package:saveup/models/category_model.dart';
import 'package:saveup/widgets/app_card.dart';
import 'package:saveup/widgets/empty_state.dart';

class TopCategoryCard extends StatelessWidget {
  final CategoryModel? category;
  final double amount;

  const TopCategoryCard({
    super.key,
    required this.category,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final category = this.category;

    return AppCard(
      child: category == null
          ? const EmptyState(
              icon: Icons.insights_rounded,
              title: 'Chưa có dữ liệu chi tiêu',
              message:
                  'Danh mục chi nhiều nhất sẽ hiển thị sau khi có giao dịch.',
            )
          : _TopCategoryContent(category: category, amount: amount),
    );
  }
}

class _TopCategoryContent extends StatelessWidget {
  final CategoryModel category;
  final double amount;

  const _TopCategoryContent({required this.category, required this.amount});

  @override
  Widget build(BuildContext context) {
    final categoryColor = Color(category.colorValue);

    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: categoryColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            ModelDisplay.categoryIcon(category.iconName),
            color: categoryColor,
            size: 28,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chi nhiều nhất',
                style: TextStyle(
                  color: AppColors.textGray,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            CurrencyFormatter.formatVnd(amount),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.expenseRed,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
