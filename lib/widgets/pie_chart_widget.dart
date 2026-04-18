import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';
import '../boxes.dart';

class PieChartWidget extends StatefulWidget {
  final List<Transaction> transactions;
  const PieChartWidget({super.key, required this.transactions});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int _touched = -1;

  static const _colors = [
    Color(0xFF6C63FF), Color(0xFFFF6584), Color(0xFF43C6AC),
    Color(0xFFFFA500), Color(0xFF4FC3F7), Color(0xFFAB47BC),
    Color(0xFF66BB6A), Color(0xFFEF5350), Color(0xFF26C6DA),
  ];

  Map<String, double> _groupByCategory() {
    final map = <String, double>{};
    for (final t in widget.transactions) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByCategory();
    final entries  = grouped.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final total    = entries.fold(0.0, (s, e) => s + e.value);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      _touched = (event is FlTapUpEvent || event is FlLongPressEnd)
                          ? -1
                          : response?.touchedSection?.touchedSectionIndex ?? -1;
                    });
                  },
                ),
                sections: List.generate(entries.length, (i) {
                  final isTouched = i == _touched;
                  final pct = (entries[i].value / total * 100);
                  return PieChartSectionData(
                    value:      entries[i].value,
                    color:      _colors[i % _colors.length],
                    radius:     isTouched ? 70 : 58,
                    title:      isTouched ? '${pct.toStringAsFixed(1)}%' : '',
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  );
                }),
                centerSpaceRadius: 44,
                sectionsSpace:     3,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: List.generate(entries.length, (i) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10, height: 10,
                    decoration: BoxDecoration(
                      color: _colors[i % _colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    entries[i].key,
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}