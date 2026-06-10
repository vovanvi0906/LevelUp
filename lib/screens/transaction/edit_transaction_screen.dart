import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/models/transaction_model.dart';
import 'package:saveup/screens/transaction/widgets/transaction_form.dart';
import 'package:saveup/state/app_state.dart';

class EditTransactionScreen extends StatelessWidget {
  final AppState appState;
  final TransactionModel transaction;

  const EditTransactionScreen({
    super.key,
    required this.appState,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Sửa giao dịch'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: TransactionForm(
            appState: appState,
            initialTransaction: transaction,
            submitLabel: 'Cập nhật',
            onSubmit: (updatedTransaction) {
              appState.updateTransaction(updatedTransaction);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã cập nhật giao dịch')),
              );
              Navigator.pop(context, true);
            },
          ),
        ),
      ),
    );
  }
}
