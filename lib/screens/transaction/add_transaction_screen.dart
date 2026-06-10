import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/models/transaction_model.dart';
import 'package:saveup/screens/transaction/widgets/transaction_form.dart';
import 'package:saveup/state/app_state.dart';

class AddTransactionScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onTransactionSaved;

  const AddTransactionScreen({
    super.key,
    required this.appState,
    required this.onTransactionSaved,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  var _formVersion = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Thêm giao dịch'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: TransactionForm(
            key: ValueKey(_formVersion),
            appState: widget.appState,
            submitLabel: 'Lưu giao dịch',
            onSubmit: _saveTransaction,
          ),
        ),
      ),
    );
  }

  void _saveTransaction(TransactionModel transaction) {
    widget.appState.addTransaction(transaction);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã thêm giao dịch')));
    setState(() {
      _formVersion++;
    });
    widget.onTransactionSaved();
  }
}
