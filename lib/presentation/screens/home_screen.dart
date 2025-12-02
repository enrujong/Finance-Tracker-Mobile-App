import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/providers.dart';
import '../widgets/charts_widget.dart';
import '../widgets/account_card.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalsAsync = ref.watch(totalsProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Dashboard')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              totalsAsync.when(
                data: (totals) {
                  final f = NumberFormat.simpleCurrency(locale: 'id_ID');
                  return AccountCard(
                    balance: (totals['income'] ?? 0) - (totals['expense'] ?? 0),
                    income: totals['income'] ?? 0,
                    expense: totals['expense'] ?? 0,
                    formatter: f,
                  );
                },
                loading: () => CircularProgressIndicator(),
                error: (e, s) => Text('Error: $e'),
              ),
              const SizedBox(height: 16),
              Expanded(child: ChartsWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
