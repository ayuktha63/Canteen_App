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
  List<Map<String, dynamic>> filteredUsers = [];
  List<Map<String, dynamic>> filteredOrders = [];
  bool loadingUsers = false;
  bool loadingOrders = false;
  bool showUsers = false;
  bool showOrders = false;
  String errorMessage = '';
  String searchQuery = '';

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
        filteredUsers = userList;
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
        filteredOrders = orderList;
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

  void _filterUsers(String query) {
    setState(() {
      searchQuery = query;
      filteredUsers = users.where((user) {
        final username = user['username'].toString().toLowerCase();
        final searchLower = query.toLowerCase();
        return username.contains(searchLower);
      }).toList();
    });
  }

  void _filterOrders(String query) {
    setState(() {
      searchQuery = query;
      filteredOrders = orders.where((order) {
        final username = order['username'].toString().toLowerCase();
        final searchLower = query.toLowerCase();
        return username.contains(searchLower);
      }).toList();
    });
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
          if (showUsers || showOrders) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: showUsers ? 'Search Users' : 'Search Orders',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (showUsers) {
                    _filterUsers(value);
                  } else if (showOrders) {
                    _filterOrders(value);
                  }
                },
              ),
            ),
          ],
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
                  rows: filteredUsers.map((user) {
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
                  rows: filteredOrders.map((order) {
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
