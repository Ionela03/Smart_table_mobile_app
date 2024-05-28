import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'admin_home_page.dart';
import 'settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MY_APP',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/adminHome': (context) => AdminHomePage(
            userName: ModalRoute.of(context)!.settings.arguments as String),
        '/settings': (context) => SettingsPage(
            currentUsername:
                ModalRoute.of(context)!.settings.arguments as String),
      },
    );
  }
}
