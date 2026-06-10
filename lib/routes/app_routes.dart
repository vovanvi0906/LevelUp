import 'package:flutter/material.dart';
import 'package:saveup/screens/auth/forgot_password_screen.dart';
import 'package:saveup/screens/auth/login_screen.dart';
import 'package:saveup/screens/auth/register_screen.dart';
import 'package:saveup/screens/main/main_navigation_screen.dart';
import 'package:saveup/screens/onboarding/welcome_screen.dart';
import 'package:saveup/screens/splash/splash_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String mainNavigation = '/main';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      welcome: (context) => const WelcomeScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      mainNavigation: (context) => const MainNavigationScreen(),
    };
  }
}
