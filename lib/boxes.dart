import 'package:hive_flutter/hive_flutter.dart';
import 'models/transaction.dart';

class Boxes {
  static Box<Transaction> getTransactions() =>
      Hive.box<Transaction>('transactions');
}