import 'package:hive/hive.dart';
import 'transaction_category.dart';

class Transaction {
  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.title,
    required this.createdAt,
    this.note,
  });

  final String id;
  final double amount;
  final TransactionCategory category;
  final String title;
  final DateTime createdAt;
  final String? note;

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'category': category.name,
        'title': title,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'note': note,
      };

  factory Transaction.fromJson(Map<dynamic, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: TransactionCategory.fromName(json['category'] as String),
      title: json['title'] as String,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      note: json['note'] as String?,
    );
  }

  Transaction copyWith({
    String? id,
    double? amount,
    TransactionCategory? category,
    String? title,
    DateTime? createdAt,
    String? note,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
    );
  }
}

/// Hive TypeAdapter for Transaction.
class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 1;

  @override
  Transaction read(BinaryReader reader) {
    final fields = reader.readMap();
    return Transaction.fromJson(fields);
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer.writeMap(obj.toJson());
  }
}