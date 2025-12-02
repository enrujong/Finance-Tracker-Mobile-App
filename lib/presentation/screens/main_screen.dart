import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'transactions_screen.dart';
import 'budgets_screen.dart';
import 'analytics_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final _screens = [
    HomeScreen(),
    TransactionsScreen(),
    BudgetsScreen(),
    AnalyticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Transaksi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: 'Anggaran',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              label: 'Analitik',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => const _AddTransactionSheetWrapper(),
            );
          },
        ),
      ),
    );
  }
}

class _AddTransactionSheetWrapper extends StatelessWidget {
  const _AddTransactionSheetWrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: 480,
        child: TransactionsScreen.addTransactionSheet(context),
      ),
    );
  }
}
