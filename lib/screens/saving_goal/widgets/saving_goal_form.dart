import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/models/saving_goal_model.dart';
import 'package:saveup/widgets/app_button.dart';
import 'package:saveup/widgets/app_text_field.dart';

class SavingGoalForm extends StatefulWidget {
  final SavingGoalModel? initialGoal;
  final String submitLabel;
  final ValueChanged<SavingGoalModel> onSubmit;

  const SavingGoalForm({
    super.key,
    required this.submitLabel,
    required this.onSubmit,
    this.initialGoal,
  });

  @override
  State<SavingGoalForm> createState() => _SavingGoalFormState();
}

class _SavingGoalFormState extends State<SavingGoalForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _currentAmountController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime? _selectedDeadline;
  var _submitted = false;

  @override
  void initState() {
    super.initState();
    final goal = widget.initialGoal;
    _nameController.text = goal?.name ?? '';
    _targetAmountController.text = goal == null
        ? ''
        : goal.targetAmount.round().toString();
    _currentAmountController.text = goal == null
        ? ''
        : goal.currentAmount.round().toString();
    _noteController.text = goal?.note ?? '';
    _selectedDeadline = goal?.deadline;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    _noteController.dispose();
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
            label: 'Tên mục tiêu',
            hintText: 'Ví dụ: Mua laptop',
            prefixIcon: Icons.flag_outlined,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Tên mục tiêu không được để trống';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _targetAmountController,
            label: 'Số tiền cần đạt',
            hintText: 'Ví dụ: 20000000',
            prefixIcon: Icons.savings_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: _validateTargetAmount,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _currentAmountController,
            label: 'Số tiền hiện có',
            hintText: 'Ví dụ: 5000000',
            prefixIcon: Icons.payments_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: _validateCurrentAmount,
          ),
          const SizedBox(height: 16),
          _DeadlineSelector(
            deadline: _selectedDeadline,
            errorText: _submitted && _selectedDeadline == null
                ? 'Phải chọn ngày hoàn thành'
                : null,
            onTap: _pickDeadline,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _noteController,
            label: 'Ghi chú',
            hintText: 'Nhập ghi chú nếu có',
            prefixIcon: Icons.notes_rounded,
            maxLines: 3,
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

  String? _validateTargetAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Số tiền cần đạt không được để trống';
    }

    final amount = _parseAmount(value);
    if (amount == null || amount <= 0) {
      return 'Số tiền cần đạt phải lớn hơn 0';
    }

    return null;
  }

  String? _validateCurrentAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final amount = _parseAmount(value);
    if (amount == null) {
      return 'Số tiền hiện có không hợp lệ';
    }

    if (amount < 0) {
      return 'Số tiền hiện có không được âm';
    }

    return null;
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate:
          _selectedDeadline ?? DateTime(now.year, now.month + 3, now.day),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 20),
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    setState(() {
      _selectedDeadline = pickedDate;
    });
  }

  void _submit() {
    setState(() {
      _submitted = true;
    });

    if (!_formKey.currentState!.validate() || _selectedDeadline == null) {
      return;
    }

    final now = DateTime.now();
    final goal = SavingGoalModel(
      id: widget.initialGoal?.id ?? 'goal_${now.millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      targetAmount: _parseAmount(_targetAmountController.text)!,
      currentAmount: _currentAmountController.text.trim().isEmpty
          ? 0
          : _parseAmount(_currentAmountController.text)!,
      deadline: _selectedDeadline!,
      note: _noteController.text.trim(),
    );

    widget.onSubmit(goal);
  }

  double? _parseAmount(String value) {
    final normalizedValue = value
        .trim()
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.tryParse(normalizedValue);
  }
}

class _DeadlineSelector extends StatelessWidget {
  final DateTime? deadline;
  final String? errorText;
  final VoidCallback onTap;

  const _DeadlineSelector({
    required this.deadline,
    required this.errorText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final errorText = this.errorText;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: errorText == null
                    ? const Color(0xFFE1E7F0)
                    : AppColors.expenseRed,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.textGray,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    deadline == null
                        ? 'Chọn ngày hoàn thành'
                        : _formatDate(deadline!),
                    style: TextStyle(
                      color: deadline == null
                          ? AppColors.textGray
                          : AppColors.darkBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textGray,
                ),
              ],
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                errorText,
                style: const TextStyle(
                  color: AppColors.expenseRed,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
