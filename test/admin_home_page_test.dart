import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_table/admin_home_page.dart';

void main() {
  testWidgets('Admin home page displays correctly',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: AdminHomePage(userName: 'admin')));

    expect(find.text('Welcome, admin!'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(4));
    expect(find.byType(DropdownButton<String>), findsOneWidget);
  });

  testWidgets('Set run time duration', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: AdminHomePage(userName: 'admin')));

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2 minutes').last);
    await tester.pump();

    expect(find.text('2 minutes'), findsOneWidget);

    await tester.tap(find.text('Set Run Time'));
    await tester.pump();

    expect(find.text('Run time set successfully!'), findsOneWidget);
  });
}
