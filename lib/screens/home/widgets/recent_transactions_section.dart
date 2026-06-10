import 'package:flutter/material.dart';
import 'package:saveup/state/app_state.dart';
import 'package:saveup/widgets/app_card.dart';
import 'package:saveup/widgets/empty_state.dart';
import 'package:saveup/widgets/section_header.dart';
import 'package:saveup/widgets/transaction_tile.dart';

class RecentTransactionsSection extends StatelessWidget {
  final AppState appState;

  const RecentTransactionsSection({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final transactions = appState.recentTransactions.take(5).toList();

    return AppCard(
      child: Column(
        children: [
          const SectionHeader(title: 'Giao dịch gần đây'),
          if (transactions.isEmpty)
            const EmptyState(
              icon: Icons.receipt_long_rounded,
              title: 'Chưa có giao dịch',
              message: 'Các khoản thu chi mới nhất sẽ hiển thị ở đây.',
            )
          else
            ...transactions.map(
              (transaction) => TransactionTile(
                transaction: transaction,
                category: appState.findCategoryById(transaction.categoryId),
                wallet: appState.findWalletById(transaction.walletId),
              ),
            ),
        ],
      ),
    );
  }
}
