import 'package:flutter/material.dart';

enum TransactionCategory {
  food('Food', Icons.restaurant_rounded, Color(0xFFFBBF5A)),
  transport('Transport', Icons.directions_car_rounded, Color(0xFF5B8DEF)),
  shopping('Shopping', Icons.shopping_bag_rounded, Color(0xFF9B6BEA)),
  bills('Bills', Icons.receipt_long_rounded, Color(0xFFF87171)),
  health('Health', Icons.favorite_rounded, Color(0xFF4ADE80)),
  entertainment('Entertainment', Icons.movie_rounded, Color(0xFFEC4899)),
  other('Other', Icons.more_horiz_rounded, Color(0xFF9AA3B2));

  const TransactionCategory(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;

  static TransactionCategory fromName(String name) {
    return TransactionCategory.values.firstWhere(
      (c) => c.name == name,
      orElse: () => TransactionCategory.other,
    );
  }
}