enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String categoryId;
  final String walletId;
  final String note;
  final DateTime dateTime;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.walletId,
    required this.note,
    required this.dateTime,
  });

  bool get isIncome => type == TransactionType.income;

  bool get isExpense => type == TransactionType.expense;

  double get signedAmount => isIncome ? amount : -amount;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.name,
      'categoryId': categoryId,
      'walletId': walletId,
      'note': note,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: _readString(json['id'], 'transaction_unknown'),
      title: _readString(json['title'], 'Giao dịch'),
      amount: _readDouble(json['amount']),
      type: _parseTransactionType(json['type']),
      categoryId: _readString(json['categoryId'], 'category_other_expense'),
      walletId: _readString(json['walletId'], 'wallet_cash'),
      note: _readString(json['note'], ''),
      dateTime: _parseDateTime(json['dateTime']),
    );
  }

  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    String? categoryId,
    String? walletId,
    String? note,
    DateTime? dateTime,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      walletId: walletId ?? this.walletId,
      note: note ?? this.note,
      dateTime: dateTime ?? this.dateTime,
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

TransactionType _parseTransactionType(Object? value) {
  if (value == TransactionType.income.name) {
    return TransactionType.income;
  }
  return TransactionType.expense;
}

DateTime _parseDateTime(Object? value) {
  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.now();
  }
  return DateTime.now();
}
