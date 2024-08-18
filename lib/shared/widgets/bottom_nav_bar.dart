import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/app/theme/colors.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        List<BottomNavigationBarItem> items = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.view_comfy_alt_outlined),
            label: 'Categories',
          ),
        ];

        if (state is AuthAuthenticated) {
          if (state.role == 'customer') {
            items.add(
              const BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
            );
            items.add(const BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ));
          } else if (state.role == 'super_admin') {
            items.addAll([
              const BottomNavigationBarItem(
                icon: Icon(Icons.receipt),
                label: 'Orders',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.admin_panel_settings),
                label: 'Admin',
              ),
            ]);
          }
        } else if (state is AuthUnauthenticated) {
          items.add(
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
          );
        }

        return BottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: widget.onTap,
          selectedItemColor: AppColors.accentColor,
          unselectedItemColor: Colors.grey,
          items: items,
        );
      },
    );
  }
}
