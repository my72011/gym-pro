import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../models/transaction_category.dart';
import 'storage_service.dart';

const _uuid = Uuid();

/// Single source of truth for transactions + balance.
class TransactionService extends ChangeNotifier {
  TransactionService._();
  static final TransactionService instance = TransactionService._();

  final StorageService _storage = StorageService.instance;

  double _balance = 0;
  List<Transaction> _transactions = [];

  double get balance => _balance;
  List<Transaction> get transactions => List.unmodifiable(_transactions);

  Future<void> init() async {
    _balance = _storage.getBalance();
    _transactions = _storage.getTransactions();
    notifyListeners();
  }

  Future<void> addExpense({
    required double amount,
    required TransactionCategory category,
    required String title,
    String? note,
  }) async {
    if (amount <= 0) return;

    final tx = Transaction(
      id: _uuid.v4(),
      amount: amount,
      category: category,
      title: title.isEmpty ? category.label : title,
      createdAt: DateTime.now(),
      note: note,
    );

    _balance -= amount;
    _transactions = [tx, ..._transactions];

    await _storage.setBalance(_balance);
    await _storage.saveTransactions(_transactions);
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    final idx = _transactions.indexWhere((t) => t.id == id);
    if (idx == -1) return;

    final tx = _transactions[idx];
    _balance += tx.amount; // refund
    _transactions = List.of(_transactions)..removeAt(idx);

    await _storage.setBalance(_balance);
    await _storage.saveTransactions(_transactions);
    notifyListeners();
  }

  Future<void> resetAll() async {
    _balance = 0;
    _transactions = [];
    await _storage.resetAll();
    notifyListeners();
  }

  /// Total spent today.
  double todaySpending() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _transactions
        .where((t) =>
            t.createdAt.year == today.year &&
            t.createdAt.month == today.month &&
            t.createdAt.day == today.day)
        .fold<double>(0, (sum, t) => sum + t.amount);
  }

  /// Total spent in the last 7 days (including today).
  double weeklySpending() {
    final now = DateTime.now();
    final cutoff = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 6));
    return _transactions
        .where((t) => t.createdAt.isAfter(cutoff.subtract(const Duration(seconds: 1))))
        .fold<double>(0, (sum, t) => sum + t.amount);
  }

  /// Daily totals for the last 7 days (oldest → newest).
  List<double> weeklyFlow() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final result = <double>[];
    for (int i = 6; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final total = _transactions
          .where((t) =>
              t.createdAt.year == day.year &&
              t.createdAt.month == day.month &&
              t.createdAt.day == day.day)
          .fold<double>(0, (s, t) => s + t.amount);
      result.add(total);
    }
    return result;
  }
}