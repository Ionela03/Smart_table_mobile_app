import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewAdminsPage extends StatefulWidget {
  @override
  _ViewAdminsPageState createState() => _ViewAdminsPageState();
}

class _ViewAdminsPageState extends State<ViewAdminsPage> {
  List<String> _admins = [];

  @override
  void initState() {
    super.initState();
    _fetchAdmins();
  }

  void _fetchAdmins() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.0.104:8080/get/admins')); //to be changed with raspberrypi.local:8080
      if (response.statusCode == 200) {
        setState(() {
          _admins =
              List<String>.from(json.decode(response.body) as List<dynamic>);
        });
      } else {
        throw Exception('Failed to load admins');
      }
    } catch (e) {
      print("Failed to fetch admins: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Admins"),
      ),
      body: ListView.builder(
        itemCount: _admins.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_admins[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Logic to delete admin
              },
            ),
          );
        },
      ),
    );
  }
}
