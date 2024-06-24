import 'package:firebase_auth/firebase_auth.dart';
import 'package:market/modules/authentication/data/models/user.dart';

class AuthenticationRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Users?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      return Users(id: user?.uid ?? '', email: user?.email ?? '', userName: user?.displayName ?? '');
    } catch (e) {
      // Handle login error
      print('Login error: $e');
      return null;
    }
  }

  Future<void> registerUser(String userName, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(userName);
      // Registration successful, userCredential contains user information
      print('User registered: ${userCredential.user?.email}');
    } catch (e) {
      // Handle registration error
      print('Registration error: $e');
    }
  }

  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
      // Logout successful
    } catch (e) {
      // Handle logout error
      print('Logout error: $e');
    }
  }
}
