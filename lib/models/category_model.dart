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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'iconName': iconName,
      'colorValue': colorValue,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: _readString(json['id'], 'category_unknown'),
      name: _readString(json['name'], 'Danh mục'),
      type: _parseTransactionType(json['type']),
      iconName: _readString(json['iconName'], 'more_horiz'),
      colorValue: _readInt(json['colorValue'], 0xFF94A3B8),
    );
  }

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

String _readString(Object? value, String fallback) {
  if (value is String && value.isNotEmpty) {
    return value;
  }
  return fallback;
}

int _readInt(Object? value, int fallback) {
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value) ?? fallback;
  }
  return fallback;
}

TransactionType _parseTransactionType(Object? value) {
  if (value == TransactionType.income.name) {
    return TransactionType.income;
  }
  return TransactionType.expense;
}
