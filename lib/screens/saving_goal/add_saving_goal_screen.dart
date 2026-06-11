import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/models/saving_goal_model.dart';
import 'package:saveup/screens/saving_goal/widgets/saving_goal_form.dart';
import 'package:saveup/state/app_state.dart';

class AddSavingGoalScreen extends StatelessWidget {
  final AppState appState;

  const AddSavingGoalScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Thêm mục tiêu'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: SavingGoalForm(
            submitLabel: 'Lưu mục tiêu',
            onSubmit: (goal) => _saveGoal(context, goal),
          ),
        ),
      ),
    );
  }

  void _saveGoal(BuildContext context, SavingGoalModel goal) {
    appState.addSavingGoal(goal);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã thêm mục tiêu')));
    Navigator.pop(context, true);
  }
}
