import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/core/utils/currency_formatter.dart';
import 'package:saveup/core/utils/model_display.dart';
import 'package:saveup/models/category_model.dart';

class CategoryExpenseItem extends StatelessWidget {
  final CategoryModel? category;
  final String fallbackName;
  final double amount;
  final double percent;

  const CategoryExpenseItem({
    super.key,
    required this.category,
    required this.fallbackName,
    required this.amount,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final category = this.category;
    final categoryColor = category == null
        ? AppColors.textGray
        : Color(category.colorValue);
    final categoryName = category?.name ?? fallbackName;
    final icon = category == null
        ? Icons.more_horiz_rounded
        : ModelDisplay.categoryIcon(category.iconName);
    final percentText = '${(percent * 100).round()}%';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: categoryColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        categoryName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      percentText,
                      style: const TextStyle(
                        color: AppColors.textGray,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  CurrencyFormatter.formatVnd(amount),
                  style: const TextStyle(
                    color: AppColors.textGray,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: percent,
                    backgroundColor: categoryColor.withValues(alpha: 0.1),
                    color: categoryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
