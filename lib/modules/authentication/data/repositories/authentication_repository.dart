import 'package:firebase_auth/firebase_auth.dart';
import 'package:market/modules/authentication/data/models/user.dart';
import 'package:market/modules/authentication/data/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  Future<User?> signUp(
    String email,
    String password,
    String userName,
    String phoneNumber,
    String role,
  ) {
    return _authService.signUp(email, password, userName, phoneNumber, role);
  }

  Future<User?> login(String email, String password) {
    return _authService.login(email, password);
  }

  Future<void> logout() {
    return _authService.logout();
  }

  Stream<User?> get user => _authService.user;

  Future<Users?> getUserByEmail(String email) async {
    try {
      return _authService.getUserByEmail(email);
    } catch (e) {
      print('Error fetching admin: $e');
      return null;
    }
  }

  Future<String> getUserRole() async {
    try {
      return _authService.getUserRole();
    } catch (e) {
      throw Exception('Failed to fetch user role');
    }
  }
}
