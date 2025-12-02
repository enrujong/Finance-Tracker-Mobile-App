import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/data/db/drift_database.dart';
import 'package:drift/native.dart';

void main() {
  test('db insert and query basic', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final id = await db.insertTransaction(
      TransactionsCompanion.insert(
        amount: 100.0,
        type: 'expense',
        category: 'food',
        date: DateTime.now(),
        note: const Value('test'),
      ),
    );
    final all = await db.getAllTransactions();
    expect(all.length, 1);
    await db.close();
  });
}
