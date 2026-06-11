enum WalletType { cash, bank, eWallet, saving, other }

class WalletModel {
  final String id;
  final String name;
  final double balance;
  final WalletType type;
  final String iconName;
  final int colorValue;

  const WalletModel({
    required this.id,
    required this.name,
    required this.balance,
    required this.type,
    required this.iconName,
    required this.colorValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'type': type.name,
      'iconName': iconName,
      'colorValue': colorValue,
    };
  }

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: _readString(json['id'], 'wallet_unknown'),
      name: _readString(json['name'], 'Ví'),
      balance: _readDouble(json['balance']),
      type: _parseWalletType(json['type']),
      iconName: _readString(json['iconName'], 'wallet'),
      colorValue: _readInt(json['colorValue'], 0xFF1267E8),
    );
  }

  WalletModel copyWith({
    String? id,
    String? name,
    double? balance,
    WalletType? type,
    String? iconName,
    int? colorValue,
  }) {
    return WalletModel(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
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

double _readDouble(Object? value) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value) ?? 0;
  }
  return 0;
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

WalletType _parseWalletType(Object? value) {
  for (final type in WalletType.values) {
    if (value == type.name) {
      return type;
    }
  }
  return WalletType.other;
}
