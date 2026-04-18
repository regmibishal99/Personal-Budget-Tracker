import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(Transaction) onEdit;
  final void Function(Transaction) onDelete;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.onEdit,
    required this.onDelete,
  });

  static const _categoryIcons = <String, IconData>{
    'Food':          Icons.restaurant_outlined,
    'Housing':       Icons.home_outlined,
    'Transport':     Icons.directions_car_outlined,
    'Utilities':     Icons.bolt_outlined,
    'Entertainment': Icons.movie_outlined,
    'Health':        Icons.favorite_border,
    'Education':     Icons.school_outlined,
    'Shopping':      Icons.shopping_bag_outlined,
    'Salary':        Icons.work_outline,
    'Freelance':     Icons.laptop_outlined,
    'Business':      Icons.business_outlined,
    'Investment':    Icons.trending_up,
    'Other':         Icons.more_horiz,
  };

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.receipt_long_outlined, size: 56, color: Theme.of(context).colorScheme.outline),
              const SizedBox(height: 12),
              Text('No transactions', style: TextStyle(color: Theme.of(context).colorScheme.outline)),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          final t   = transactions[i];
          final fmt = NumberFormat('#,##0', 'en_US');
          final color = Theme.of(context).colorScheme;

          return Dismissible(
            key: Key(t.key.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete_outline, color: Colors.white),
            ),
            onDismissed: (_) => onDelete(t),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.outline.withOpacity(0.12)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                leading: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: (t.isIncome ? Colors.green : Colors.redAccent).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _categoryIcons[t.category] ?? Icons.attach_money,
                    color: t.isIncome ? Colors.green : Colors.redAccent,
                    size: 22,
                  ),
                ),
                title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                subtitle: Text(
                  '${t.category}  •  ${DateFormat('d MMM').format(t.date)}',
                  style: TextStyle(fontSize: 12, color: color.onSurfaceVariant),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${t.isIncome ? '+' : '-'} Rs. ${fmt.format(t.amount)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: t.isIncome ? Colors.green : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                onTap: () => onEdit(t),
              ),
            ),
          );
        },
        childCount: transactions.length,
      ),
    );
  }
}