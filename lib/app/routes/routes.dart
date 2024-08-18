import 'package:flutter/material.dart';
import 'package:market/core/enum/fetch_method.dart';
import 'package:market/modules/admins/presentation/screens/admin_screen.dart';
import 'package:market/modules/authentication/presentation/screens/login_screen.dart';
import 'package:market/modules/authentication/presentation/screens/signin_screen.dart';
import 'package:market/modules/cart/presentation/submit_order.dart';
import 'package:market/modules/home/presentation/screens/home_screen.dart';
import 'package:market/modules/order_history/presentation/screens/history_screen.dart';
import 'package:market/modules/cart/presentation/cart_screen.dart';
import 'package:market/modules/categories/presentation/screens/category_screen.dart';
import 'package:market/modules/products/presentation/screens/add_products.dart';
import 'package:market/modules/products/presentation/screens/fav_products.dart';
import 'package:market/shared/widgets/scaffold_with_nav_bar.dart';

class AppRoutes {
  static const String login = '/';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String history = '/history';
  static const String cart = '/cart';
  static const String categories = '/categories';
  static const String checkout = '/checkout';
  static const String favorites = '/favorites';
  static const String adminSuper = '/adminSuper';

  static const String addProduct = '/addProduct';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      signup: (context) => const SignUpScreen(),
      adminSuper: (context) => const ScaffoldWithNavBar(child: AdminScreen()),
      home: (context) => const ScaffoldWithNavBar(child: HomeScreen()),
      history: (context) {
        final String? id =
            ModalRoute.of(context)?.settings.arguments as String?;
        return ScaffoldWithNavBar(child: HistoryScreen(id: id ?? ''));
      },
      addProduct: (context) {
        final String? fetchId =
            ModalRoute.of(context)?.settings.arguments as String?;
        final FetchMethod? method =
            ModalRoute.of(context)?.settings.arguments as FetchMethod?;
        return ScaffoldWithNavBar(
            child: AddProductScreen(
          fetchId: fetchId ?? '',
          fetchMethod: method ?? FetchMethod.byCategory,
        ));
      },
      favorites: (context) =>
          const ScaffoldWithNavBar(child: FavProductScreen()),
      cart: (context) => const CartScreen(),
      categories: (context) =>
          const ScaffoldWithNavBar(child: CategoryScreen()),
      checkout: (context) => SubmitOrderScreen(
          price: ModalRoute.of(context)!.settings.arguments as double),
    };
  }
}
