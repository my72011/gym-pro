import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _short = DateFormat('MMM d');
  static final DateFormat _medium = DateFormat('MMM d, y');
  static final DateFormat _time = DateFormat('h:mm a');
  static final DateFormat _day = DateFormat('EEEE');
  static final DateFormat _iso = DateFormat('yyyy-MM-dd');

  static String short(DateTime date) => _short.format(date);
  static String medium(DateTime date) => _medium.format(date);
  static String time(DateTime date) => _time.format(date);
  static String day(DateTime date) => _day.format(date);
  static String iso(DateTime date) => _iso.format(date);

  static String relative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return _day.format(date);
    if (diff < 30) return '$diff days ago';
    return _medium.format(date);
  }

  static String groupHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return _day.format(date);
    return _medium.format(date);
  }
}