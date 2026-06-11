import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/state/app_state.dart';
import 'package:saveup/widgets/app_button.dart';
import 'package:saveup/widgets/app_card.dart';

class BackupScreen extends StatelessWidget {
  final AppState appState;

  const BackupScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Sao lưu dữ liệu'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dữ liệu hiện được lưu trên thiết bị.',
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Bạn có thể xuất dữ liệu JSON để xem hoặc lưu lại thủ công.',
                      style: TextStyle(
                        color: AppColors.textGray,
                        fontSize: 14,
                        height: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              AppButton(
                label: 'Xuất dữ liệu JSON',
                icon: Icons.file_download_outlined,
                onPressed: () => _showExportDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showExportDialog(BuildContext context) async {
    final jsonText = await appState.exportJsonString();

    if (!context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dữ liệu JSON'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(
              jsonText,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
