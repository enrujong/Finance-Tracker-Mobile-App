import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/providers.dart';
import '../widgets/budget_card.dart';

class BudgetsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(transactionRepositoryProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Budgets')),
        body: FutureBuilder(
          future: repo.getBudgets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return Center(child: CircularProgressIndicator());
            final budgets = snapshot.data as List;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: budgets.length,
              itemBuilder: (_, i) => BudgetCard(budget: budgets[i]),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreateBudget(context, ref),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _showCreateBudget(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final _catCtrl = TextEditingController();
    final _amtCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Create Budget'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _catCtrl,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (v) => v == null || v.isEmpty ? 'Enter' : null,
              ),
              TextFormField(
                controller: _amtCtrl,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Enter' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;
              final repo = ref.read(transactionRepositoryProvider);
              await repo.upsertBudget(
                BudgetsCompanion.insert(
                  category: _catCtrl.text,
                  budget: double.parse(_amtCtrl.text),
                ),
              );
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
