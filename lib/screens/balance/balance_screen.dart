import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_formatter.dart';
import '../../services/transaction_service.dart';
import '../../widgets/animated_gradient_background.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/transaction_tile.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/confirm_dialog.dart';
import '../quick_add/quick_add_screen.dart';
import '../flow/flow_screen.dart';
import '../history/history_screen.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  final TransactionService _service = TransactionService.instance;

  @override
  void initState() {
    super.initState();
    _service.addListener(_onChanged);
  }

  @override
  void dispose() {
    _service.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  void _openQuickAdd() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 420),
        reverseTransitionDuration: const Duration(milliseconds: 360),
        pageBuilder: (_, a1, a2) => const QuickAddScreen(),
        transitionsBuilder: (_, a1, a2, child) {
          final curved = CurvedAnimation(parent: a1, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  Future<void> _resetAll() async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Reset everything?',
      message: 'This will clear your balance and delete all transactions. This cannot be undone.',
      confirmLabel: 'Reset',
    );
    if (!ok) return;
    await _service.resetAll();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All data cleared')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final balance = _service.balance;
    final today = _service.todaySpending();
    final weekly = _service.weeklySpending();
    final recent = _service.transactions.take(5).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(AppConstants.spaceMD),
          child: GestureDetector(
            onTap: _resetAll,
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.surfaceGlassStrong, border: Border.all(color: AppColors.border)),
              alignment: Alignment.center,
              child: const Icon(Icons.settings_outlined, size: 20, color: AppColors.textPrimary),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.spaceMD),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryScreen())),
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.surfaceGlassStrong, border: Border.all(color: AppColors.border)),
                alignment: Alignment.center,
                child: const Icon(Icons.history_rounded, size: 20, color: AppColors.textPrimary),
              ),
            ),
          ),
        ],
      ),
      body: AnimatedGradientBackground(
        balance: balance,
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceLG),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Current balance', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                      const SizedBox(height: AppConstants.spaceXS),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: balance, end: balance),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        builder: (_, v, __) => Text(CurrencyFormatter.format(v), style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.03)),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppConstants.spaceXL)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceLG),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(child: _StatCard(label: 'Today', value: CurrencyFormatter.format(today), icon: Icons.today_rounded)),
                      const SizedBox(width: AppConstants.spaceMD),
                      Expanded(child: _StatCard(label: 'This week', value: CurrencyFormatter.format(weekly), icon: Icons.date_range_rounded)),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppConstants.spaceXL)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceLG),
                sliver: SliverToBoxAdapter(
                  child: GlassCard(
                    padding: const EdgeInsets.all(AppConstants.spaceMD),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FlowScreen())),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), gradient: LinearGradient(colors: AppColors.primaryGradient)),
                          alignment: Alignment.center,
                          child: const Icon(Icons.show_chart_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: AppConstants.spaceMD),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Weekly flow', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                              SizedBox(height: 2),
                              Text('See your 7-day spending', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppConstants.spaceLG)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceLG),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      const Text('Recent', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const Spacer(),
                      if (recent.isNotEmpty)
                        TextButton(
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryScreen())),
                          child: const Text('See all'),
                        ),
                    ],
                  ),
                ),
              ),
              if (recent.isEmpty)
                const SliverToBoxAdapter(
                  child: EmptyState(icon: Icons.receipt_long_rounded, title: 'No transactions yet', subtitle: 'Tap + to add your first expense.'),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceLG),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final tx = recent[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GlassCard(padding: EdgeInsets.zero, child: TransactionTile(transaction: tx)),
                        );
                      },
                      childCount: recent.length,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _QuickAddFab(onTap: _openQuickAdd),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppConstants.spaceMD),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.surfaceGlassStrong),
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: AppColors.textSecondary),
          ),
          const SizedBox(width: AppConstants.spaceSM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAddFab extends StatefulWidget {
  const _QuickAddFab({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_QuickAddFab> createState() => _QuickAddFabState();
}

class _QuickAddFabState extends State<_QuickAddFab> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final glow = 0.25 + (_pulse.value * 0.25);
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppColors.primaryStart.withOpacity(glow), blurRadius: 28, spreadRadius: 2)],
          ),
          child: child,
        );
      },
      child: SizedBox(
        width: 64, height: 64,
        child: FloatingActionButton(
          onPressed: widget.onTap,
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          child: Container(
            decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: AppColors.primaryGradient, begin: Alignment.topLeft, end: Alignment.bottomRight)),
            alignment: Alignment.center,
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}