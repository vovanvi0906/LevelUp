import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saveup/screens/home/home_screen.dart';
import 'package:saveup/state/app_state.dart';

void main() {
  testWidgets('HomeScreen renders finance overview from AppState', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(appState: AppState(), onAddTransactionTap: () {}),
      ),
    );

    expect(find.text('Xin chào!'), findsOneWidget);
    expect(find.text('Số dư hiện tại'), findsOneWidget);
    expect(find.text('Tổng thu'), findsOneWidget);
    expect(find.text('Tổng chi'), findsOneWidget);
    expect(find.text('Giao dịch gần đây'), findsOneWidget);
    expect(find.text('Ví của bạn'), findsOneWidget);
    expect(find.text('Cơm trưa'), findsOneWidget);
    expect(find.text('Tiền mặt'), findsOneWidget);
  });
}
