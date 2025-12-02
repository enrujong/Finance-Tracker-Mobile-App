import 'package:drift/drift.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get type => text()(); // "income" or "expense"
  TextColumn get category => text().withLength(min:1, max:50)();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
  BoolColumn get isRecurring => boolean().withDefault(Constant(false))();
  TextColumn get recurringType => text().nullable()(); // daily,weekly,monthly
  IntColumn get recurringEvery => integer().nullable()();
}

class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text().withLength(min:1,max:50)();
  RealColumn get budget => real()();
  RealColumn get thresholdPercent => real().withDefault(Constant(80.0))();
}
