import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'add_admin_page.dart';
import 'view_admins_page.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminHomePage extends StatefulWidget {
  final String userName;

  AdminHomePage({Key? key, required this.userName}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String _selectedDuration = "Select duration";
  String _message = '';

  void _setRunTime() async {
    int runTimeMinutes;
    switch (_selectedDuration) {
      case '2 minutes':
        runTimeMinutes = 2;
        break;
      case '1 hour':
        runTimeMinutes = 60;
        break;
      case '2 hours':
        runTimeMinutes = 120;
        break;
      case 'Unlimited':
        runTimeMinutes = 0;
        break;
      default:
        runTimeMinutes = 0;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.102:8080/set_runtime'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, int>{
          'run_time': runTimeMinutes,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _message = "Run time set successfully!";
        });
      } else {
        setState(() {
          _message =
              "Failed to set run time: ${json.decode(response.body)['message']}";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Error setting run time: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Navigate back to login page
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Welcome, ${widget.userName}!",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Image.asset(
                'lib/assets/home_page.jpg',
                fit: BoxFit.contain,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddUserPage()),
                  );
                },
                child: Text("Add Admins"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ViewAdminsPage(currentUser: widget.userName),
                    ),
                  );
                },
                child: Text("View Admins"),
              ),
              DropdownButton<String>(
                value: _selectedDuration == "Select duration"
                    ? null
                    : _selectedDuration,
                hint: Text("Select duration"),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDuration = newValue!;
                  });
                },
                items: <String>['1 hour', '2 minutes', '2 hours', 'Unlimited']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _setRunTime,
                child: Text('Set Run Time'),
              ),
              SizedBox(height: 10),
              Text(_message, style: TextStyle(color: Colors.red)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SettingsPage(currentUsername: widget.userName),
                    ),
                  );
                },
                child: Text('Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
