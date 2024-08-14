import 'package:flutter/material.dart';
import '../services/mongodb_service.dart';
import '../services/order_service.dart';

class AdminDashboardPage extends StatefulWidget {
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> orders = [];
  bool loadingUsers = false;
  bool loadingOrders = false;
  bool showUsers = false;
  bool showOrders = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadUsers() async {
    setState(() {
      loadingUsers = true;
      errorMessage = '';
    });
    try {
      final usersCollection = MongoDBService.usersCollection;
      final userList = await usersCollection.find().toList();
      setState(() {
        users = userList;
        showUsers = true;
        showOrders = false; // Hide orders when users are displayed
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load users data: $e';
      });
    } finally {
      setState(() {
        loadingUsers = false;
      });
    }
  }

  Future<void> _loadOrders() async {
    setState(() {
      loadingOrders = true;
      errorMessage = '';
    });
    try {
      final ordersCollection = OrderService.ordersCollection;
      final orderList = await ordersCollection.find().toList();
      setState(() {
        orders = orderList;
        showOrders = true;
        showUsers = false; // Hide users when orders are displayed
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load orders data: $e';
      });
    } finally {
      setState(() {
        loadingOrders = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                onPressed: _loadUsers,
                child: Text('View Users'),
              ),
              ElevatedButton(
                onPressed: _loadOrders,
                child: Text('View Orders'),
              ),
            ],
          ),
          SizedBox(height: 20),
          if (loadingUsers || loadingOrders) ...[
            CircularProgressIndicator(),
          ] else if (errorMessage.isNotEmpty) ...[
            Text(errorMessage, style: TextStyle(color: Colors.red)),
          ] else if (showUsers) ...[
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Username')),
                    DataColumn(label: Text('Password')),
                  ],
                  rows: users.map((user) {
                    return DataRow(
                      cells: [
                        DataCell(Text(user['username'])),
                        DataCell(
                            Text(user['password'])), // Consider masking this
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ] else if (showOrders) ...[
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Username')),
                    DataColumn(label: Text('Total Amount')),
                  ],
                  rows: orders.map((order) {
                    return DataRow(
                      cells: [
                        DataCell(Text(order['username'])),
                        DataCell(Text(order['totalAmount'].toString())),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
