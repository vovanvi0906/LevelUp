import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/models/transaction_model.dart';
import 'package:saveup/screens/transaction/transaction_detail_screen.dart';
import 'package:saveup/state/app_state.dart';
import 'package:saveup/widgets/empty_state.dart';
import 'package:saveup/widgets/transaction_tile.dart';

enum _TransactionFilter { all, income, expense }

class TransactionListScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onAddTransactionTap;
  final VoidCallback onTransactionChanged;

  const TransactionListScreen({
    super.key,
    required this.appState,
    required this.onAddTransactionTap,
    required this.onTransactionChanged,
  });

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  var _selectedFilter = _TransactionFilter.all;
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final transactions = _filteredTransactions;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Giao dịch'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'transaction_list_add_fab',
        onPressed: widget.onAddTransactionTap,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Thêm'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _FilterTabs(
                selectedFilter: _selectedFilter,
                onChanged: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              ),
              const SizedBox(height: 14),
              _MonthFilter(
                selectedMonth: _selectedMonth,
                onPreviousMonth: () {
                  setState(() {
                    _selectedMonth = DateTime(
                      _selectedMonth.year,
                      _selectedMonth.month - 1,
                    );
                  });
                },
                onNextMonth: () {
                  setState(() {
                    _selectedMonth = DateTime(
                      _selectedMonth.year,
                      _selectedMonth.month + 1,
                    );
                  });
                },
              ),
              const SizedBox(height: 18),
              if (transactions.isEmpty)
                const EmptyState(
                  icon: Icons.receipt_long_rounded,
                  title: 'Chưa có giao dịch',
                  message: 'Các khoản thu chi phù hợp sẽ hiển thị tại đây.',
                )
              else
                ...transactions.map(
                  (transaction) => _TransactionListItem(
                    appState: widget.appState,
                    transaction: transaction,
                    onTap: () => _openDetail(transaction),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<TransactionModel> get _filteredTransactions {
    final transactions = widget.appState.transactionsByMonth(_selectedMonth);

    switch (_selectedFilter) {
      case _TransactionFilter.income:
        return transactions
            .where((transaction) => transaction.isIncome)
            .toList();
      case _TransactionFilter.expense:
        return transactions
            .where((transaction) => transaction.isExpense)
            .toList();
      case _TransactionFilter.all:
        return transactions;
    }
  }

  Future<void> _openDetail(TransactionModel transaction) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionDetailScreen(
          appState: widget.appState,
          transactionId: transaction.id,
          onTransactionChanged: () {
            widget.onTransactionChanged();
          },
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }
}

class _TransactionListItem extends StatelessWidget {
  final AppState appState;
  final TransactionModel transaction;
  final VoidCallback onTap;

  const _TransactionListItem({
    required this.appState,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE7ECF5)),
        ),
        child: TransactionTile(
          transaction: transaction,
          category: appState.findCategoryById(transaction.categoryId),
          wallet: appState.findWalletById(transaction.walletId),
        ),
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  final _TransactionFilter selectedFilter;
  final ValueChanged<_TransactionFilter> onChanged;

  const _FilterTabs({required this.selectedFilter, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<_TransactionFilter>(
      segments: const [
        ButtonSegment(value: _TransactionFilter.all, label: Text('Tất cả')),
        ButtonSegment(value: _TransactionFilter.income, label: Text('Thu')),
        ButtonSegment(value: _TransactionFilter.expense, label: Text('Chi')),
      ],
      selected: {selectedFilter},
      onSelectionChanged: (selection) {
        onChanged(selection.first);
      },
    );
  }
}

class _MonthFilter extends StatelessWidget {
  final DateTime selectedMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const _MonthFilter({
    required this.selectedMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPreviousMonth,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Text(
            'Tháng ${selectedMonth.month}/${selectedMonth.year}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.darkBlue,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        IconButton(
          onPressed: onNextMonth,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}
