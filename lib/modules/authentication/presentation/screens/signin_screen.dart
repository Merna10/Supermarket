import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';
import 'package:market/modules/authentication/presentation/widgets/signup_address_page.dart';
import 'package:market/modules/authentication/presentation/widgets/signup_email_page.dart';
import 'package:market/modules/authentication/presentation/widgets/signup_user_details_page.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();

  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  void _completeSignUp() {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final location =
        '${_streetController.text}, ${_apartmentController.text}, ${_cityController.text}';
    authBloc.add(
      AuthSignUpEvent(
        email: _emailController.text,
        password: _passwordController.text,
        userName: _userNameController.text,
        phoneNumber: _phoneNumberController.text,
        location: location,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthError) {
            
          }
        },
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            SignUpEmailPage(
                emailController: _emailController,
                passwordController: _passwordController),
            SignUpUserDetailsPage(
                userNameController: _userNameController,
                phoneNumberController: _phoneNumberController),
            SignUpAddressPage(
              cityController: _cityController,
              streetController: _streetController,
              apartmentController: _apartmentController,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentPage > 0)
              ElevatedButton(
                onPressed: _previousPage,
                child: Text('Previous'),
              ),
            ElevatedButton(
              onPressed: _currentPage == 2 ? _completeSignUp : _nextPage,
              child: Text(_currentPage == 2 ? 'Complete Sign Up' : 'Next'),
            ),
          ],
        ),
      ),
    );
  }
}
