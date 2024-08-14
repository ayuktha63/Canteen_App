import 'package:flutter/material.dart';

void main() {
runApp(MyApp());
}

class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Login Page',
theme: ThemeData(
primarySwatch: Colors.blue,
),
home: LoginPage(),
);
}
}

class LoginPage extends StatefulWidget {
@override
_LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
final _usernameController = TextEditingController();
final _passwordController = TextEditingController();
final _formKey = GlobalKey<FormState>();

void _login() {
if (_formKey.currentState!.validate()) {
// Perform login action
print('Username: ${_usernameController.text}');
print('Password: ${_passwordController.text}');
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('Login Page'),
),
body: Padding(
padding: const EdgeInsets.all(16.0),
child: Form(
key: _formKey,
child: Column(
mainAxisSize: MainAxisSize.min,
children: <Widget>[
TextFormField(
controller: _usernameController,
decoration: InputDecoration(labelText: 'Username'),
validator: (value) {
if (value == null || value.isEmpty) {
return 'Please enter your username';
}
return null;
},
),
TextFormField(
controller: _passwordController,
decoration: InputDecoration(labelText: 'Password'),
obscureText: true,
validator: (value) {
if (value == null || value.isEmpty) {
return 'Please enter your password';
}
return null;
},
),
SizedBox(height: 20),
ElevatedButton(
onPressed: _login,
child: Text('Login'),
),
],
),
),
),
);
}
}
