import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_table/add_admin_page.dart';

void main() {
  testWidgets('Add User page displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AddUserPage()));

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Add user action', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AddUserPage()));

    await tester.enterText(find.byKey(Key('Username')), 'newuser');
    await tester.enterText(find.byKey(Key('Password')), 'newpassword');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Check for the message or behavior after adding the user
    expect(find.text('User added successfully!'), findsOneWidget);
  });
}
