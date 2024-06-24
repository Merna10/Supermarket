import 'package:flutter/material.dart';
import 'package:market/modules/authentication/data/repositories/authentication_repository.dart';
import 'package:market/modules/authentication/presentation/view/login_view.dart';
import 'package:market/modules/authentication/presentation/view_models/register_view_model.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthenticationRepository authRepository = AuthenticationRepository();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterViewModel(authRepository),
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Center(
          child: Consumer<RegisterViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    onChanged: (value) => viewModel.setUserName(value),
                    decoration: const InputDecoration(labelText: 'UserName'),
                  ),
                  TextField(
                    onChanged: (value) => viewModel.setEmail(value),
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    onChanged: (value) => viewModel.setPassword(value),
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  ElevatedButton(
                    onPressed: () => viewModel.register(),
                    child: const Text('Register'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text('Already has an email.'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
