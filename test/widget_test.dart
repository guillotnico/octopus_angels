import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:octopus_angels/main.dart';

void main() {
  testWidgets('MyApp mounts a MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
