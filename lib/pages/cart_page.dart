import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../services/upi_payment_service.dart'; // Import the UPI payment service
import 'order_successful_page.dart';

class CartPage extends StatelessWidget {
  final Map<String, int> orderItems;
  final String username;

  CartPage({required this.orderItems, required this.username});

  @override
  Widget build(BuildContext context) {
    double totalAmount = orderItems.entries.fold(
      0.0,
      (sum, entry) {
        double price = entry.key == 'Biryani'
            ? 1
            : entry.key == 'Fried Rice'
                ? 2
                : 1;
        return sum + (price * entry.value);
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: orderItems.entries.map((entry) {
                String item = entry.key;
                int quantity = entry.value;
                double price = item == 'Biryani'
                    ? 1
                    : item == 'Fried Rice'
                        ? 2
                        : 1;
                return ListTile(
                  title: Text(item),
                  trailing: Text('₹${(price * quantity).toStringAsFixed(2)}'),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: ₹${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              bool paymentSuccessful = await UpiPaymentService.makePayment(
                totalAmount,
                "Order Payment",
              );
              if (paymentSuccessful) {
                await OrderService.createOrder(
                  username,
                  orderItems,
                  totalAmount,
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OrderSuccessfulPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Payment failed. Please try again.'),
                  ),
                );
              }
            },
            child: Text('Place Order'),
          ),
        ],
      ),
    );
  }
}
