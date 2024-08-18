import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bottom_nav_bar.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  final Widget child;
  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading || state is AuthInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          return BottomNavBar(
            currentIndex: _currentIndex(context, state),
            onTap: (index) {
              _onNavBarTapped(context, index, state);
            },
          );
        },
      ),
    );
  }

  int _currentIndex(BuildContext context, AuthState state) {
    final routeName = ModalRoute.of(context)?.settings.name;

    if (state is AuthAuthenticated) {
      if (state.role == 'customer') {
        switch (routeName) {
          case '/home':
            return 0;
          case '/categories':
            return 1;
          case '/cart':
            return 2;
          case '/profile':
            return 3;
          default:
            return 0;
        }
      } else if (state.role == 'super_admin') {
        switch (routeName) {
          case '/home':
            return 0;
          case '/categories':
            return 1;
          case '/admin':
            return 2;
          case '/settings':
            return 3;
          default:
            return 0;
        }
      }
    } else if (state is AuthUnauthenticated) {
      switch (routeName) {
        case '/home':
          return 0;
        case '/categories':
          return 1;
        case '/cart':
          return 2;
        default:
          return 0;
      }
    }

    return 0;
  }

  void _onNavBarTapped(BuildContext context, int index, AuthState state) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/categories');
        break;

      case 2:
        if (state is AuthAuthenticated && state.role == 'super_admin') {
          Navigator.pushNamed(context, '/history');
        } else if (state is AuthAuthenticated && state.role == 'customer') {
          Navigator.pushNamed(context, '/profile');
        }
        break;

      case 3:
        if (state is AuthAuthenticated && state.role == 'super_admin') {
          Navigator.pushNamed(context, '/adminSuper');
        } else {
          Navigator.pushNamed(context, '/cart');
        }
        break;
    }
  }
}
