import 'package:saveup/models/transaction_model.dart';

class CategoryModel {
  final String id;
  final String name;
  final TransactionType type;
  final String iconName;
  final int colorValue;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.iconName,
    required this.colorValue,
  });

  bool get isIncome => type == TransactionType.income;

  bool get isExpense => type == TransactionType.expense;

  CategoryModel copyWith({
    String? id,
    String? name,
    TransactionType? type,
    String? iconName,
    int? colorValue,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      iconName: iconName ?? this.iconName,
      colorValue: colorValue ?? this.colorValue,
    );
  }
}
