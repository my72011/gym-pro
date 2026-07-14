import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/app_constants.dart';
import '../models/transaction.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  late final Box _box;

  Future<void> init() async {
    Hive.registerAdapter(TransactionAdapter());
    _box = await Hive.openBox(AppConstants.boxName);
  }

  // --- Balance ---
  double getBalance() =>
      (_box.get(AppConstants.keyBalance) as num?)?.toDouble() ??
      AppConstants.defaultBalance;

  Future<void> setBalance(double value) =>
      _box.put(AppConstants.keyBalance, value);

  // --- Transactions ---
  List<Transaction> getTransactions() {
    final raw = _box.get(AppConstants.keyTransactions, defaultValue: []);
    if (raw is List) {
      return raw
          .whereType<Transaction>()
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return [];
  }

  Future<void> saveTransactions(List<Transaction> txs) async {
    await _box.put(AppConstants.keyTransactions, txs);
  }

  // --- Reset ---
  Future<void> resetAll() async {
    await _box.clear();
  }
}