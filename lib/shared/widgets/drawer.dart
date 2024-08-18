import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/app/theme/colors.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        return Drawer(
          child: Column(
            children: [
              Container(
                height: 60,
                color: AppColors.primaryColor,
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
                          // if (state.role == 'customer')
                          ListTile(
                            leading: const Icon(Icons.history),
                            title: const Text('Your Orders'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/history',
                                  arguments: userId);
                            },
                          ),
                          if (state.role == 'customer')
                            ListTile(
                              leading: const Icon(Icons.favorite),
                              title: const Text('Wishlist'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/favorites');
                              },
                            ),
                          if (state.role == 'super_admin')
                            ListTile(
                              leading: const Icon(Icons.admin_panel_settings),
                              title: const Text('Admin Panel'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/adminSuper');
                              },
                            ),
                          ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Logout'),
                            onTap: () {
                              context.read<AuthBloc>().add(AuthLogoutEvent());
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/');
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
