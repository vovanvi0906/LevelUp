import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saveup/models/saving_goal_model.dart';
import 'package:saveup/screens/saving_goal/add_saving_goal_screen.dart';
import 'package:saveup/screens/saving_goal/saving_goals_screen.dart';
import 'package:saveup/screens/statistics/statistics_screen.dart';
import 'package:saveup/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('monthly statistics are calculated from mock data', () {
    final appState = AppState();
    final now = DateTime.now();

    expect(appState.incomeByMonth(now), closeTo(8000000, 0.0001));
    expect(appState.expenseByMonth(now), closeTo(400000, 0.0001));
    expect(
      appState.balanceByMonth(now),
      closeTo(
        appState.incomeByMonth(now) - appState.expenseByMonth(now),
        0.0001,
      ),
    );
  });

  test('top expense category and category percent are safe', () {
    final appState = AppState();
    final now = DateTime.now();
    final topCategory = appState.topExpenseCategory(now);

    expect(topCategory, isNotNull);

    final percent = appState.expensePercentByCategory(topCategory!.id, now);
    expect(percent, inInclusiveRange(0, 1));
    expect(appState.expensePercentByCategory('missing_category', now), 0);
  });

  test('saving goal AppState methods add, update, and delete goals', () {
    final appState = AppState();
    final initialCount = appState.savingGoals.length;
    final goal = _goal(id: 'goal_test_flow');

    appState.addSavingGoal(goal);
    expect(appState.savingGoals.length, initialCount + 1);

    appState.updateSavingGoal(goal.copyWith(currentAmount: 700000));
    expect(
      appState.findSavingGoalById('goal_test_flow')?.currentAmount,
      closeTo(700000, 0.0001),
    );

    expect(appState.deleteSavingGoal('goal_test_flow'), isTrue);
    expect(appState.findSavingGoalById('goal_test_flow'), isNull);
  });

  test('SavingGoalModel progress and remaining amount are clamped', () {
    final goal = _goal(
      id: 'goal_over_target',
      targetAmount: 1000000,
      currentAmount: 1500000,
    );

    expect(goal.progressPercent, 1);
    expect(goal.remainingAmount, 0);
  });

  testWidgets('StatisticsScreen renders statistics title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: StatisticsScreen(appState: AppState())),
    );

    expect(find.text('Thống kê'), findsOneWidget);
  });

  testWidgets('SavingGoalsScreen renders saving goals title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: SavingGoalsScreen(appState: AppState())),
    );

    expect(find.text('Mục tiêu tiết kiệm'), findsOneWidget);
  });

  testWidgets('AddSavingGoalScreen renders add title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: AddSavingGoalScreen(appState: AppState())),
    );

    expect(find.text('Thêm mục tiêu'), findsOneWidget);
  });
}

SavingGoalModel _goal({
  required String id,
  double targetAmount = 1000000,
  double currentAmount = 250000,
}) {
  return SavingGoalModel(
    id: id,
    name: 'Mục tiêu kiểm thử',
    targetAmount: targetAmount,
    currentAmount: currentAmount,
    deadline: DateTime.now().add(const Duration(days: 90)),
    note: 'Test',
  );
}
