import 'package:flutter/material.dart'; //include widgets și alte functionalitati necesare pentru crearea UI
import 'package:http/http.dart'
    as http; //utilizata pentru a face cereri la serverul web
import 'dart:convert'; //utilizata la conversia datelor (encode, decode JSON)

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
            'http://192.168.0.103:8080/auth/login'), //here I have to update with raspberrypi.local instead of IP adress
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to Smart Table!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Image.asset(
                  'lib/assets/login_page.jpg',
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20),
                TextField(
                  key: Key('username'),
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  key: Key('password'),
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 217, 207, 235),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('Login'),
                ),
                SizedBox(height: 20),
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
