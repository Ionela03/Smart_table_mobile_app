import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_table/login_page.dart';

void main() {
  testWidgets('Login page displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Login button triggers login action',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    await tester.enterText(find.byKey(Key('username')), 'testuser');
    await tester.enterText(find.byKey(Key('password')), 'password');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Here you can add more checks to verify the login action, e.g., if it navigates to another page.
    // For demonstration, we'll just print a statement.
    print('Login button tapped, login action should trigger.');
  });
}
