import 'package:flutter/material.dart';
import 'package:finance_app/data/db/tables.dart' show Budget;
import 'package:intl/intl.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;
  const BudgetCard({Key? key, required this.budget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final f = NumberFormat.simpleCurrency(locale: 'id_ID');
    return Card(
      child: ListTile(
        title: Text(budget.category),
        subtitle: Text('Threshold: ${budget.thresholdPercent}%'),
        trailing: Text(f.format(budget.budget)),
      ),
    );
  }
}
