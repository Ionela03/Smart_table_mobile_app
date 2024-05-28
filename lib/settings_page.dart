import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SettingsPage extends StatefulWidget {
  final String currentUsername;

  SettingsPage({required this.currentUsername});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newUsernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  String _updateMessage = '';

  void _updateCredentials() async {
    String username = widget.currentUsername;
    String password = _currentPasswordController.text;
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.102:8080/auth/update_credentials'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': basicAuth,
        },
        body: jsonEncode(<String, String>{
          'current_password': _currentPasswordController.text,
          'new_username': _newUsernameController.text,
          'new_password': _newPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _updateMessage = "Credentials updated successfully!";
        });
      } else {
        setState(() {
          _updateMessage =
              "Failed to update credentials: ${json.decode(response.body)['message']}";
        });
      }
    } catch (e) {
      setState(() {
        _updateMessage = "Error updating credentials: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _currentPasswordController,
              decoration: InputDecoration(
                labelText: 'Current Password',
                helperText: 'Enter your current password',
              ),
              obscureText: true,
            ),
            TextField(
              controller: _newUsernameController,
              decoration: InputDecoration(
                labelText: 'New Username',
              ),
            ),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                helperText: 'Enter a strong password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateCredentials,
              child: Text('Update Settings'),
            ),
            SizedBox(height: 10),
            Text(_updateMessage, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
