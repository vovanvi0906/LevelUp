import 'package:flutter/material.dart';
import 'package:saveup/core/constants/app_constants.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/state/app_state.dart';
import 'package:saveup/widgets/app_card.dart';

enum _ThemeChoice { light, dark, system }

class SettingsScreen extends StatefulWidget {
  final AppState appState;

  const SettingsScreen({super.key, required this.appState});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _themeChoice = _ThemeChoice.light;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Cài đặt'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Đơn vị tiền tệ',
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SettingsInfoRow(
                      icon: Icons.payments_rounded,
                      label: 'Tiền tệ',
                      value: 'VND (${AppConstants.currencySymbol})',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Giao diện',
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<_ThemeChoice>(
                      segments: const [
                        ButtonSegment(
                          value: _ThemeChoice.light,
                          label: Text('Sáng'),
                        ),
                        ButtonSegment(
                          value: _ThemeChoice.dark,
                          label: Text('Tối'),
                        ),
                        ButtonSegment(
                          value: _ThemeChoice.system,
                          label: Text('Hệ thống'),
                        ),
                      ],
                      selected: {_themeChoice},
                      onSelectionChanged: (selection) {
                        setState(() {
                          _themeChoice = selection.first;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Tính năng đổi giao diện sẽ được hoàn thiện sau',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Dữ liệu',
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _resetDefaultData,
                      icon: const Icon(Icons.restore_rounded),
                      label: const Text('Đặt lại dữ liệu mẫu'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: _clearLocalData,
                      icon: const Icon(Icons.delete_sweep_outlined),
                      label: const Text('Xóa dữ liệu local'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.expenseRed,
                        side: const BorderSide(color: AppColors.expenseRed),
                        minimumSize: const Size.fromHeight(52),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin app',
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 12),
                    _SettingsInfoRow(
                      icon: Icons.apps_rounded,
                      label: 'Tên app',
                      value: 'LevelUp',
                    ),
                    _SettingsInfoRow(
                      icon: Icons.info_outline_rounded,
                      label: 'Phiên bản',
                      value: '1.0.0',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _resetDefaultData() async {
    final shouldReset = await _confirm(
      title: 'Đặt lại dữ liệu mẫu?',
      content: 'Dữ liệu hiện tại sẽ được thay bằng dữ liệu mẫu của LevelUp.',
    );

    if (shouldReset != true || !mounted) {
      return;
    }

    await widget.appState.resetToDefaultData();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã đặt lại dữ liệu mẫu')));
  }

  Future<void> _clearLocalData() async {
    final shouldClear = await _confirm(
      title: 'Xóa dữ liệu local?',
      content:
          'Dữ liệu đã lưu trên thiết bị sẽ được xóa và app quay về dữ liệu mẫu.',
    );

    if (shouldClear != true || !mounted) {
      return;
    }

    await widget.appState.clearLocalData();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã xóa dữ liệu local')));
  }

  Future<bool?> _confirm({required String title, required String content}) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
}

class _SettingsInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SettingsInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textGray,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.darkBlue,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
