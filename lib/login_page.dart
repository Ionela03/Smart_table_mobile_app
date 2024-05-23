import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  void _login() async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.0.104:8080/auth/login'), //here I have to update with raspberrypi.local instead of IP adress
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Navighează către pagina de Home a adminului dacă login-ul este reușit
        Navigator.pushReplacementNamed(context, '/adminHome',
            arguments: _usernameController.text);
      } else {
        // Afișează mesajul de eroare primit de la server
        setState(() {
          _errorMessage =
              json.decode(response.body)['message'] ?? "Unknown error";
        });
      }
    } catch (e) {
      print(
          'Eroare întâmpinată: $e'); // Afișează eroarea în consolă pentru depanare
      setState(() {
        _errorMessage = "Network issue or server error! Details: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: SingleChildScrollView(
        // Încapsulează în SingleChildScrollView pentru a permite derularea
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              SizedBox(height: 20),
              Text(_errorMessage, style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
