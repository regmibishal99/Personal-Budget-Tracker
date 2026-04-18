import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'models/transaction.dart';
import 'boxes.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transactions');

  _seedSampleData();

  runApp(const BudgetApp());
}

void _seedSampleData() {
  final box = Boxes.getTransactions();
  if (box.isNotEmpty) return; // Don't re-seed

  const uuid = Uuid();
  final now = DateTime.now();

  final samples = [
    Transaction(id: uuid.v4(), title: 'Monthly Salary',    amount: 85000, category: 'Salary',       isIncome: true,  date: now.subtract(const Duration(days: 20))),
    Transaction(id: uuid.v4(), title: 'Freelance Project', amount: 15000, category: 'Freelance',     isIncome: true,  date: now.subtract(const Duration(days: 10))),
    Transaction(id: uuid.v4(), title: 'House Rent',        amount: 18000, category: 'Housing',       isIncome: false, date: now.subtract(const Duration(days: 18))),
    Transaction(id: uuid.v4(), title: 'Groceries',         amount: 4500,  category: 'Food',          isIncome: false, date: now.subtract(const Duration(days: 15))),
    Transaction(id: uuid.v4(), title: 'Internet Bill',     amount: 1200,  category: 'Utilities',     isIncome: false, date: now.subtract(const Duration(days: 12))),
    Transaction(id: uuid.v4(), title: 'Netflix',           amount: 800,   category: 'Entertainment', isIncome: false, date: now.subtract(const Duration(days: 9))),
    Transaction(id: uuid.v4(), title: 'Taxi / Rides',      amount: 2200,  category: 'Transport',     isIncome: false, date: now.subtract(const Duration(days: 7))),
    Transaction(id: uuid.v4(), title: 'Restaurant Dinner', amount: 1800,  category: 'Food',          isIncome: false, date: now.subtract(const Duration(days: 5))),
    Transaction(id: uuid.v4(), title: 'Gym Membership',    amount: 2500,  category: 'Health',        isIncome: false, date: now.subtract(const Duration(days: 3))),
    Transaction(id: uuid.v4(), title: 'Book Purchase',     amount: 650,   category: 'Education',     isIncome: false, date: now.subtract(const Duration(days: 1))),
  ];

  for (final t in samples) {
    box.add(t);
  }
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}