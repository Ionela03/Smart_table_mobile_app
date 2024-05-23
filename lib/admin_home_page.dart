import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'add_admin_page.dart';

class AdminHomePage extends StatefulWidget {
  final String userName;

  AdminHomePage({Key? key, required this.userName}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String _selectedDuration = "Select duration";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Home"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Welcome, ${widget.userName}!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddUserPage()),
              );
            },
            child: Text("Add Users"),
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
            items: <String>['1 hour', '30 minutes', '2 hours', 'Unlimited']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }
}
