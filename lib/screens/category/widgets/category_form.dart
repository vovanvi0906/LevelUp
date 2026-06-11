import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/core/utils/model_display.dart';
import 'package:saveup/models/category_model.dart';
import 'package:saveup/models/transaction_model.dart';
import 'package:saveup/widgets/app_button.dart';
import 'package:saveup/widgets/app_text_field.dart';

const _categoryIconNames = [
  'restaurant',
  'directions_car',
  'shopping_bag',
  'receipt',
  'movie',
  'school',
  'health_and_safety',
  'home',
  'savings',
  'payments',
  'trending_up',
  'more_horiz',
];

const _categoryColorValues = [
  0xFF26B83F,
  0xFF1267E8,
  0xFFE93655,
  0xFF8B5CF6,
  0xFFF59E0B,
  0xFF14B8A6,
  0xFFEF4444,
  0xFF64748B,
];

class CategoryForm extends StatefulWidget {
  final CategoryModel? initialCategory;
  final String submitLabel;
  final bool allowTypeChange;
  final ValueChanged<CategoryModel> onSubmit;

  const CategoryForm({
    super.key,
    required this.submitLabel,
    required this.onSubmit,
    this.initialCategory,
    this.allowTypeChange = true,
  });

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  TransactionType? _categoryType;
  late String _iconName;
  late int _colorValue;

  @override
  void initState() {
    super.initState();
    final category = widget.initialCategory;
    _nameController.text = category?.name ?? '';
    _categoryType = category?.type;
    _iconName = category?.iconName ?? 'restaurant';
    _colorValue = category?.colorValue ?? _categoryColorValues.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _nameController,
            label: 'Tên danh mục',
            hintText: 'Ví dụ: Ăn uống',
            prefixIcon: Icons.category_outlined,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Tên danh mục không được để trống';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          if (widget.allowTypeChange)
            DropdownButtonFormField<TransactionType>(
              initialValue: _categoryType,
              isExpanded: true,
              decoration: _inputDecoration(
                label: 'Loại danh mục',
                icon: Icons.swap_vert_rounded,
              ),
              hint: const Text('Chọn loại danh mục'),
              validator: (value) {
                if (value == null) {
                  return 'Phải chọn loại Thu/Chi';
                }
                return null;
              },
              items: TransactionType.values
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(ModelDisplay.transactionTypeLabel(type)),
                    ),
                  )
                  .toList(),
              onChanged: (type) {
                setState(() {
                  _categoryType = type;
                });
              },
            )
          else
            _ReadOnlyTypeField(type: _categoryType ?? TransactionType.expense),
          const SizedBox(height: 18),
          _IconPicker(
            selectedIconName: _iconName,
            selectedColorValue: _colorValue,
            onChanged: (iconName) {
              setState(() {
                _iconName = iconName;
              });
            },
          ),
          const SizedBox(height: 18),
          _ColorPicker(
            selectedColorValue: _colorValue,
            onChanged: (colorValue) {
              setState(() {
                _colorValue = colorValue;
              });
            },
          ),
          const SizedBox(height: 24),
          AppButton(
            label: widget.submitLabel,
            icon: Icons.check_rounded,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFFF7F9FC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFE1E7F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFE1E7F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.expenseRed),
      ),
    );
  }

  void _submit() {
    final categoryType = _categoryType;

    if (!_formKey.currentState!.validate() || categoryType == null) {
      return;
    }

    final now = DateTime.now();
    final category = CategoryModel(
      id:
          widget.initialCategory?.id ??
          'category_${now.millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      type: categoryType,
      iconName: _iconName,
      colorValue: _colorValue,
    );

    widget.onSubmit(category);
  }
}

class _ReadOnlyTypeField extends StatelessWidget {
  final TransactionType type;

  const _ReadOnlyTypeField({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE1E7F0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.swap_vert_rounded, color: AppColors.textGray),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ModelDisplay.transactionTypeLabel(type),
              style: const TextStyle(
                color: AppColors.darkBlue,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Text(
            'Không đổi loại',
            style: TextStyle(
              color: AppColors.textGray,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconPicker extends StatelessWidget {
  final String selectedIconName;
  final int selectedColorValue;
  final ValueChanged<String> onChanged;

  const _IconPicker({
    required this.selectedIconName,
    required this.selectedColorValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = Color(selectedColorValue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Icon danh mục',
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _categoryIconNames.map((iconName) {
            final isSelected = selectedIconName == iconName;
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => onChanged(iconName),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedColor.withValues(alpha: 0.14)
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? selectedColor : const Color(0xFFE1E7F0),
                    width: isSelected ? 1.6 : 1,
                  ),
                ),
                child: Icon(
                  ModelDisplay.categoryIcon(iconName),
                  color: isSelected ? selectedColor : AppColors.textGray,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final int selectedColorValue;
  final ValueChanged<int> onChanged;

  const _ColorPicker({
    required this.selectedColorValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Màu danh mục',
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _categoryColorValues.map((colorValue) {
            final color = Color(colorValue);
            final isSelected = selectedColorValue == colorValue;
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => onChanged(colorValue),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? AppColors.darkBlue : color,
                    width: isSelected ? 2.4 : 1,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: AppColors.white,
                        size: 22,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
