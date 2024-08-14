import 'package:mongo_dart/mongo_dart.dart';
import '../models/order.dart';
import 'upi_payment_service.dart'; // Import the file where UpiPaymentService is defined

class OrderService {
  static late Db db;
  static late DbCollection ordersCollection;

  static Future<void> connect() async {
    db = await Db.create(
        "mongodb+srv://krishnaprasad:Ayuktha%4063@flutter.y64ji.mongodb.net/?retryWrites=true&w=majority&appName=flutter");
    await db.open();
    ordersCollection = db.collection('orders');
    print("Connected to MongoDB and ordersCollection initialized");
  }

  static Future<void> createOrder(
      String username, Map<String, int> items, double totalAmount) async {
    // Ensure the connection and collection are initialized
    if (ordersCollection == null) {
      await connect();
    }

    // Process payment
    bool paymentSuccessful =
        await UpiPaymentService.makePayment(totalAmount, 'Order Payment');

    if (paymentSuccessful) {
      final order = Order(
        id: DateTime.now().toString(),
        username: username,
        items: items,
        totalAmount: totalAmount,
      );

      await ordersCollection.insertOne(order.toMap());
    } else {
      // Handle payment failure (e.g., show an error message to the user)
      print('Payment failed. Order not placed.');
      throw Exception('Payment failed');
    }
  }
}
