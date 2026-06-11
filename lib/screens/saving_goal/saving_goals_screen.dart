import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/screens/saving_goal/add_saving_goal_screen.dart';
import 'package:saveup/screens/saving_goal/saving_goal_detail_screen.dart';
import 'package:saveup/screens/saving_goal/widgets/saving_goal_card.dart';
import 'package:saveup/state/app_state.dart';
import 'package:saveup/widgets/app_card.dart';
import 'package:saveup/widgets/empty_state.dart';

class SavingGoalsScreen extends StatelessWidget {
  final AppState appState;

  const SavingGoalsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Mục tiêu tiết kiệm'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'saving_goals_add_fab',
        onPressed: () => _openAddGoal(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Thêm mục tiêu'),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: appState,
          builder: (context, _) {
            final goals = appState.savingGoals;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 90),
              child: goals.isEmpty
                  ? const AppCard(
                      child: EmptyState(
                        icon: Icons.flag_rounded,
                        title: 'Chưa có mục tiêu',
                        message:
                            'Thêm mục tiêu đầu tiên để theo dõi tiến độ tiết kiệm.',
                      ),
                    )
                  : Column(
                      children: goals
                          .map(
                            (goal) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: SavingGoalCard(
                                goal: goal,
                                onTap: () => _openGoalDetail(context, goal.id),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openAddGoal(BuildContext context) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AddSavingGoalScreen(appState: appState),
      ),
    );
  }

  Future<void> _openGoalDetail(BuildContext context, String goalId) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SavingGoalDetailScreen(appState: appState, goalId: goalId),
      ),
    );
  }
}
