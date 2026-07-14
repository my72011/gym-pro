import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Draws a smooth, animated weekly spending line chart.
class FlowPainter extends CustomPainter {
  FlowPainter({
    required this.values,
    required this.progress,
    required this.labels,
    this.selectedIndex = -1,
    this.pointColor = AppColors.primaryStart,
  });

  final List<double> values;
  final double progress; // 0..1, animates stroke
  final List<String> labels;
  final int selectedIndex;
  final Color pointColor;

  static const double _leftPad = 44;
  static const double _rightPad = 16;
  static const double _topPad = 24;
  static const double _bottomPad = 32;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final chartRect = Rect.fromLTRB(
      _leftPad,
      _topPad,
      size.width - _rightPad,
      size.height - _bottomPad,
    );

    final maxV = values.fold<double>(0, math.max);
    final effectiveMax = maxV == 0 ? 1.0 : maxV;

    // --- Grid lines ---
    _drawGrid(canvas, chartRect, effectiveMax);

    // --- Build points ---
    final stepX = chartRect.width / math.max(1, values.length - 1);
    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = chartRect.left + stepX * i;
      final y = chartRect.bottom -
          (values[i] / effectiveMax) * chartRect.height;
      points.add(Offset(x, y));
    }

    // --- Build smooth path (monotone cubic) ---
    final path = _smoothPath(points);

    // --- Animated stroke length ---
    final pathMetrics = path.computeMetrics();
    double totalLength = 0;
    for (final m in pathMetrics) {
      totalLength += m.length;
    }
    final drawnLength = totalLength * progress.clamp(0.0, 1.0);

    // --- Gradient for stroke ---
    final strokeGradient = LinearGradient(
      colors: AppColors.primaryGradient,
    );

    // --- Glow layer ---
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
      ..shader = strokeGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    // Draw glow along full path but clipped to drawnLength
    _drawPathUpTo(canvas, path, drawnLength, glowPaint..strokeWidth = 6);

    // --- Main stroke ---
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3
      ..shader = strokeGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    _drawPathUpTo(canvas, path, drawnLength, strokePaint);

    // --- Fill area under curve (subtle) ---
    if (progress > 0.95) {
      final fillPath = Path.from(path)
        ..lineTo(points.last.dx, chartRect.bottom)
        ..lineTo(points.first.dx, chartRect.bottom)
        ..close();
      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryStart.withOpacity(0.28),
            AppColors.primaryEnd.withOpacity(0.0),
          ],
        ).createShader(chartRect);
      canvas.drawPath(fillPath, fillPaint);
    }

    // --- Points ---
    if (progress > 0.9) {
      final pointAlpha = ((progress - 0.9) / 0.1).clamp(0.0, 1.0);
      for (int i = 0; i < points.length; i++) {
        final p = points[i];
        final isSelected = i == selectedIndex;
        final radius = isSelected ? 7.0 : 4.0;

        // Outer ring
        canvas.drawCircle(
          p,
          radius + 3,
          Paint()
            ..color = pointColor.withOpacity(0.25 * pointAlpha)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
        );
        // Core
        canvas.drawCircle(
          p,
          radius,
          Paint()..color = pointColor.withOpacity(pointAlpha),
        );
        // Inner dot
        canvas.drawCircle(
          p,
          radius * 0.4,
          Paint()..color = Colors.white.withOpacity(pointAlpha),
        );
      }
    }

    // --- X labels ---
    final labelStyle = TextStyle(
      color: AppColors.textTertiary,
      fontSize: 11,
      fontWeight: FontWeight.w500,
    );
    for (int i = 0; i < labels.length; i++) {
      final x = chartRect.left + stepX * i;
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, chartRect.bottom + 10));
    }

    // --- Y labels ---
    final yLabelStyle = TextStyle(
      color: AppColors.textTertiary,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );
    const gridLines = 4;
    for (int i = 0; i <= gridLines; i++) {
      final y = chartRect.bottom - (chartRect.height / gridLines) * i;
      final value = (effectiveMax / gridLines) * i;
      final label = _compact(value);
      final tp = TextPainter(
        text: TextSpan(text: label, style: yLabelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // --- Tooltip ---
    if (selectedIndex >= 0 && selectedIndex < points.length) {
      _drawTooltip(
        canvas,
        points[selectedIndex],
        values[selectedIndex],
        chartRect,
      );
    }
  }

  void _drawGrid(Canvas canvas, Rect rect, double maxV) {
    final paint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    const gridLines = 4;
    for (int i = 0; i <= gridLines; i++) {
      final y = rect.bottom - (rect.height / gridLines) * i;
      canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), paint);
    }
  }

  Path _smoothPath(List<Offset> pts) {
    if (pts.isEmpty) return Path();
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    if (pts.length == 1) return path;

    for (int i = 0; i < pts.length - 1; i++) {
      final p0 = pts[i];
      final p1 = pts[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      path.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }
    return path;
  }

  void _drawPathUpTo(Canvas canvas, Path path, double length, Paint paint) {
    for (final metric in path.computeMetrics()) {
      final end = math.min(length, metric.length);
      length -= end;
      canvas.drawPath(metric.extractPath(0, end), paint);
      if (length <= 0) break;
    }
  }

  void _drawTooltip(
      Canvas canvas, Offset p, double value, Rect chartRect) {
    final label = '\$${value.toStringAsFixed(0)}';
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
    final boxW = tp.width + padding.horizontal;
    final boxH = tp.height + padding.vertical;
    var boxX = p.dx - boxW / 2;
    final boxY = p.dy - boxH - 14;

    // Clamp horizontally
    if (boxX < chartRect.left) boxX = chartRect.left;
    if (boxX + boxW > chartRect.right) boxX = chartRect.right - boxW;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(boxX, boxY, boxW, boxH),
      const Radius.circular(8),
    );
    canvas.drawRRect(
      rrect,
      Paint()..color = AppColors.surfaceElevated,
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = AppColors.borderStrong
        ..strokeWidth = 1,
    );
    tp.paint(canvas, Offset(boxX + padding.left, boxY + padding.top));
  }

  String _compact(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toStringAsFixed(0);
  }

  @override
  bool shouldRepaint(covariant FlowPainter old) =>
      old.values != values ||
      old.progress != progress ||
      old.selectedIndex != selectedIndex ||
      old.labels != labels;
}