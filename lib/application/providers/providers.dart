import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finance_app/data/db/drift_database.dart';
import 'package:finance_app/data/repositories/transaction_repository.dart';
import 'package:finance_app/application/usecases/date_range_utils.dart';

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
