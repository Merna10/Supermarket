import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market/modules/authentication/data/models/user.dart';

class AdminService {
  final FirebaseFirestore _firestore;

  AdminService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Users>> fetchAdmins() {
    try {
      return _firestore
          .collection('users')
          .where('role', isNotEqualTo: 'customer')
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Users.fromFirestore(doc)).toList());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addAdmin(Users admin) async {
    try {
      await _firestore.collection('users').doc(admin.id).set(admin.toMap());
    } catch (e) {
      throw Exception('Failed to add admin: $e');
    }
  }

  Future<void> updateAdmin(Users admin) async {
    try {
      await _firestore.collection('users').doc(admin.id).update(admin.toMap());
    } catch (e) {
      throw Exception('Failed to update admin: $e');
    }
  }

  Future<void> deleteAdmin(Users admin) async {
    try {
      await _firestore.collection('users').doc(admin.id).delete();
    } catch (e) {
      throw Exception('Failed to delete admin: $e');
    }
  }

  Future<bool> isSuperAdmin(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final admin = Users.fromFirestore(doc);
        return admin.role == 'super_admin';
      }
      return false;
    } catch (e) {
      throw Exception('Failed to check admin role: $e');
    }
  }

  Future<Users?> getAdminByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('admins')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return Users.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching admin: $e');
      return null;
    }
  }
}
