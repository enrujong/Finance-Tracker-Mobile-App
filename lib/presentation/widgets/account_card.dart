import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;
  final NumberFormat formatter;

  const AccountCard({
    Key? key,
    required this.balance,
    required this.income,
    required this.expense,
    required this.formatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Balance', style: TextStyle(fontSize: 12)),
                  SizedBox(height: 6),
                  Text(
                    formatter.format(balance),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Income', style: TextStyle(fontSize: 12)),
                Text(
                  formatter.format(income),
                  style: TextStyle(color: Colors.green),
                ),
                SizedBox(height: 6),
                Text('Expense', style: TextStyle(fontSize: 12)),
                Text(
                  formatter.format(expense),
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
