import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/providers.dart';
import '../widgets/charts_widget.dart';

class AnalyticsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Analytics')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ChartsWidget(analyticsMode: true),
        ),
      ),
    );
  }
}
