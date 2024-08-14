class Order {
  final String id;
  final String username;
  final Map<String, int> items;
  final double totalAmount;

  Order({
    required this.id,
    required this.username,
    required this.items,
    required this.totalAmount,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] as String,
      username: map['username'] as String,
      items: Map<String, int>.from(map['items']),
      totalAmount: map['totalAmount'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'username': username,
      'items': items,
      'totalAmount': totalAmount,
    };
  }
}
