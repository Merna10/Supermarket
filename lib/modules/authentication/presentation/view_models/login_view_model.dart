import 'package:flutter/material.dart';
import 'package:market/modules/authentication/data/models/user.dart';
import 'package:market/modules/authentication/data/repositories/authentication_repository.dart';
import 'package:market/modules/home/presentation/view/home_view.dart';


class LoginViewModel extends ChangeNotifier {
  final AuthenticationRepository _authRepository;
  final BuildContext context;

  LoginViewModel(this._authRepository, this.context);

  String _email = '';
  String _password = '';

  String get email => _email;
  String get password => _password;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  Future<void> login() async {
    try {
      // Perform login using authentication repository
      Users? user = await _authRepository.loginUser(_email, _password);
      if (user != null) {
        // Navigate to home screen upon successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  HomeScreen()),
        );
      } else {
        // Handle login failure
      }
    } catch (e) {
      // Handle login error
    }
  }
}
