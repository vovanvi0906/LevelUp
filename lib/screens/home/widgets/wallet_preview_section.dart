import 'package:flutter/material.dart';
import 'package:saveup/models/wallet_model.dart';
import 'package:saveup/widgets/app_card.dart';
import 'package:saveup/widgets/empty_state.dart';
import 'package:saveup/widgets/section_header.dart';
import 'package:saveup/widgets/wallet_card.dart';

class WalletPreviewSection extends StatelessWidget {
  final List<WalletModel> wallets;

  const WalletPreviewSection({super.key, required this.wallets});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          const SectionHeader(title: 'Ví của bạn'),
          if (wallets.isEmpty)
            const EmptyState(
              icon: Icons.account_balance_wallet_rounded,
              title: 'Chưa có ví',
              message: 'Danh sách ví của bạn sẽ hiển thị ở đây.',
            )
          else
            ...wallets.map(
              (wallet) => Padding(
                padding: const EdgeInsets.only(top: 10),
                child: WalletCard(wallet: wallet),
              ),
            ),
        ],
      ),
    );
  }
}
