import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'services/mongodb_service.dart';
import 'services/order_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDBService.connect();
  await OrderService.connect(); // Ensure OrderService is connected
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canteen App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Updated to LoginPage
    );
  }
}
