import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/core/utils/currency_formatter.dart';
import 'package:saveup/models/saving_goal_model.dart';
import 'package:saveup/widgets/app_card.dart';
import 'package:saveup/widgets/empty_state.dart';
import 'package:saveup/widgets/section_header.dart';

class SavingGoalPreviewCard extends StatelessWidget {
  final List<SavingGoalModel> savingGoals;

  const SavingGoalPreviewCard({super.key, required this.savingGoals});

  @override
  Widget build(BuildContext context) {
    final goal = _firstActiveGoal;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Mục tiêu tiết kiệm'),
          if (goal == null)
            const EmptyState(
              icon: Icons.flag_rounded,
              title: 'Chưa có mục tiêu',
              message: 'Mục tiêu tiết kiệm gần nhất sẽ hiển thị ở đây.',
            )
          else
            _GoalContent(goal: goal),
        ],
      ),
    );
  }

  SavingGoalModel? get _firstActiveGoal {
    for (final goal in savingGoals) {
      if (!goal.isCompleted) {
        return goal;
      }
    }

    return savingGoals.isEmpty ? null : savingGoals.first;
  }
}

class _GoalContent extends StatelessWidget {
  final SavingGoalModel goal;

  const _GoalContent({required this.goal});

  @override
  Widget build(BuildContext context) {
    final progressText = '${(goal.progressPercent * 100).round()}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          goal.name,
          style: const TextStyle(
            color: AppColors.darkBlue,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${CurrencyFormatter.formatVnd(goal.currentAmount)} / '
          '${CurrencyFormatter.formatVnd(goal.targetAmount)}',
          style: const TextStyle(
            color: AppColors.textGray,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 10,
            value: goal.progressPercent,
            backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.12),
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            progressText,
            style: const TextStyle(
              color: AppColors.primaryGreen,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
