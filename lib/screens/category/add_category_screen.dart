import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/models/category_model.dart';
import 'package:saveup/screens/category/widgets/category_form.dart';
import 'package:saveup/state/app_state.dart';

class AddCategoryScreen extends StatelessWidget {
  final AppState appState;

  const AddCategoryScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Thêm danh mục'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: CategoryForm(
            submitLabel: 'Lưu danh mục',
            onSubmit: (category) => _saveCategory(context, category),
          ),
        ),
      ),
    );
  }

  void _saveCategory(BuildContext context, CategoryModel category) {
    appState.addCategory(category);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã thêm danh mục')));
    Navigator.pop(context, true);
  }
}
