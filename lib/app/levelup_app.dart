import 'package:flutter/material.dart';
import 'package:saveup/core/constants/app_constants.dart';
import 'package:saveup/core/theme/app_theme.dart';
import 'package:saveup/routes/app_routes.dart';

class LevelUpApp extends StatelessWidget {
  const LevelUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
