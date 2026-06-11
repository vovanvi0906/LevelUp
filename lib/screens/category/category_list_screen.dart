import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/core/utils/model_display.dart';
import 'package:saveup/models/category_model.dart';
import 'package:saveup/models/transaction_model.dart';
import 'package:saveup/screens/category/add_category_screen.dart';
import 'package:saveup/screens/category/edit_category_screen.dart';
import 'package:saveup/state/app_state.dart';
import 'package:saveup/widgets/app_card.dart';
import 'package:saveup/widgets/empty_state.dart';

enum _CategoryAction { edit, delete }

class CategoryListScreen extends StatefulWidget {
  final AppState appState;

  const CategoryListScreen({super.key, required this.appState});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  var _selectedType = TransactionType.expense;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Danh mục'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'category_list_add_fab',
        onPressed: _openAddCategory,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Thêm danh mục'),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: widget.appState,
          builder: (context, _) {
            final categories = widget.appState.categories
                .where((category) => category.type == _selectedType)
                .toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedButton<TransactionType>(
                    segments: const [
                      ButtonSegment(
                        value: TransactionType.expense,
                        label: Text('Chi tiêu'),
                      ),
                      ButtonSegment(
                        value: TransactionType.income,
                        label: Text('Thu nhập'),
                      ),
                    ],
                    selected: {_selectedType},
                    onSelectionChanged: (selection) {
                      setState(() {
                        _selectedType = selection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  if (categories.isEmpty)
                    const AppCard(
                      child: EmptyState(
                        icon: Icons.category_rounded,
                        title: 'Chưa có danh mục',
                        message: 'Thêm danh mục mới để phân loại giao dịch.',
                      ),
                    )
                  else
                    ...categories.map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CategoryListItem(
                          category: category,
                          onTap: () => _openCategoryActions(category),
                        ),
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

  Future<void> _openAddCategory() async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AddCategoryScreen(appState: widget.appState),
      ),
    );
  }

  Future<void> _openCategoryActions(CategoryModel category) async {
    final action = await showModalBottomSheet<_CategoryAction>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                category.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.edit_rounded),
                title: const Text('Sửa danh mục'),
                onTap: () => Navigator.pop(context, _CategoryAction.edit),
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.expenseRed,
                ),
                title: const Text('Xóa danh mục'),
                textColor: AppColors.expenseRed,
                onTap: () => Navigator.pop(context, _CategoryAction.delete),
              ),
            ],
          ),
        ),
      ),
    );

    if (action == null || !mounted) {
      return;
    }

    switch (action) {
      case _CategoryAction.edit:
        await _openEditCategory(category);
      case _CategoryAction.delete:
        await _deleteCategory(category);
    }
  }

  Future<void> _openEditCategory(CategoryModel category) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditCategoryScreen(appState: widget.appState, category: category),
      ),
    );
  }

  Future<void> _deleteCategory(CategoryModel category) async {
    if (!widget.appState.canDeleteCategory(category.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể xóa danh mục đang có giao dịch'),
        ),
      );
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa danh mục?'),
        content: Text(
          'Bạn có chắc muốn xóa danh mục "${category.name}" không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    final didDelete = widget.appState.deleteCategory(category.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          didDelete
              ? 'Đã xóa danh mục'
              : 'Không thể xóa danh mục đang có giao dịch',
        ),
      ),
    );
  }
}

class _CategoryListItem extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const _CategoryListItem({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final categoryColor = Color(category.colorValue);

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                ModelDisplay.categoryIcon(category.iconName),
                color: categoryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ModelDisplay.transactionTypeLabel(category.type),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textGray,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textGray),
          ],
        ),
      ),
    );
  }
}
