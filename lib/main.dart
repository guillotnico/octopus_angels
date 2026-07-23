import 'package:flutter/material.dart';

import 'package:octopus_angels/presentation/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Octopus Angels',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const Placeholder(),
    );
  }
}
