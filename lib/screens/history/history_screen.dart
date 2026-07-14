import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/transaction.dart';
import '../../services/transaction_service.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/transaction_tile.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/confirm_dialog.dart';

enum _SortMode { newest, oldest, highest, lowest }

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  final TransactionService _service = TransactionService.instance;
  final TextEditingController _searchCtrl = TextEditingController();

  String _query = '';
  _SortMode _sort = _SortMode.newest;

  late final AnimationController _listAnim;

  @override
  void initState() {
    super.initState();
    _listAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _service.addListener(_onChanged);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _listAnim.dispose();
    _service.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  List<Transaction> get _filtered {
    var list = List<Transaction>.from(_service.transactions);

    if (_query.trim().isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((t) {
        return t.title.toLowerCase().contains(q) ||
            t.category.label.toLowerCase().contains(q) ||
            (t.note?.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    switch (_sort) {
      case _SortMode.newest:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case _SortMode.oldest:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case _SortMode.highest:
        list.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case _SortMode.lowest:
        list.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }
    return list;
  }

  Future<void> _delete(Transaction tx) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Delete transaction?',
      message:
          '“${tx.title}” (${CurrencyFormatter.format(tx.amount)}) will be permanently removed and the amount refunded to your balance.',
      confirmLabel: 'Delete',
    );
    if (!ok) return;
    await _service.deleteTransaction(tx.id);
  }

  Future<void> _clearAll() async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Clear all history?',
      message:
          'This will delete every transaction and reset your balance to zero. This cannot be undone.',
      confirmLabel: 'Clear all',
    );
    if (!ok) return;
    await _service.resetAll();
  }

  Map<String, List<Transaction>> _groupedByDay(List<Transaction> list) {
    final map = <String, List<Transaction>>{};
    for (final t in list) {
      final key = DateFormatter.groupHeader(t.createdAt);
      map.putIfAbsent(key, () => []).add(t);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final grouped = _groupedByDay(filtered);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('History', style: AppText.h3),
        actions: [
          if (_service.transactions.isNotEmpty)
            IconButton(
              tooltip: 'Clear all',
              icon: const Icon(Icons.delete_sweep_rounded),
              onPressed: _clearAll,
            ),
        ],
      ),
      body: Column(
        children: [
          // Search + sort
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.spaceLG,
              0,
              AppConstants.spaceLG,
              AppConstants.spaceSM,
            ),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spaceMD,
                vertical: 4,
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded,
                      color: AppColors.textSecondary, size: 20),
                  const SizedBox(width: AppConstants.spaceSM),
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      style: AppText.body,
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: 'Search transactions',
                        hintStyle: AppText.bodySmall,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  PopupMenuButton<_SortMode>(
                    tooltip: 'Sort',
                    icon: const Icon(Icons.sort_rounded,
                        color: AppColors.textSecondary),
                    onSelected: (m) => setState(() => _sort = m),
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                          value: _SortMode.newest, child: Text('Newest first')),
                      PopupMenuItem(
                          value: _SortMode.oldest, child: Text('Oldest first')),
                      PopupMenuItem(
                          value: _SortMode.highest,
                          child: Text('Highest amount')),
                      PopupMenuItem(
                          value: _SortMode.lowest,
                          child: Text('Lowest amount')),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Summary
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spaceLG),
            child: Row(
              children: [
                Text('${filtered.length} transactions',
                    style: AppText.bodySmall),
                const Spacer(),
                Text(
                  'Total ${CurrencyFormatter.format(filtered.fold<double>(0, (s, t) => s + t.amount))}',
                  style: AppText.bodySmall,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppConstants.spaceSM),

          // List
          Expanded(
            child: filtered.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No transactions',
                    subtitle: 'Try a different search or add a new expense.',
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppConstants.spaceLG,
                      0,
                      AppConstants.spaceLG,
                      AppConstants.spaceXXL,
                    ),
                    itemCount: grouped.keys.length,
                    itemBuilder: (context, i) {
                      final header = grouped.keys.elementAt(i);
                      final items = grouped[header]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppConstants.spaceSM,
                            ),
                            child: Text(header,
                                style: AppText.caption
                                    .copyWith(fontWeight: FontWeight.w600)),
                          ),
                          ...items.map((tx) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _SlidableTransactionTile(
                                  transaction: tx,
                                  onDelete: () => _delete(tx),
                                ),
                              )),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SlidableTransactionTile extends StatelessWidget {
  const _SlidableTransactionTile({
    required this.transaction,
    required this.onDelete,
  });

  final Transaction transaction;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceLG),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          color: AppColors.dangerSoft,
          border: Border.all(color: AppColors.danger.withOpacity(0.4)),
        ),
        child: const Icon(Icons.delete_rounded, color: AppColors.danger),
      ),
      confirmDismiss: (_) async {
        final ok = await ConfirmDialog.show(
          context,
          title: 'Delete transaction?',
          message:
              '“${transaction.title}” will be removed and the amount refunded.',
          confirmLabel: 'Delete',
        );
        return ok;
      },
      onDismissed: (_) => onDelete(),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: TransactionTile(transaction: transaction),
      ),
    );
  }
}