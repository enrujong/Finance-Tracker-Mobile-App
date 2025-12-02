import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

part 'drift_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'finance_app.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Transactions, Budgets])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Basic CRUD
  Future<int> insertTransaction(Insertable<Transaction> tx) =>
      into(transactions).insert(tx);

  Future<bool> updateTransaction(Insertable<Transaction> tx) =>
      update(transactions).replace(tx);

  Future<int> deleteTransactionById(int id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  Future<List<Transaction>> getAllTransactions() =>
      (select(transactions)
        ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
      .get();

  // Advanced queries
  Future<List<Transaction>> getTransactionsBetween(DateTime start, DateTime end) {
    return (select(transactions)
          ..where((t) => t.date.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .get();
  }

  Future<Map<String, double>> getTotalsByType(DateTime start, DateTime end) async {
    final q = customSelect(
      'SELECT type, SUM(amount) as total FROM transactions WHERE date BETWEEN ? AND ? GROUP BY type',
      variables: [Variable.withDateTime(start), Variable.withDateTime(end)],
    );
    final rows = await q.get();
    double income = 0;
    double expense = 0;
    for (final row in rows) {
      final type = row.data['type'] as String;
      final total = (row.data['total'] as num?)?.toDouble() ?? 0.0;
      if (type == 'income') income = total;
      if (type == 'expense') expense = total;
    }
    return {'income': income, 'expense': expense};
  }

  Future<List<Map<String, dynamic>>> getCategorySummary(DateTime start, DateTime end) async {
    final q = customSelect(
      'SELECT category, SUM(amount) AS total FROM transactions WHERE date BETWEEN ? AND ? GROUP BY category ORDER BY total DESC',
      variables: [Variable.withDateTime(start), Variable.withDateTime(end)],
    );
    final rows = await q.get();
    return rows.map((r) {
      return {
        'category': r.data['category'] as String,
        'total': (r.data['total'] as num?)?.toDouble() ?? 0.0,
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getSumsGroupedByDay(DateTime start, DateTime end) async {
    final q = customSelect(
      "SELECT DATE(date) AS day, SUM(CASE WHEN type='income' THEN amount ELSE 0 END) AS income, SUM(CASE WHEN type='expense' THEN amount ELSE 0 END) AS expense FROM transactions WHERE date BETWEEN ? AND ? GROUP BY DATE(date) ORDER BY DATE(date)",
      variables: [Variable.withDateTime(start), Variable.withDateTime(end)],
    );
    final rows = await q.get();
    return rows.map((r) {
      return {
        'day': r.data['day'] as String,
        'income': (r.data['income'] as num?)?.toDouble() ?? 0.0,
        'expense': (r.data['expense'] as num?)?.toDouble() ?? 0.0,
      };
    }).toList();
  }

  Future<List<Transaction>> getTransactionsForMonth(int year, int month) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1).subtract(const Duration(days: 1));
    return getTransactionsBetween(start, end);
  }

  // Budgets
  Future<int> upsertBudget(BudgetsCompanion companion) =>
      into(budgets).insertOnConflictUpdate(companion);

  Future<List<Budget>> getAllBudgets() => select(budgets).get();
}
