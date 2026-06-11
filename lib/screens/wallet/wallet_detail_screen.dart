import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/core/utils/currency_formatter.dart';
import 'package:saveup/core/utils/model_display.dart';
import 'package:saveup/models/transaction_model.dart';
import 'package:saveup/models/wallet_model.dart';
import 'package:saveup/screens/transaction/transaction_detail_screen.dart';
import 'package:saveup/screens/wallet/edit_wallet_screen.dart';
import 'package:saveup/state/app_state.dart';
import 'package:saveup/widgets/app_button.dart';
import 'package:saveup/widgets/app_card.dart';
import 'package:saveup/widgets/empty_state.dart';
import 'package:saveup/widgets/transaction_tile.dart';

class WalletDetailScreen extends StatelessWidget {
  final AppState appState;
  final String walletId;

  const WalletDetailScreen({
    super.key,
    required this.appState,
    required this.walletId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Chi tiết ví'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: appState,
          builder: (context, _) {
            final wallet = appState.findWalletById(walletId);

            if (wallet == null) {
              return const Center(child: Text('Không tìm thấy ví'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: _WalletDetailContent(
                appState: appState,
                wallet: wallet,
                onEdit: () => _openEditScreen(context, wallet),
                onDelete: () => _deleteWallet(context, wallet),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openEditScreen(BuildContext context, WalletModel wallet) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditWalletScreen(appState: appState, wallet: wallet),
      ),
    );
  }

  Future<void> _deleteWallet(BuildContext context, WalletModel wallet) async {
    if (!appState.canDeleteWallet(wallet.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể xóa ví đang có giao dịch')),
      );
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa ví?'),
        content: Text('Bạn có chắc muốn xóa ví "${wallet.name}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    final didDelete = appState.deleteWallet(wallet.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          didDelete ? 'Đã xóa ví' : 'Không thể xóa ví đang có giao dịch',
        ),
      ),
    );

    if (didDelete) {
      Navigator.pop(context, true);
    }
  }
}

class _WalletDetailContent extends StatelessWidget {
  final AppState appState;
  final WalletModel wallet;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _WalletDetailContent({
    required this.appState,
    required this.wallet,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final transactions = appState.transactionsByWallet(wallet.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WalletHeroCard(wallet: wallet),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _WalletMetricCard(
                label: 'Tổng thu',
                amount: appState.walletIncome(wallet.id),
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _WalletMetricCard(
                label: 'Tổng chi',
                amount: appState.walletExpense(wallet.id),
                color: AppColors.expenseRed,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            children: [
              _InfoRow(
                label: 'Loại ví',
                value: ModelDisplay.walletTypeLabel(wallet.type),
              ),
              _InfoRow(label: 'Số giao dịch', value: '${transactions.length}'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Giao dịch của ví',
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        if (transactions.isEmpty)
          const AppCard(
            child: EmptyState(
              icon: Icons.receipt_long_rounded,
              title: 'Chưa có giao dịch',
              message: 'Các giao dịch dùng ví này sẽ hiển thị tại đây.',
            ),
          )
        else
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              children: transactions
                  .map(
                    (transaction) => _WalletTransactionItem(
                      appState: appState,
                      transaction: transaction,
                    ),
                  )
                  .toList(),
            ),
          ),
        const SizedBox(height: 20),
        AppButton(label: 'Sửa ví', icon: Icons.edit_rounded, onPressed: onEdit),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline_rounded),
          label: const Text('Xóa ví'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.expenseRed,
            side: const BorderSide(color: AppColors.expenseRed),
            minimumSize: const Size.fromHeight(54),
          ),
        ),
      ],
    );
  }
}

class _WalletHeroCard extends StatelessWidget {
  final WalletModel wallet;

  const _WalletHeroCard({required this.wallet});

  @override
  Widget build(BuildContext context) {
    final walletColor = Color(wallet.colorValue);

    return AppCard(
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: walletColor,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(
              ModelDisplay.walletIcon(wallet.iconName),
              color: AppColors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            wallet.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.darkBlue,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.formatVnd(wallet.balance),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: walletColor,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletMetricCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _WalletMetricCard({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textGray,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.formatVnd(amount),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletTransactionItem extends StatelessWidget {
  final AppState appState;
  final TransactionModel transaction;

  const _WalletTransactionItem({
    required this.appState,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailScreen(
              appState: appState,
              transactionId: transaction.id,
              onTransactionChanged: () {},
            ),
          ),
        );
      },
      child: TransactionTile(
        transaction: transaction,
        category: appState.findCategoryById(transaction.categoryId),
        wallet: appState.findWalletById(transaction.walletId),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textGray,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.darkBlue,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
