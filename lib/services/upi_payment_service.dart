import 'package:upi_india/upi_india.dart';

class UpiPaymentService {
  static Future<bool> makePayment(double amount, String description) async {
    final upiIndia = UpiIndia();

    try {
      // Create a transaction and start it
      final UpiResponse response = await upiIndia.startTransaction(
        app: UpiApp.googlePay, // Use the desired UPI app
        receiverUpiId:
            'littysarajohn18@oksbi', // Replace with actual receiver UPI ID
        receiverName: 'Litty Sara John', // Replace with actual receiver name
        transactionNote: description,
        transactionRefId: DateTime.now()
            .millisecondsSinceEpoch
            .toString(), // Unique transaction ID
        amount: amount, // Amount should be a double
      );

      // Handle response
      if (response.status == UpiPaymentStatus.SUCCESS) {
        print('Payment successful');
        return true;
      } else {
        print('Payment failed with status: ${response.status}');
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
