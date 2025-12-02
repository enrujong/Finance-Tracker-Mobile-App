import 'package:finance_app/data/db/drift_database.dart';

class TransactionRepository {
  final AppDatabase db;
  TransactionRepository(this.db);

  Future<int> addTransaction({
    required double amount,
    required String type,
    required String category,
    required DateTime date,
    String? note,
    bool isRecurring = false,
    String? recurringType,
    int? recurringEvery,
  }) {
    final companion = TransactionsCompanion.insert(
      amount: amount,
      type: type,
      category: category,
      date: date,
      note: Value(note),
      isRecurring: Value(isRecurring),
      recurringType: Value(recurringType),
      recurringEvery: Value(recurringEvery),
    );
    return db.insertTransaction(companion);
  }

  Future<List<Transaction>> getAll() => db.getAllTransactions();
  Future<List<Transaction>> getBetween(DateTime start, DateTime end) => db.getTransactionsBetween(start, end);
  Future<Map<String,double>> getTotals(DateTime start, DateTime end) => db.getTotalsByType(start, end);
  Future<List<Map<String,dynamic>>> getCategorySummary(DateTime start, DateTime end) => db.getCategorySummary(start, end);
  Future<List<Map<String,dynamic>>> getDayGroups(DateTime start, DateTime end) => db.getSumsGroupedByDay(start, end);
  Future<int> deleteById(int id) => db.deleteTransactionById(id);
  Future<bool> update(Insertable<Transaction> tx) => db.updateTransaction(tx);

  Future<int> upsertBudget(BudgetsCompanion companion) => db.upsertBudget(companion);
  Future<List<Budget>> getBudgets() => db.getAllBudgets();
}
