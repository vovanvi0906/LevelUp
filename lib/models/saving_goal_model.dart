import 'dart:math' as math;

class SavingGoalModel {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final String note;

  const SavingGoalModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.note,
  });

  double get progressPercent {
    if (targetAmount <= 0) {
      return 0;
    }

    final safeCurrentAmount = math.max(currentAmount, 0.0);
    return (safeCurrentAmount / targetAmount).clamp(0.0, 1.0).toDouble();
  }

  double get remainingAmount {
    if (targetAmount <= 0) {
      return 0;
    }

    final safeCurrentAmount = math.max(currentAmount, 0.0);
    return math.max(targetAmount - safeCurrentAmount, 0.0);
  }

  bool get isCompleted => progressPercent >= 1.0;

  SavingGoalModel copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    String? note,
  }) {
    return SavingGoalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      note: note ?? this.note,
    );
  }
}
