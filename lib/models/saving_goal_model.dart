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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'deadline': deadline.toIso8601String(),
      'note': note,
    };
  }

  factory SavingGoalModel.fromJson(Map<String, dynamic> json) {
    return SavingGoalModel(
      id: _readString(json['id'], 'goal_unknown'),
      name: _readString(json['name'], 'Mục tiêu'),
      targetAmount: _readDouble(json['targetAmount']),
      currentAmount: _readDouble(json['currentAmount']),
      deadline: _parseDateTime(json['deadline']),
      note: _readString(json['note'], ''),
    );
  }

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

String _readString(Object? value, String fallback) {
  if (value is String && value.isNotEmpty) {
    return value;
  }
  return fallback;
}

double _readDouble(Object? value) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value) ?? 0;
  }
  return 0;
}

DateTime _parseDateTime(Object? value) {
  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.now();
  }
  return DateTime.now();
}
