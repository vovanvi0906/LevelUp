import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/screens/home/widgets/balance_overview_card.dart';
import 'package:saveup/screens/home/widgets/home_header.dart';
import 'package:saveup/screens/home/widgets/recent_transactions_section.dart';
import 'package:saveup/screens/home/widgets/saving_goal_preview_card.dart';
import 'package:saveup/screens/home/widgets/summary_cards_row.dart';
import 'package:saveup/screens/home/widgets/wallet_preview_section.dart';
import 'package:saveup/state/app_state.dart';
import 'package:saveup/widgets/app_button.dart';

class HomeScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback onAddTransactionTap;

  const HomeScreen({
    super.key,
    required this.appState,
    required this.onAddTransactionTap,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.scaffoldBackground,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeHeader(),
              const SizedBox(height: 20),
              BalanceOverviewCard(totalBalance: appState.totalBalance),
              const SizedBox(height: 16),
              SummaryCardsRow(
                monthlyIncome: appState.monthlyIncome,
                monthlyExpense: appState.monthlyExpense,
                totalSavings: appState.totalSavings,
              ),
              const SizedBox(height: 18),
              AppButton(
                label: '+ Thêm giao dịch',
                icon: Icons.add_rounded,
                onPressed: onAddTransactionTap,
              ),
              const SizedBox(height: 22),
              RecentTransactionsSection(appState: appState),
              const SizedBox(height: 22),
              WalletPreviewSection(wallets: appState.wallets.take(4).toList()),
              const SizedBox(height: 22),
              SavingGoalPreviewCard(savingGoals: appState.savingGoals),
            ],
          ),
        ),
      ),
    );
  }
}
