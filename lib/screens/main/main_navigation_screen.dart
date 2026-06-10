import 'package:flutter/material.dart';
import 'package:saveup/widgets/coming_soon_placeholder.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  var _selectedIndex = 0;

  final _pages = const [
    ComingSoonPlaceholder(
      icon: Icons.home_rounded,
      title: 'Trang chủ',
      description: 'Tổng quan tài chính của bạn sẽ hiển thị tại đây.',
    ),
    ComingSoonPlaceholder(
      icon: Icons.receipt_long_rounded,
      title: 'Giao dịch',
      description: 'Danh sách thu chi sẽ hiển thị tại đây.',
    ),
    ComingSoonPlaceholder(
      icon: Icons.add_circle_rounded,
      title: 'Thêm giao dịch',
      description: 'Form thêm khoản thu/chi sẽ được xây dựng ở giai đoạn sau.',
    ),
    ComingSoonPlaceholder(
      icon: Icons.account_balance_wallet_rounded,
      title: 'Ví tiền',
      description: 'Danh sách ví của bạn sẽ hiển thị tại đây.',
    ),
    ComingSoonPlaceholder(
      icon: Icons.person_rounded,
      title: 'Cá nhân',
      description: 'Thông tin tài khoản và cài đặt sẽ hiển thị tại đây.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Giao dịch',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline_rounded),
            selectedIcon: Icon(Icons.add_circle_rounded),
            label: 'Thêm',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Ví tiền',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Cá nhân',
          ),
        ],
      ),
    );
  }
}
