import 'package:mongo_dart/mongo_dart.dart';

class MongoDBService {
  static late Db db;
  static late DbCollection usersCollection;

  static Future<void> connect() async {
    db = await Db.create(
        "mongodb+srv://krishnaprasad:Ayuktha%4063@flutter.y64ji.mongodb.net/?retryWrites=true&w=majority&appName=flutter");
    await db.open();
    usersCollection = db.collection('users');
    print("Connected to MongoDB");
  }

  static Future<Map<String, dynamic>?> getUser(String username) async {
    return await usersCollection.findOne(where.eq('username', username));
  }

  static Future<void> registerUser(String username, String password) async {
    await usersCollection.insertOne({
      'username': username,
      'password': password,
    });
  }

  static bool isAdmin(String username, String password) {
    // Static check for admin
    return username == 'admin' && password == 'admin';
  }
}
