import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/main_screen.dart';
import 'data/repositories/recurring_handler.dart';
import 'application/providers/providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: AppEntry()));
}

class AppEntry extends ConsumerStatefulWidget {
  @override
  ConsumerState<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends ConsumerState<AppEntry> {
  @override
  void initState() {
    super.initState();
    _postInit();
  }

  Future<void> _postInit() async {
    final db = ref.read(appDatabaseProvider);
    final rh = RecurringHandler(db);
    await rh.generateDueRecurrings();
    // optional: check budgets and spawn local notifications
  }

  @override
  Widget build(BuildContext context) {
    return const MainScreen();
  }
}
