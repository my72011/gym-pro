import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_constants.dart';

enum NumpadKey { one, two, three, four, five, six, seven, eight, nine, dot, zero, backspace }

class CustomNumpad extends StatefulWidget {
  const CustomNumpad({super.key, required this.onKey, this.height = 320});
  final void Function(NumpadKey key) onKey;
  final double height;

  @override
  State<CustomNumpad> createState() => _CustomNumpadState();
}

class _CustomNumpadState extends State<CustomNumpad> {
  Timer? _longPressTimer;

  void _startLongPress(NumpadKey key) {
    if (key != NumpadKey.backspace) return;
    _longPressTimer?.cancel();
    _longPressTimer = Timer.periodic(const Duration(milliseconds: 90), (_) => widget.onKey(NumpadKey.backspace));
  }

  void _endLongPress() {
    _longPressTimer?.cancel();
    _longPressTimer = null;
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const layout = [
      [NumpadKey.one, NumpadKey.two, NumpadKey.three],
      [NumpadKey.four, NumpadKey.five, NumpadKey.six],
      [NumpadKey.seven, NumpadKey.eight, NumpadKey.nine],
      [NumpadKey.dot, NumpadKey.zero, NumpadKey.backspace],
    ];

    return SizedBox(
      height: widget.height,
      child: Column(
        children: layout.map((row) => Expanded(
          child: Row(
            children: row.map((k) => Expanded(
              child: _KeyButton(
                key_: k,
                onTap: () { HapticFeedback.lightImpact(); widget.onKey(k); },
                onLongPressStart: () => _startLongPress(k),
                onLongPressEnd: _endLongPress,
              ),
            )).toList(),
          ),
        )).toList(),
      ),
    );
  }
}

class _KeyButton extends StatefulWidget {
  const _KeyButton({required this.key_, required this.onTap, required this.onLongPressStart, required this.onLongPressEnd});
  final NumpadKey key_;
  final VoidCallback onTap;
  final VoidCallback onLongPressStart;
  final VoidCallback onLongPressEnd;

  @override
  State<_KeyButton> createState() => _KeyButtonState();
}

class _KeyButtonState extends State<_KeyButton> with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(vsync: this, duration: const Duration(milliseconds: 110), lowerBound: 0.0, upperBound: 1.0);
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _down() => _pressController.forward();
  void _up() => _pressController.reverse();

  Widget _icon() {
    switch (widget.key_) {
      case NumpadKey.backspace:
        return const Icon(Icons.backspace_outlined, size: 22, color: AppColors.textSecondary);
      case NumpadKey.dot:
        return const Text('.', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: AppColors.textPrimary));
      default:
        return Text(_label(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: -0.02));
    }
  }

  String _label() {
    switch (widget.key_) {
      case NumpadKey.one: return '1';
      case NumpadKey.two: return '2';
      case NumpadKey.three: return '3';
      case NumpadKey.four: return '4';
      case NumpadKey.five: return '5';
      case NumpadKey.six: return '6';
      case NumpadKey.seven: return '7';
      case NumpadKey.eight: return '8';
      case NumpadKey.nine: return '9';
      case NumpadKey.zero: return '0';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _down(),
      onTapUp: (_) { _up(); widget.onTap(); },
      onTapCancel: _up,
      onLongPressStart: (_) { _down(); widget.onLongPressStart(); },
      onLongPressEnd: (_) { _up(); widget.onLongPressEnd(); },
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: AnimatedBuilder(
          animation: _scale,
          builder: (context, child) => Transform.scale(scale: _scale.value, child: child),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
              color: AppColors.surfaceGlassStrong,
              border: Border.all(color: AppColors.border),
              boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4))],
            ),
            alignment: Alignment.center,
            child: _icon(),
          ),
        ),
      ),
    );
  }
}