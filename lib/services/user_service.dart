import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  static final _collection = FirebaseFirestore.instance.collection('users');

  static Future<List<User>> fetchUsers() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return User(
        id: doc.id,
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'] ?? '',
        company: data['company'] ?? '',
        website: data['website'] ?? '',
      );
    }).toList();
  }

  static Future<void> addUser(User user) async {
    await _collection.add(user.toMap());
  }

  static Future<void> updateUser(User user) async {
    await _collection.doc(user.id).update(user.toMap());
  }

  static Future<void> deleteUser(String id) async {
    await _collection.doc(id).delete();
  }
}
