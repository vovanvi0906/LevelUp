import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/models/wallet_model.dart';
import 'package:saveup/state/app_state.dart';
import 'package:saveup/widgets/empty_state.dart';
import 'package:saveup/widgets/wallet_card.dart';

class SelectWalletScreen extends StatelessWidget {
  final AppState appState;

  const SelectWalletScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final wallets = appState.wallets;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Chọn ví'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: wallets.isEmpty
              ? const EmptyState(
                  icon: Icons.account_balance_wallet_rounded,
                  title: 'Chưa có ví',
                  message: 'Danh sách ví của bạn sẽ hiển thị tại đây.',
                )
              : Column(
                  children: wallets
                      .map(
                        (wallet) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _WalletPickerItem(wallet: wallet),
                        ),
                      )
                      .toList(),
                ),
        ),
      ),
    );
  }
}

class _WalletPickerItem extends StatelessWidget {
  final WalletModel wallet;

  const _WalletPickerItem({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.pop(context, wallet);
      },
      child: WalletCard(wallet: wallet),
    );
  }
}
