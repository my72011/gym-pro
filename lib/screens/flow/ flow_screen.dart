import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../services/transaction_service.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/animated_gradient_background.dart';
import 'flow_painter.dart';

class FlowScreen extends StatefulWidget {
  const FlowScreen({super.key});
  @override
  State<FlowScreen> createState() => _FlowScreenState();
}

class _FlowScreenState extends State<FlowScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  int _selected = -1;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = TransactionService.instance;
    final flow = service.weeklyFlow();
    final total = flow.fold<double>(0, (s, v) => s + v);
    final avg = total / math.max(1, flow.length);
    final max = flow.fold<double>(0, (a, b) => a > b ? a : b);

    final now = DateTime.now();
    final labels = List<String>.generate(7, (i) => DateFormatter.day(now.subtract(Duration(days: 6 - i))).substring(0, 3));

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Weekly flow', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ),
      body: AnimatedGradientBackground(
        balance: service.balance,
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: AppConstants.spaceLG)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceLG),
                sliver: SliverToBoxAdapter(
                  child: GlassCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(AppConstants.spaceMD, AppConstants.spaceMD, AppConstants.spaceMD, AppConstants.spaceXS),
                          child: Row(
                            children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const Text('Total spent', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
                                const SizedBox(height: 4),
                                Text(CurrencyFormatter.format(total), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                              ]),
                              const Spacer(),
                              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                const Text('Daily avg', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
                                const SizedBox(height: 4),
                                Text(CurrencyFormatter.format(avg), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                              ]),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppConstants.spaceSM),
                        SizedBox(
                          height: 220,
                          child: AnimatedBuilder(
                            animation: _anim,
                            builder: (context, _) => GestureDetector(
                              onPanDown: (d) => _onTap(d.localPosition, flow.length),
                              onPanUpdate: (d) => _onTap(d.localPosition, flow.length),
                              onPanEnd: (_) => setState(() => _selected = -1),
                              child: CustomPaint(
                                size: Size.infinite,
                                painter: FlowPainter(values: flow, progress: _anim.value, labels: labels, selectedIndex: _selected),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppConstants.spaceSM),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppConstants.spaceLG)),
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.spaceLG),
                sliver: SliverToBoxAdapter(child: Text('Daily breakdown', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppConstants.spaceSM)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceLG),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    final dayIdx = flow.length - 1 - i;
                    final value = flow[dayIdx];
                    final date = now.subtract(Duration(days: 6 - dayIdx));
                    final pct = max == 0 ? 0.0 : value / max;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(DateFormatter.groupHeader(date), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                                const Spacer(),
                                Text(CurrencyFormatter.format(value), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                              ],
                            ),
                            const SizedBox(height: AppConstants.spaceXS),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: pct),
                                duration: const Duration(milliseconds: 900),
                                curve: Curves.easeOutCubic,
                                builder: (_, v, __) => LinearProgressIndicator(
                                  value: v,
                                  minHeight: 6,
                                  backgroundColor: AppColors.surfaceGlass,
                                  valueColor: const AlwaysStoppedAnimation(AppColors.primaryStart),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: flow.length),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppConstants.spaceXXL)),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(Offset local, int count) {
    final width = context.size?.width ?? 300;
    const chartLeft = 44.0;
    const chartRightPad = 16.0;
    final chartWidth = width - chartLeft - chartRightPad;
    final step = chartWidth / math.max(1, count - 1);
    final idx = ((local.dx - chartLeft) / step).round().clamp(0, count - 1);
    setState(() => _selected = idx);
  }
}