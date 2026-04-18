import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late String category;

  @HiveField(4)
  late bool isIncome;

  @HiveField(5)
  late DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.isIncome,
    required this.date,
  });
}