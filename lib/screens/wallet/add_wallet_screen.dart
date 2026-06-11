import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/models/wallet_model.dart';
import 'package:saveup/screens/wallet/widgets/wallet_form.dart';
import 'package:saveup/state/app_state.dart';

class AddWalletScreen extends StatelessWidget {
  final AppState appState;

  const AddWalletScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Thêm ví'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: WalletForm(
            submitLabel: 'Lưu ví',
            onSubmit: (wallet) => _saveWallet(context, wallet),
          ),
        ),
      ),
    );
  }

  void _saveWallet(BuildContext context, WalletModel wallet) {
    appState.addWallet(wallet);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã thêm ví')));
    Navigator.pop(context, true);
  }
}
