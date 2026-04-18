import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../boxes.dart';

class AddTransactionScreen extends StatefulWidget {
  final Transaction? existing;
  const AddTransactionScreen({super.key, this.existing});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl  = TextEditingController();
  final _amountCtrl = TextEditingController();

  bool _isIncome = false;
  String _category = 'Food';
  DateTime _date = DateTime.now();

  final _incomeCategories  = ['Salary', 'Freelance', 'Business', 'Investment', 'Other'];
  final _expenseCategories = ['Food', 'Housing', 'Transport', 'Utilities', 'Entertainment', 'Health', 'Education', 'Shopping', 'Other'];

  List<String> get _categories => _isIncome ? _incomeCategories : _expenseCategories;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final t = widget.existing!;
      _titleCtrl.text  = t.title;
      _amountCtrl.text = t.amount.toStringAsFixed(0);
      _isIncome  = t.isIncome;
      _category  = t.category;
      _date      = t.date;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final box = Boxes.getTransactions();
    final amount = double.parse(_amountCtrl.text.trim());
    final title  = _titleCtrl.text.trim();

    if (widget.existing != null) {
      widget.existing!
        ..title    = title
        ..amount   = amount
        ..category = _category
        ..isIncome = _isIncome
        ..date     = _date;
      widget.existing!.save();
    } else {
      box.add(Transaction(
        id:       const Uuid().v4(),
        title:    title,
        amount:   amount,
        category: _category,
        isIncome: _isIncome,
        date:     _date,
      ));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Add Transaction' : 'Edit Transaction'),
        backgroundColor: color.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Income / Expense toggle
              Container(
                decoration: BoxDecoration(
                  color: color.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _TypeButton(label: 'Expense', active: !_isIncome, color: Colors.redAccent,
                        onTap: () => setState(() { _isIncome = false; _category = _expenseCategories.first; })),
                    _TypeButton(label: 'Income',  active: _isIncome,  color: Colors.green,
                        onTap: () => setState(() { _isIncome = true;  _category = _incomeCategories.first; })),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Title
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit_note),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount (Rs.)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.attach_money),
                  prefixText: 'Rs. ',
                  prefixStyle: TextStyle(color: color.onSurface),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter an amount';
                  if (double.tryParse(v.trim()) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                value: _categories.contains(_category) ? _category : _categories.first,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),

              // Date
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(8),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    '${_date.day}/${_date.month}/${_date.year}',
                    style: TextStyle(fontSize: 15, color: color.onSurface),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    widget.existing == null ? 'Add Transaction' : 'Save Changes',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  const _TypeButton({required this.label, required this.active, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: active ? Border.all(color: color, width: 1.5) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: active ? color : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}