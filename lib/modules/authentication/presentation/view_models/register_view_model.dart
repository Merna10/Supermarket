import 'package:flutter/material.dart';
import 'package:market/modules/authentication/data/repositories/authentication_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthenticationRepository _authRepository;

  RegisterViewModel(this._authRepository);

  String _email = '';
  String _password = '';
  String _userName = '';

  String get email => _email;
  String get password => _password;
  String get userName => _userName;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }

  Future<void> register() async {
    try {
      await _authRepository.registerUser(_userName, _email, _password);
    } catch (e) {
      print('Registration error: $e');
    }
  }
}
