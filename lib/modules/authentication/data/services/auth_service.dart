import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market/modules/authentication/data/models/user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthService({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<User?> signUp(
    String email,
    String password,
    String userName,
    String phoneNumber,
    String role,
  ) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        Users newUser = Users(
            id: user.uid,
            email: email,
            userName: userName,
            phoneNumber: phoneNumber,
            role: 'customer');
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Stream<User?> get user => _firebaseAuth.authStateChanges();

  Future<Users?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
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

  Future<String> getUserRole() async {
  final user = FirebaseAuth.instance.currentUser;
  final userId = user?.uid;

  if (userId == null) {
    throw Exception('User not logged in');
  }

  try {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.data()?['role'] ?? 'default';
    }
    return 'default';
  } catch (e) {
    throw Exception('Failed to fetch user role');
  }
}

}
