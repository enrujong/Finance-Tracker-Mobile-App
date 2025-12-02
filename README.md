# Finance App (Flutter) - Template

## Setup
1. flutter pub get
2. flutter pub run build_runner build --delete-conflicting-outputs
3. flutter run

## Notes
- DB is Drift (SQLite). After changing tables you must re-run build_runner.
- Use Riverpod providers in `lib/application/providers/providers.dart`.
- Charts use fl_chart and are fed from providers.
- Recurring transactions are generated at app startup by `RecurringHandler`.
- Budgets table supports upsert and basic threshold percent.

## Running Tests
flutter test

## Tips
- Ensure consistent timezone handling when saving DateTime.
- Expand categories list and icon mapping in UI widgets.
- Add unit tests for aggregation and forecasting functions for extra grade points.
