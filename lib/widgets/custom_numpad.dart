import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_constants.dart';

enum NumpadKey { one, two, three, four, five, six, seven, eight, nine, dot, zero, backspace }

class CustomNumpad extends StatelessWidget {
  const CustomNumpad({super.key, required this.onKey, this.height = 320});
  final void Function(NumpadKey key) onKey;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          _buildRow([NumpadKey.one, NumpadKey.two, NumpadKey.three]),
          _buildRow([NumpadKey.four, NumpadKey.five, NumpadKey.six]),
          _buildRow([NumpadKey.seven, NumpadKey.eight, NumpadKey.nine]),
          _buildRow([NumpadKey.dot, NumpadKey.zero, NumpadKey.backspace]),
        ],
      ),
    );
  }

  Widget _buildRow(List<NumpadKey> keys) {
    return Expanded(
      child: Row(
        children: keys.map((k) => _KeyButton(numpadKey: k, onTap: () => onKey(k))).toList(),
      ),
    );
  }
}

class _KeyButton extends StatefulWidget {
  const _KeyButton({required this.numpadKey, required this.onTap});
  final NumpadKey numpadKey;
  final VoidCallback onTap;

  @override
  State<_KeyButton> createState() => _KeyButtonState();
}

class _KeyButtonState extends State<_KeyButton> {
  Timer? _longPressTimer;

  void _startLongPress() {
    if (widget.numpadKey != NumpadKey.backspace) return;
    _longPressTimer?.cancel();
    _longPressTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      widget.onTap();
      HapticFeedback.lightImpact();
    });
  }

  void _stopLongPress() {
    _longPressTimer?.cancel();
  }

  @override
  void dispose() {
    _stopLongPress();
    super.dispose();
  }

  String _getLabel() {
    switch (widget.numpadKey) {
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
      case NumpadKey.dot: return '.';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: AppColors.surfaceGlassStrong,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            onTap: () {
              _stopLongPress();
              HapticFeedback.lightImpact();
              widget.onTap();
            },
            onLongPress: _startLongPress,
            onLongPressUp: _stopLongPress,
            child: Container(
              height: 64, 
              alignment: Alignment.center,
              child: widget.numpadKey == NumpadKey.backspace
                  ? const Icon(Icons.backspace_outlined, size: 24, color: AppColors.textSecondary)
                  : Text(
                      _getLabel(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
