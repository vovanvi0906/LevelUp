import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/core/utils/currency_formatter.dart';
import 'package:saveup/models/saving_goal_model.dart';
import 'package:saveup/screens/saving_goal/edit_saving_goal_screen.dart';
import 'package:saveup/state/app_state.dart';
import 'package:saveup/widgets/app_button.dart';
import 'package:saveup/widgets/app_card.dart';

class SavingGoalDetailScreen extends StatelessWidget {
  final AppState appState;
  final String goalId;

  const SavingGoalDetailScreen({
    super.key,
    required this.appState,
    required this.goalId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Chi tiết mục tiêu'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: appState,
          builder: (context, _) {
            final goal = appState.findSavingGoalById(goalId);

            if (goal == null) {
              return const Center(child: Text('Không tìm thấy mục tiêu'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: _GoalDetailContent(
                appState: appState,
                goal: goal,
                onUpdateAmount: () => _showUpdateAmountDialog(context, goal),
                onEdit: () => _openEditScreen(context, goal),
                onDelete: () => _confirmDelete(context, goal),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openEditScreen(
    BuildContext context,
    SavingGoalModel goal,
  ) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditSavingGoalScreen(appState: appState, goal: goal),
      ),
    );
  }

  Future<void> _showUpdateAmountDialog(
    BuildContext context,
    SavingGoalModel goal,
  ) async {
    final controller = TextEditingController(
      text: goal.currentAmount.round().toString(),
    );

    final newAmount = await showDialog<double>(
      context: context,
      builder: (context) => _UpdateAmountDialog(controller: controller),
    );

    controller.dispose();

    if (newAmount == null || !context.mounted) {
      return;
    }

    appState.updateSavingGoal(goal.copyWith(currentAmount: newAmount));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã cập nhật số tiền')));
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SavingGoalModel goal,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa mục tiêu?'),
        content: Text('Bạn có chắc muốn xóa mục tiêu "${goal.name}" không?'),
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

    final didDelete = appState.deleteSavingGoal(goal.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(didDelete ? 'Đã xóa mục tiêu' : 'Không thể xóa mục tiêu'),
      ),
    );

    if (didDelete) {
      Navigator.pop(context, true);
    }
  }
}

class _GoalDetailContent extends StatelessWidget {
  final AppState appState;
  final SavingGoalModel goal;
  final VoidCallback onUpdateAmount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GoalDetailContent({
    required this.appState,
    required this.goal,
    required this.onUpdateAmount,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final progressText = '${(goal.progressPercent * 100).round()}%';
    final monthlyNeed = _monthlyNeededAmount(goal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: Column(
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.flag_rounded,
                  color: AppColors.primaryBlue,
                  size: 34,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                goal.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                progressText,
                style: const TextStyle(
                  color: AppColors.primaryGreen,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 12,
                  value: goal.progressPercent,
                  backgroundColor: AppColors.primaryBlue.withValues(
                    alpha: 0.12,
                  ),
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            children: [
              _InfoRow(
                label: 'Cần đạt',
                value: CurrencyFormatter.formatVnd(goal.targetAmount),
              ),
              _InfoRow(
                label: 'Đã tiết kiệm',
                value: CurrencyFormatter.formatVnd(goal.currentAmount),
              ),
              _InfoRow(
                label: 'Còn thiếu',
                value: CurrencyFormatter.formatVnd(goal.remainingAmount),
              ),
              _InfoRow(label: 'Deadline', value: _formatDate(goal.deadline)),
              _InfoRow(
                label: 'Mỗi tháng cần',
                value: monthlyNeed == null
                    ? 'Không cần thêm'
                    : CurrencyFormatter.formatVnd(monthlyNeed),
              ),
              _InfoRow(
                label: 'Ghi chú',
                value: goal.note.isEmpty ? 'Không có ghi chú' : goal.note,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AppButton(
          label: 'Cập nhật số tiền',
          icon: Icons.payments_rounded,
          onPressed: onUpdateAmount,
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_rounded),
          label: const Text('Sửa mục tiêu'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryBlue,
            side: const BorderSide(color: AppColors.primaryBlue),
            minimumSize: const Size.fromHeight(54),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline_rounded),
          label: const Text('Xóa mục tiêu'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.expenseRed,
            side: const BorderSide(color: AppColors.expenseRed),
            minimumSize: const Size.fromHeight(54),
          ),
        ),
      ],
    );
  }

  double? _monthlyNeededAmount(SavingGoalModel goal) {
    if (goal.remainingAmount <= 0 || !goal.deadline.isAfter(DateTime.now())) {
      return null;
    }

    final now = DateTime.now();
    final months =
        (goal.deadline.year - now.year) * 12 + goal.deadline.month - now.month;
    final safeMonths = months <= 0 ? 1 : months;
    return goal.remainingAmount / safeMonths;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.darkBlue,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpdateAmountDialog extends StatefulWidget {
  final TextEditingController controller;

  const _UpdateAmountDialog({required this.controller});

  @override
  State<_UpdateAmountDialog> createState() => _UpdateAmountDialogState();
}

class _UpdateAmountDialogState extends State<_UpdateAmountDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cập nhật số tiền'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Số tiền hiện có',
            hintText: 'Ví dụ: 5000000',
          ),
          validator: (value) {
            final amount = _parseAmount(value ?? '');

            if (amount == null) {
              return 'Số tiền không hợp lệ';
            }

            if (amount < 0) {
              return 'Số tiền hiện có không được âm';
            }

            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            Navigator.pop(context, _parseAmount(widget.controller.text));
          },
          child: const Text('Cập nhật'),
        ),
      ],
    );
  }

  double? _parseAmount(String value) {
    final normalizedValue = value
        .trim()
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.tryParse(normalizedValue);
  }
}
