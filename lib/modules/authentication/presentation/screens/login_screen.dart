import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/app/theme/colors.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading || state is AuthInitial) {
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
                            Border.all(color: AppColors.primaryColor, width: 2),
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
                                    color: AppColors.primaryColor, width: 2),
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
                                    color: AppColors.primaryColor, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                cursorColor: AppColors.primaryColor,
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
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  context.read<AuthBloc>().add(AuthLoginEvent(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ));
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: AppColors.primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                ),
                                child: Text(
                                  'Login',
                                  style: AppTextStyles.textTheme.labelLarge,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: Text(
                                'Don\'t have an account? Sign up',
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
    );
  }
}
