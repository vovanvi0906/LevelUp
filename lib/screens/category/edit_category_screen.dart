import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/models/category_model.dart';
import 'package:saveup/screens/category/widgets/category_form.dart';
import 'package:saveup/state/app_state.dart';

class EditCategoryScreen extends StatelessWidget {
  final AppState appState;
  final CategoryModel category;

  const EditCategoryScreen({
    super.key,
    required this.appState,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Sửa danh mục'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CategoryForm(
                initialCategory: category,
                allowTypeChange: false,
                submitLabel: 'Cập nhật',
                onSubmit: (updatedCategory) =>
                    _saveCategory(context, updatedCategory),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _deleteCategory(context),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Xóa danh mục'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.expenseRed,
                  side: const BorderSide(color: AppColors.expenseRed),
                  minimumSize: const Size.fromHeight(54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveCategory(BuildContext context, CategoryModel updatedCategory) {
    appState.updateCategory(updatedCategory);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã cập nhật danh mục')));
    Navigator.pop(context, true);
  }

  Future<void> _deleteCategory(BuildContext context) async {
    if (!appState.canDeleteCategory(category.id)) {
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

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    final didDelete = appState.deleteCategory(category.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          didDelete
              ? 'Đã xóa danh mục'
              : 'Không thể xóa danh mục đang có giao dịch',
        ),
      ),
    );

    if (didDelete) {
      Navigator.pop(context, true);
    }
  }
}
