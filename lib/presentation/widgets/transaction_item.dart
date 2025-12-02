import 'package:flutter/material.dart';
import 'package:finance_app/data/db/tables.dart' show Transactions;
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final Transaction tx;
  const TransactionItem({Key? key, required this.tx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat.simpleCurrency(locale: 'id_ID');
    return ListTile(
      leading: CircleAvatar(
        child: Icon(
          tx.type == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
        ),
      ),
      title: Text(tx.category),
      subtitle: Text(DateFormat.yMMMd().format(tx.date)),
      trailing: Text(
        (tx.type == 'income' ? '+' : '-') + f.format(tx.amount),
        style: TextStyle(
          color: tx.type == 'income' ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
