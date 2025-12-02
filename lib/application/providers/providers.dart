import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finance_app/data/db/drift_database.dart';
import 'package:finance_app/data/repositories/transaction_repository.dart';
// Date range utilities (moved here to avoid missing file import)
enum RangeType { daily, weekly, monthly, yearly }

class DateRangeModel {
  final DateTime start;
  final DateTime end;
  DateRangeModel(this.start, this.end);
}

class DateRangeUtils {
  static DateRangeModel getRangeFor(RangeType rangeType) {
    final now = DateTime.now();
    DateTime start;
    DateTime end;
    switch (rangeType) {
      case RangeType.daily:
        start = DateTime(now.year, now.month, now.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
        break;
      case RangeType.weekly:
        final weekday = now.weekday; // 1 = Monday
        start = DateTime(now.year, now.month, now.day).subtract(Duration(days: weekday - 1));
        end = start.add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59, milliseconds: 999));
        break;
      case RangeType.monthly:
        start = DateTime(now.year, now.month, 1);
        final nextMonth = (now.month == 12)
            ? DateTime(now.year + 1, 1, 1)
            : DateTime(now.year, now.month + 1, 1);
        end = nextMonth.subtract(Duration(milliseconds: 1));
        break;
      case RangeType.yearly:
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year, 12, 31, 23, 59, 59, 999);
        break;
    }
    return DateRangeModel(start, end);
  }
}

// DB provider
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// repository
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return TransactionRepository(db);
});

// range state
final selectedRangeProvider = StateProvider<RangeType>((ref) => RangeType.monthly);

// date range provider
final dateRangeProvider = Provider<DateRangeModel>((ref) {
  final range = ref.watch(selectedRangeProvider);
  return DateRangeUtils.getRangeFor(range);
});

// transactions in range
final transactionsInRangeProvider = FutureProvider.autoDispose<List<Transaction>>((ref) async {
  final repo = ref.watch(transactionRepositoryProvider);
  final range = ref.watch(dateRangeProvider);
  return repo.getBetween(range.start, range.end);
});

// totals provider
final totalsProvider = FutureProvider.autoDispose<Map<String, double>>((ref) async {
  final repo = ref.watch(transactionRepositoryProvider);
  final range = ref.watch(dateRangeProvider);
  return repo.getTotals(range.start, range.end);
});

// category summary
final categorySummaryProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(transactionRepositoryProvider);
  final range = ref.watch(dateRangeProvider);
  return repo.getCategorySummary(range.start, range.end);
});

// grouped by day for charts
final groupedByDayProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(transactionRepositoryProvider);
  final range = ref.watch(dateRangeProvider);
  return repo.getDayGroups(range.start, range.end);
});
