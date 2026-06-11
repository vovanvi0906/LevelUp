import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saveup/app/levelup_app.dart';
import 'package:saveup/screens/main/main_navigation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('LevelUpApp opens welcome, login, then main navigation', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const LevelUpApp());

    expect(find.text('LevelUp'), findsOneWidget);
    expect(find.text('Quản lý chi tiêu thông minh'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Bắt đầu'), findsOneWidget);

    final startButton = find.widgetWithText(ElevatedButton, 'Bắt đầu');
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    expect(find.text('Chào mừng bạn quay lại LevelUp'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'demo@levelup.vn');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    final loginButton = find.widgetWithText(ElevatedButton, 'Đăng nhập').last;
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Số dư hiện tại'), findsOneWidget);
    expect(find.text('Giao dịch gần đây'), findsOneWidget);
  });

  testWidgets('MainNavigationScreen renders all main tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainNavigationScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Trang chủ'), findsWidgets);
    expect(find.text('Số dư hiện tại'), findsOneWidget);
    expect(find.text('Giao dịch'), findsWidgets);
    expect(find.text('Thêm'), findsOneWidget);
    expect(find.text('Ví tiền'), findsWidgets);
    expect(find.text('Cá nhân'), findsWidgets);
  });
}
