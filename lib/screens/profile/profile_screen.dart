import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/screens/category/category_list_screen.dart';
import 'package:saveup/screens/profile/backup_screen.dart';
import 'package:saveup/screens/profile/settings_screen.dart';
import 'package:saveup/screens/saving_goal/saving_goals_screen.dart';
import 'package:saveup/screens/statistics/statistics_screen.dart';
import 'package:saveup/screens/wallet/wallet_list_screen.dart';
import 'package:saveup/state/app_state.dart';
import 'package:saveup/widgets/app_card.dart';

class ProfileScreen extends StatelessWidget {
  final AppState appState;

  const ProfileScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Cá nhân'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: appState,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _ProfileHeader(),
                  const SizedBox(height: 16),
                  AppCard(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        _ProfileMenuItem(
                          icon: Icons.insights_rounded,
                          color: AppColors.primaryBlue,
                          title: 'Thống kê',
                          subtitle:
                              'Xem tổng thu, tổng chi và danh mục chi nhiều',
                          onTap: () => _openScreen(
                            context,
                            StatisticsScreen(appState: appState),
                          ),
                        ),
                        _ProfileMenuItem(
                          icon: Icons.flag_rounded,
                          color: AppColors.primaryGreen,
                          title: 'Mục tiêu tiết kiệm',
                          subtitle:
                              '${appState.savingGoals.length} mục tiêu đang theo dõi',
                          onTap: () => _openScreen(
                            context,
                            SavingGoalsScreen(appState: appState),
                          ),
                        ),
                        _ProfileMenuItem(
                          icon: Icons.category_rounded,
                          color: const Color(0xFF8B5CF6),
                          title: 'Quản lý danh mục',
                          subtitle:
                              '${appState.categories.length} danh mục đang dùng',
                          onTap: () => _openScreen(
                            context,
                            CategoryListScreen(appState: appState),
                          ),
                        ),
                        _ProfileMenuItem(
                          icon: Icons.account_balance_wallet_rounded,
                          color: const Color(0xFFF59E0B),
                          title: 'Quản lý ví',
                          subtitle:
                              '${appState.wallets.length} ví đang theo dõi',
                          onTap: () => _openScreen(
                            context,
                            WalletListScreen(appState: appState),
                          ),
                        ),
                        _ProfileMenuItem(
                          icon: Icons.settings_rounded,
                          color: AppColors.textMuted,
                          title: 'Cài đặt',
                          subtitle: 'Tiền tệ, giao diện và dữ liệu local',
                          onTap: () => _openScreen(
                            context,
                            SettingsScreen(appState: appState),
                          ),
                        ),
                        _ProfileMenuItem(
                          icon: Icons.backup_rounded,
                          color: AppColors.primaryBlue,
                          title: 'Sao lưu / Xuất dữ liệu',
                          subtitle: 'Xem dữ liệu JSON đang lưu trên thiết bị',
                          onTap: () => _openScreen(
                            context,
                            BackupScreen(appState: appState),
                          ),
                        ),
                        _ProfileMenuItem(
                          icon: Icons.logout_rounded,
                          color: AppColors.expenseRed,
                          title: 'Đăng xuất',
                          subtitle:
                              'Tính năng tài khoản sẽ được hoàn thiện sau',
                          onTap: () => _showPlaceholder(
                            context,
                            'Tính năng đăng xuất sẽ được hoàn thiện sau',
                          ),
                        ),
                      ],
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

  Future<void> _openScreen(BuildContext context, Widget screen) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _showPlaceholder(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.primaryBlue,
              size: 36,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Người dùng LevelUp',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.darkBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'levelup@example.com',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textGray,
                      fontSize: 12,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textGray),
          ],
        ),
      ),
    );
  }
}
