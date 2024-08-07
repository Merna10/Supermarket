import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';
import 'package:market/modules/authentication/presentation/widgets/signup_email_page.dart';
import 'package:market/modules/authentication/presentation/widgets/signup_user_details_page.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/Blogs-Featured-Imagessss.jpg',
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: MediaQuery.sizeOf(context).height * 0.33,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: HexColor('f1efde'), width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: HexColor('f1efde'), width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  cursorColor: HexColor('a57666'),
                                  textAlign: TextAlign.center,
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: HexColor('f1efde'), width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  cursorColor: HexColor('f1efde'),
                                  textAlign: TextAlign.center,
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    border: InputBorder.none,
                                  ),
                                  obscureText: true,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: HexColor('f1efde'), width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  cursorColor: HexColor('a57666'),
                                  textAlign: TextAlign.center,
                                  controller: _userNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'UserName',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: HexColor('f1efde'), width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  cursorColor: HexColor('f1efde'),
                                  textAlign: TextAlign.center,
                                  controller: _phoneNumberController,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone Number',
                                    border: InputBorder.none,
                                  ),
                                  obscureText: true,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () {
                                    context
                                        .read<AuthBloc>()
                                        .add(AuthSignUpEvent(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          userName: _userNameController.text,
                                          phoneNumber:
                                              _phoneNumberController.text,
                                        ));
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: HexColor('f1efde'),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                  ),
                                  child: Text(
                                    'SignUp',
                                    style: AppTextStyles.textTheme.labelLarge,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/');
                                },
                                child: Text(
                                  'Already have an account? Login',
                                  style: TextStyle(color: HexColor('a57666')),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
