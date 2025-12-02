import 'package:finance_app/data/db/drift_database.dart';

class RecurringHandler {
  final AppDatabase db;
  RecurringHandler(this.db);

  Future<void> generateDueRecurrings() async {
    final now = DateTime.now();
    final templates = await (select(db.transactions)..where((t) => t.isRecurring.equals(true))).get();

    for (final tmpl in templates) {
      final latest = await (select(db.transactions)
            ..where((t) =>
                t.category.equals(tmpl.category) &
                t.recurringType.equals(tmpl.recurringType) &
                t.isRecurring.equals(true))
            ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
            ..limit(1))
          .get();

      DateTime lastDate = tmpl.date;
      if (latest.isNotEmpty) lastDate = latest.first.date;

      DateTime nextDue;
      final every = tmpl.recurringEvery ?? 1;
      if (tmpl.recurringType == 'daily') {
        nextDue = DateTime(lastDate.year, lastDate.month, lastDate.day).add(Duration(days: every));
      } else if (tmpl.recurringType == 'weekly') {
        nextDue = lastDate.add(Duration(days: 7 * every));
      } else {
        nextDue = DateTime(lastDate.year, lastDate.month + every, lastDate.day);
      }

      while (!nextDue.isAfter(now)) {
        final companion = TransactionsCompanion.insert(
          amount: tmpl.amount,
          type: tmpl.type,
          category: tmpl.category,
          date: nextDue,
          note: Value(tmpl.note),
          isRecurring: Value(true),
          recurringType: Value(tmpl.recurringType),
          recurringEvery: Value(tmpl.recurringEvery),
        );
        await db.insertTransaction(companion);

        if (tmpl.recurringType == 'daily') {
          nextDue = nextDue.add(Duration(days: every));
        } else if (tmpl.recurringType == 'weekly') {
          nextDue = nextDue.add(Duration(days: 7 * every));
        } else {
          nextDue = DateTime(nextDue.year, nextDue.month + every, nextDue.day);
        }
      }
    }
  }
}
