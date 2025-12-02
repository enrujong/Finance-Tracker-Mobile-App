import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/providers.dart';
import '../widgets/transaction_item.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  static Widget addTransactionSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _AddTransactionForm(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(transactionsInRangeProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Transactions')),
        body: txAsync.when(
          data: (txs) => ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: txs.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (_, i) => TransactionItem(tx: txs[i]),
          ),
          loading: () => Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}

class _AddTransactionForm extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AddTransactionForm> createState() =>
      _AddTransactionFormState();
}

class _AddTransactionFormState extends ConsumerState<_AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _category = 'General';
  String _type = 'expense';
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(transactionRepositoryProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Add Transaction', style: Theme.of(context).textTheme.headline6),
          const SizedBox(height: 12),
          Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _type,
                  items: ['income', 'expense']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _type = v!),
                  decoration: InputDecoration(labelText: 'Type'),
                ),
                TextFormField(
                  controller: _amountCtrl,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter amount' : null,
                ),
                TextFormField(
                  controller: _noteCtrl,
                  decoration: InputDecoration(labelText: 'Note'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  child: Text('Save'),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final amount = double.tryParse(_amountCtrl.text) ?? 0.0;
                    await repo.addTransaction(
                      amount: amount,
                      type: _type,
                      category: _category,
                      date: _date,
                      note: _noteCtrl.text,
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
