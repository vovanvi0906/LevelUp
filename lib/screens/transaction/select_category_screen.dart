import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/models/category_model.dart';
import 'package:saveup/models/transaction_model.dart';
import 'package:saveup/state/app_state.dart';
import 'package:saveup/widgets/app_card.dart';
import 'package:saveup/widgets/empty_state.dart';

class SelectCategoryScreen extends StatelessWidget {
  final AppState appState;
  final TransactionType transactionType;

  const SelectCategoryScreen({
    super.key,
    required this.appState,
    required this.transactionType,
  });

  @override
  Widget build(BuildContext context) {
    final categories = appState.categories
        .where((category) => category.type == transactionType)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Chọn danh mục'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (categories.isEmpty)
                const EmptyState(
                  icon: Icons.category_rounded,
                  title: 'Chưa có danh mục',
                  message: 'Danh mục phù hợp sẽ hiển thị tại đây.',
                )
              else
                GridView.builder(
                  itemCount: categories.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.45,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _CategoryCard(category: category);
                  },
                ),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tính năng thêm danh mục sẽ làm sau'),
                    ),
                  );
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('+ Thêm danh mục mới'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final color = Color(category.colorValue);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.pop(context, category);
      },
      child: AppCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(_iconForCategory(category.iconName), color: color),
            ),
            const SizedBox(height: 10),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.darkBlue,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForCategory(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'directions_car':
        return Icons.directions_car_rounded;
      case 'shopping_bag':
        return Icons.shopping_bag_rounded;
      case 'receipt':
        return Icons.receipt_rounded;
      case 'movie':
        return Icons.movie_rounded;
      case 'school':
        return Icons.school_rounded;
      case 'health_and_safety':
        return Icons.health_and_safety_rounded;
      case 'home':
        return Icons.home_rounded;
      case 'savings':
        return Icons.savings_rounded;
      case 'payments':
        return Icons.payments_rounded;
      case 'redeem':
        return Icons.redeem_rounded;
      case 'trending_up':
        return Icons.trending_up_rounded;
      case 'card_giftcard':
        return Icons.card_giftcard_rounded;
      default:
        return Icons.more_horiz_rounded;
    }
  }
}
