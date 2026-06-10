import 'package:flutter/material.dart';
import 'package:saveup/core/constants/app_constants.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/routes/app_routes.dart';
import 'package:saveup/widgets/app_button.dart';
import 'package:saveup/widgets/background_blob.dart';
import 'package:saveup/widgets/levelup_logo.dart';
import 'package:saveup/widgets/page_dot.dart';
import 'package:saveup/widgets/welcome_finance_preview.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              top: -80,
              left: -70,
              child: BackgroundBlob(size: 210, color: AppColors.softGreen),
            ),
            const Positioned(
              top: -60,
              right: -70,
              child: BackgroundBlob(size: 210, color: AppColors.softBlue),
            ),
            const Positioned(
              bottom: -90,
              left: -70,
              child: BackgroundBlob(size: 210, color: AppColors.softBlue),
            ),
            const Positioned(
              bottom: -60,
              right: -50,
              child: BackgroundBlob(size: 160, color: AppColors.softGreen),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          const LevelUpLogo(),
                          const SizedBox(height: 30),
                          const WelcomeFinancePreview(),
                          const Text(
                            'Xin chào!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Chào mừng đến\nvới LevelUp',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.darkBlue,
                              fontSize: 34,
                              height: 1.15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            AppConstants.appDescription,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textGray,
                              fontSize: 15,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 26),
                          AppButton(
                            label: 'Bắt đầu',
                            icon: Icons.arrow_forward_rounded,
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.login);
                            },
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.register);
                            },
                            child: const Text(
                              'Tôi chưa có tài khoản? Đăng ký ngay',
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PageDot(active: true),
                              PageDot(active: false),
                              PageDot(active: false),
                            ],
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
