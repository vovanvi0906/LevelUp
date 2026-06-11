import 'package:flutter/material.dart';
import 'package:saveup/models/transaction_model.dart';
import 'package:saveup/models/wallet_model.dart';

class ModelDisplay {
  const ModelDisplay._();

  static String walletTypeLabel(WalletType type) {
    switch (type) {
      case WalletType.cash:
        return 'Tiền mặt';
      case WalletType.bank:
        return 'Ngân hàng';
      case WalletType.eWallet:
        return 'Ví điện tử';
      case WalletType.saving:
        return 'Ví tiết kiệm';
      case WalletType.other:
        return 'Khác';
    }
  }

  static String transactionTypeLabel(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return 'Thu nhập';
      case TransactionType.expense:
        return 'Chi tiêu';
    }
  }

  static IconData walletIcon(String iconName) {
    switch (iconName) {
      case 'account_balance':
        return Icons.account_balance_rounded;
      case 'credit_card':
        return Icons.credit_card_rounded;
      case 'payment':
        return Icons.phone_android_rounded;
      case 'savings':
        return Icons.savings_rounded;
      case 'wallet':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.wallet_rounded;
    }
  }

  static IconData categoryIcon(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'directions_car':
        return Icons.directions_car_rounded;
      case 'shopping_bag':
        return Icons.shopping_bag_rounded;
      case 'receipt':
        return Icons.receipt_rounded;
      case 'movie':
        return Icons.movie_rounded;
      case 'school':
        return Icons.school_rounded;
      case 'health_and_safety':
        return Icons.health_and_safety_rounded;
      case 'home':
        return Icons.home_rounded;
      case 'savings':
        return Icons.savings_rounded;
      case 'payments':
        return Icons.payments_rounded;
      case 'redeem':
        return Icons.redeem_rounded;
      case 'trending_up':
        return Icons.trending_up_rounded;
      case 'card_giftcard':
        return Icons.card_giftcard_rounded;
      default:
        return Icons.more_horiz_rounded;
    }
  }
}
