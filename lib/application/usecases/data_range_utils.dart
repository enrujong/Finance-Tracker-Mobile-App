import 'package:flutter/material.dart';

class DateRangeModel {
  final DateTime start;
  final DateTime end;
  DateRangeModel(this.start, this.end);
}

enum RangeType { daily, weekly, monthly, yearly }

class DateRangeUtils {
  static DateRangeModel getRangeFor(RangeType range) {
    final now = DateTime.now();
    switch (range) {
      case RangeType.daily:
        final start = DateTime(now.year, now.month, now.day);
        final end = start.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
        return DateRangeModel(start, end);
      case RangeType.weekly:
        final monday = now.subtract(Duration(days: now.weekday - 1));
        final start = DateTime(monday.year, monday.month, monday.day);
        final end = start.add(const Duration(days: 7)).subtract(const Duration(milliseconds: 1));
        return DateRangeModel(start, end);
      case RangeType.monthly:
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 1).subtract(const Duration(milliseconds: 1));
        return DateRangeModel(start, end);
      case RangeType.yearly:
        final start = DateTime(now.year, 1, 1);
        final end = DateTime(now.year + 1, 1, 1).subtract(const Duration(milliseconds: 1));
        return DateRangeModel(start, end);
    }
  }
}
