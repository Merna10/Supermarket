import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex(context),
        onTap: (index) {
          _onNavBarTapped(context, index);
        },
      ),
    );
  }

  int _currentIndex(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name;
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

  void _onNavBarTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/categories');
        break;
      case 2:
        Navigator.pushNamed(context, '/cart');
        break;
    }
  }
}
