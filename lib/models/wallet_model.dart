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
