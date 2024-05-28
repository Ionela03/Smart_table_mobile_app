import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewAdminsPage extends StatefulWidget {
  final String currentUser;

  ViewAdminsPage({Key? key, required this.currentUser}) : super(key: key);

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
      final response = await http.get(
        Uri.parse('http://192.168.0.102:8080/get/admins'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
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

  void _deleteAdmin(String adminUsername) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.0.102:8080/admin/delete/$adminUsername'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        print("Admin deleted successfully");
        _fetchAdmins(); // Re-fetch the list to update the UI
      } else {
        throw Exception('Failed to delete admin');
      }
    } catch (e) {
      print("Failed to delete admin: $e");
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
          bool isSuperAdmin =
              widget.currentUser == 'admin'; // Superadmin's username
          bool isNotSelf =
              _admins[index] != widget.currentUser; // To prevent self-deletion
          return ListTile(
            title: Text(_admins[index]),
            trailing: (isSuperAdmin && isNotSelf)
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteAdmin(_admins[index]),
                  )
                : null,
          );
        },
      ),
    );
  }
}
