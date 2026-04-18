import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import '../boxes.dart';
import '../widgets/summary_card.dart';
import '../widgets/pie_chart_widget.dart';
import '../widgets/transaction_list.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0; // 0 = All, 1 = Income, 2 = Expense

  void _openAddScreen({Transaction? existing}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTransactionScreen(existing: existing),
      ),
    );
  }

  void _deleteTransaction(Transaction t) {
    t.delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Transaction deleted'),
        action: SnackBarAction(label: 'OK', onPressed: () {}),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Budget Tracker', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: 'Chart view',
            onPressed: () {},
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Boxes.getTransactions().listenable(),
        builder: (context, Box<Transaction> box, _) {
          final all = box.values.toList()
            ..sort((a, b) => b.date.compareTo(a.date));

          final income  = all.where((t) => t.isIncome).toList();
          final expense = all.where((t) => !t.isIncome).toList();

          final totalIncome  = income.fold(0.0,  (s, t) => s + t.amount);
          final totalExpense = expense.fold(0.0, (s, t) => s + t.amount);
          final balance      = totalIncome - totalExpense;

          final displayed = _selectedTab == 0
              ? all
              : _selectedTab == 1
                  ? income
                  : expense;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SummaryCard(
                        balance: balance,
                        income: totalIncome,
                        expense: totalExpense,
                      ),
                      const SizedBox(height: 20),
                      if (expense.isNotEmpty) ...[
                        Text(
                          'Spending breakdown',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 12),
                        PieChartWidget(transactions: expense),
                        const SizedBox(height: 20),
                      ],
                      Text(
                        'Transactions',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 10),
                      _TabSelector(
                        selected: _selectedTab,
                        onTap: (i) => setState(() => _selectedTab = i),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              TransactionList(
                transactions: displayed,
                onEdit:   (t) => _openAddScreen(existing: t),
                onDelete: _deleteTransaction,
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddScreen(),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _TabSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;

  const _TabSelector({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final labels = ['All', 'Income', 'Expenses'];
    final color = Theme.of(context).colorScheme.primary;

    return Row(
      children: List.generate(labels.length, (i) {
        final active = selected == i;
        return GestureDetector(
          onTap: () => onTap(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: active ? color : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: active ? color : Theme.of(context).colorScheme.outline.withOpacity(0.4),
              ),
            ),
            child: Text(
              labels[i],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: active ? Colors.white : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        );
      }),
    );
  }
}