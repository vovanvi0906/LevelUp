import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/models/saving_goal_model.dart';
import 'package:saveup/screens/saving_goal/widgets/saving_goal_form.dart';
import 'package:saveup/state/app_state.dart';

class EditSavingGoalScreen extends StatelessWidget {
  final AppState appState;
  final SavingGoalModel goal;

  const EditSavingGoalScreen({
    super.key,
    required this.appState,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Sửa mục tiêu'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: SavingGoalForm(
            initialGoal: goal,
            submitLabel: 'Cập nhật',
            onSubmit: (updatedGoal) => _saveGoal(context, updatedGoal),
          ),
        ),
      ),
    );
  }

  void _saveGoal(BuildContext context, SavingGoalModel updatedGoal) {
    appState.updateSavingGoal(updatedGoal);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã cập nhật mục tiêu')));
    Navigator.pop(context, true);
  }
}
