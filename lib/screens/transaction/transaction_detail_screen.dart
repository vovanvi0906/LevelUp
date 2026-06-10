import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/core/utils/currency_formatter.dart';
import 'package:saveup/models/transaction_model.dart';
import 'package:saveup/screens/transaction/edit_transaction_screen.dart';
import 'package:saveup/state/app_state.dart';
import 'package:saveup/widgets/app_button.dart';
import 'package:saveup/widgets/app_card.dart';

class TransactionDetailScreen extends StatefulWidget {
  final AppState appState;
  final String transactionId;
  final VoidCallback onTransactionChanged;

  const TransactionDetailScreen({
    super.key,
    required this.appState,
    required this.transactionId,
    required this.onTransactionChanged,
  });

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final transaction = widget.appState.findTransactionById(
      widget.transactionId,
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Chi tiết giao dịch'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: SafeArea(
        child: transaction == null
            ? const Center(child: Text('Không tìm thấy giao dịch'))
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: _DetailContent(
                  appState: widget.appState,
                  transaction: transaction,
                  onEdit: () => _openEditScreen(transaction),
                  onDelete: () => _confirmDelete(transaction),
                ),
              ),
      ),
    );
  }

  Future<void> _openEditScreen(TransactionModel transaction) async {
    final didUpdate = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditTransactionScreen(
          appState: widget.appState,
          transaction: transaction,
        ),
      ),
    );

    if (didUpdate != true || !mounted) {
      return;
    }

    widget.onTransactionChanged();
    setState(() {});
  }

  Future<void> _confirmDelete(TransactionModel transaction) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa giao dịch?'),
        content: const Text('Bạn có chắc muốn xóa giao dịch này không?'),
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

    if (shouldDelete != true || !mounted) {
      return;
    }

    widget.appState.deleteTransaction(transaction.id);
    widget.onTransactionChanged();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã xóa giao dịch')));
    Navigator.pop(context, true);
  }
}

class _DetailContent extends StatelessWidget {
  final AppState appState;
  final TransactionModel transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DetailContent({
    required this.appState,
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final category = appState.findCategoryById(transaction.categoryId);
    final wallet = appState.findWalletById(transaction.walletId);
    final amountColor = transaction.isIncome
        ? AppColors.primaryGreen
        : AppColors.expenseRed;
    final amountPrefix = transaction.isIncome ? '+' : '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: Column(
            children: [
              Icon(
                transaction.isIncome
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: amountColor,
                size: 42,
              ),
              const SizedBox(height: 12),
              Text(
                '$amountPrefix${CurrencyFormatter.formatVnd(transaction.amount)}',
                style: TextStyle(
                  color: amountColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                transaction.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            children: [
              _InfoRow(
                label: 'Loại giao dịch',
                value: transaction.isIncome ? 'Thu nhập' : 'Chi tiêu',
              ),
              _InfoRow(label: 'Danh mục', value: category?.name ?? 'Không rõ'),
              _InfoRow(label: 'Ví sử dụng', value: wallet?.name ?? 'Không rõ'),
              _InfoRow(
                label: 'Ngày giờ',
                value: _formatDateTime(transaction.dateTime),
              ),
              _InfoRow(
                label: 'Ghi chú',
                value: transaction.note.isEmpty
                    ? 'Không có ghi chú'
                    : transaction.note,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AppButton(label: 'Sửa', icon: Icons.edit_rounded, onPressed: onEdit),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline_rounded),
          label: const Text('Xóa'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.expenseRed,
            side: const BorderSide(color: AppColors.expenseRed),
            minimumSize: const Size.fromHeight(54),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute - $day/$month/${dateTime.year}';
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
