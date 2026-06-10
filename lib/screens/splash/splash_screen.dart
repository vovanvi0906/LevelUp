import 'dart:async';

import 'package:flutter/material.dart';
import 'package:saveup/core/constants/app_constants.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/routes/app_routes.dart';
import 'package:saveup/widgets/background_blob.dart';
import 'package:saveup/widgets/levelup_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _openWelcomeScreen();
  }

  Future<void> _openWelcomeScreen() async {
    await Future<void>.delayed(const Duration(seconds: 1));

    if (!mounted) {
      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              top: -70,
              left: -70,
              child: BackgroundBlob(size: 220, color: AppColors.softGreen),
            ),
            const Positioned(
              bottom: -90,
              right: -70,
              child: BackgroundBlob(size: 240, color: AppColors.softBlue),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LevelUpLogo(logoSize: 76, fontSize: 42, spacing: 14),
                    const SizedBox(height: 18),
                    const Text(
                      AppConstants.appSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textGray,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 34,
                      height: 34,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
