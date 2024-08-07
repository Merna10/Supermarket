import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Drawer(
          child: Column(
            children: [
              Container(
                height: 60,
                color: HexColor('f1efde'),
                child: Center(
                  child: Text(
                    'Menu',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: state is AuthAuthenticated
                      ? [
                          ListTile(
                            leading: const Icon(Icons.home),
                            title: const Text('Home'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/home');
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.history),
                            title: const Text('Your Orders'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/history');
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Logout'),
                            onTap: () {
                              Navigator.pop(context);
                              context.read<AuthBloc>().add(AuthLogoutEvent());
                            },
                          ),
                        ]
                      : [
                          ListTile(
                            leading: const Icon(Icons.login),
                            title: const Text('Login'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/');
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.info),
                            title: const Text(
                                'Please login to access more features.'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
