import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/models/wallet_model.dart';
import 'package:saveup/screens/wallet/widgets/wallet_form.dart';
import 'package:saveup/state/app_state.dart';

class EditWalletScreen extends StatelessWidget {
  final AppState appState;
  final WalletModel wallet;

  const EditWalletScreen({
    super.key,
    required this.appState,
    required this.wallet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Sửa ví'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: WalletForm(
            initialWallet: wallet,
            submitLabel: 'Cập nhật ví',
            onSubmit: (updatedWallet) => _saveWallet(context, updatedWallet),
          ),
        ),
      ),
    );
  }

  void _saveWallet(BuildContext context, WalletModel updatedWallet) {
    appState.updateWallet(updatedWallet);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã cập nhật ví')));
    Navigator.pop(context, true);
  }
}
