import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:market/modules/authentication/presentation/screens/login_screen.dart';
import 'package:market/modules/authentication/presentation/screens/signin_screen.dart';
import 'package:market/modules/home/presentation/screens/home_screen.dart';
import 'package:market/modules/order_history/presentation/screens/history_screen.dart';
import 'package:market/modules/cart/presentation/cart_screen.dart';
import 'package:market/modules/categories/presentation/screens/category_screen.dart';
import 'package:market/shared/widgets/scaffold_with_nav_bar.dart';

class AppRoutes {
  static const String login = '/';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String history = '/history';
  static const String cart = '/cart';
  static const String categories = '/categories';

  static Map<String, WidgetBuilder> getRoutes() {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';

    return {
      login: (context) => const LoginScreen(),
      signup: (context) => const SignUpScreen(),
      home: (context) => const ScaffoldWithNavBar(child: HomeScreen()),
      history: (context) => const ScaffoldWithNavBar(child: HistoryScreen()),
      cart: (context) => const CartScreen(),
      categories: (context) => const ScaffoldWithNavBar(child: CategoryScreen()),
    };
  }
}
