import 'package:flutter/material.dart';
import 'cart_page.dart';

class CanteenMenuPage extends StatefulWidget {
  final String username; // Add this line

  CanteenMenuPage({required this.username}); // Add this line

  @override
  _CanteenMenuPageState createState() => _CanteenMenuPageState();
}

class _CanteenMenuPageState extends State<CanteenMenuPage> {
  final Map<String, int> _orderItems = {};

  void _updateOrder(String item, int quantity) {
    setState(() {
      if (quantity > 0) {
        _orderItems[item] = quantity;
      } else {
        _orderItems.remove(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Canteen Menu'),
      ),
      body: ListView(
        children: <Widget>[
          _buildMenuItem('Biryani', 1),
          _buildMenuItem('Fried Rice', 2),
          _buildMenuItem('Chili Chicken', 1),
          // Add more menu items here
        ],
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: _orderItems.isEmpty
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(
                      orderItems: _orderItems,
                      username: widget.username, // Pass the username here
                    ),
                  ),
                );
              },
        child: Text('Proceed'),
      ),
    );
  }

  Widget _buildMenuItem(String item, double price) {
    int quantity = _orderItems[item] ?? 0;

    return ListTile(
      title: Text(item),
      subtitle: Text('₹${price.toStringAsFixed(2)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () => _updateOrder(item, quantity - 1),
          ),
          Text('$quantity'),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _updateOrder(item, quantity + 1),
          ),
        ],
      ),
    );
  }
}
