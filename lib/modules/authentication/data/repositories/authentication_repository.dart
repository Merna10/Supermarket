import 'package:firebase_auth/firebase_auth.dart';
import 'package:market/modules/authentication/data/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  Future<User?> signUp(String email, String password, String userName, String phoneNumber, ) {
    return _authService.signUp(email, password, userName, phoneNumber, );
  }

  Future<User?> login(String email, String password) {
    return _authService.login(email, password);
  }

  Future<void> logout() {
    return _authService.logout();
  }

  Stream<User?> get user => _authService.user;
}
