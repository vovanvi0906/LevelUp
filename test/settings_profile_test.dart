import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saveup/screens/profile/backup_screen.dart';
import 'package:saveup/screens/profile/profile_screen.dart';
import 'package:saveup/screens/profile/settings_screen.dart';
import 'package:saveup/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('ProfileScreen renders user and settings entry', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(home: ProfileScreen(appState: AppState())),
    );

    expect(find.text('Người dùng LevelUp'), findsOneWidget);
    expect(find.text('Cài đặt'), findsOneWidget);
    expect(find.text('Thống kê'), findsOneWidget);
    expect(find.text('Mục tiêu tiết kiệm'), findsOneWidget);
  });

  testWidgets('SettingsScreen renders settings title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: SettingsScreen(appState: AppState())),
    );

    expect(find.text('Cài đặt'), findsOneWidget);
    expect(find.text('VND (đ)'), findsOneWidget);
  });

  testWidgets('BackupScreen renders backup and export action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: BackupScreen(appState: AppState())),
    );

    expect(find.text('Sao lưu dữ liệu'), findsOneWidget);
    expect(find.text('Xuất dữ liệu JSON'), findsOneWidget);
  });
}
