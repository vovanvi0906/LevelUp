import 'package:flutter/material.dart';
import 'package:saveup/screens/home/home_screen.dart';
import 'package:saveup/screens/profile/profile_screen.dart';
import 'package:saveup/screens/transaction/add_transaction_screen.dart';
import 'package:saveup/screens/transaction/transaction_list_screen.dart';
import 'package:saveup/screens/wallet/wallet_list_screen.dart';
import 'package:saveup/state/app_state.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final _appState = AppState();
  var _selectedIndex = 0;

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  void _openAddTransactionTab() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  void _openTransactionListTab() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  void _refreshTransactionUi() {
    setState(() {});
  }

  List<Widget> get _pages {
    return [
      HomeScreen(
        appState: _appState,
        onAddTransactionTap: _openAddTransactionTab,
      ),
      TransactionListScreen(
        appState: _appState,
        onAddTransactionTap: _openAddTransactionTab,
        onTransactionChanged: _refreshTransactionUi,
      ),
      AddTransactionScreen(
        appState: _appState,
        onTransactionSaved: _openTransactionListTab,
      ),
      WalletListScreen(appState: _appState),
      ProfileScreen(appState: _appState),
    ];
  }

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
