import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/core/utils/currency_formatter.dart';
import 'package:saveup/core/utils/model_display.dart';
import 'package:saveup/models/wallet_model.dart';
import 'package:saveup/screens/wallet/add_wallet_screen.dart';
import 'package:saveup/screens/wallet/wallet_detail_screen.dart';
import 'package:saveup/state/app_state.dart';
import 'package:saveup/widgets/app_card.dart';
import 'package:saveup/widgets/empty_state.dart';

class WalletListScreen extends StatelessWidget {
  final AppState appState;

  const WalletListScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Ví tiền'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'wallet_list_add_fab',
        onPressed: () => _openAddWallet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Thêm ví'),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: appState,
          builder: (context, _) {
            final wallets = appState.wallets;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TotalBalanceCard(
                    totalBalance: appState.totalBalance,
                    walletCount: wallets.length,
                  ),
                  const SizedBox(height: 18),
                  if (wallets.isEmpty)
                    const AppCard(
                      child: EmptyState(
                        icon: Icons.account_balance_wallet_rounded,
                        title: 'Chưa có ví',
                        message: 'Thêm ví đầu tiên để bắt đầu quản lý số dư.',
                      ),
                    )
                  else
                    ...wallets.map(
                      (wallet) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _WalletListItem(
                          wallet: wallet,
                          onTap: () => _openWalletDetail(context, wallet),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openAddWallet(BuildContext context) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AddWalletScreen(appState: appState),
      ),
    );
  }

  Future<void> _openWalletDetail(
    BuildContext context,
    WalletModel wallet,
  ) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            WalletDetailScreen(appState: appState, walletId: wallet.id),
      ),
    );
  }
}

class _TotalBalanceCard extends StatelessWidget {
  final double totalBalance;
  final int walletCount;

  const _TotalBalanceCard({
    required this.totalBalance,
    required this.walletCount,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tổng số dư',
            style: TextStyle(
              color: AppColors.textGray,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.formatVnd(totalBalance),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.darkBlue,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$walletCount ví đang theo dõi',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletListItem extends StatelessWidget {
  final WalletModel wallet;
  final VoidCallback onTap;

  const _WalletListItem({required this.wallet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final walletColor = Color(wallet.colorValue);

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: walletColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                ModelDisplay.walletIcon(wallet.iconName),
                color: walletColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wallet.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ModelDisplay.walletTypeLabel(wallet.type),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textGray,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                CurrencyFormatter.formatVnd(wallet.balance),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textGray),
          ],
        ),
      ),
    );
  }
}
