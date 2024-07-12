// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
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
              return Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLoginEvent(
                        email: _emailController.text,
                        password: _passwordController.text,
                      ));
                    },
                    child: Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthSignUpEvent(
                        email: _emailController.text,
                        password: _passwordController.text,
                      ));
                    },
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
