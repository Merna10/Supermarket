// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/app/theme/app_theme.dart';
import 'package:market/modules/authentication/data/repositories/authentication_repository.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';
import 'package:market/modules/authentication/presentation/screens/login_screen.dart';
import 'package:market/modules/cart/data/repositories/cart_repository.dart';
import 'package:market/modules/cart/logic/bloc/order_bloc.dart';
import 'package:market/modules/categories/data/repositories/category_repository.dart';
import 'package:market/modules/categories/logic/bloc/category_bloc.dart';
import 'package:market/modules/home/presentation/screens/home_screen.dart';
import 'package:market/modules/products/data/repositories/product_repository.dart';
import 'package:market/modules/products/logic/bloc/product_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String userId = "byYx0b3MJ5IGNHToI5Ws"; // replace with actual user ID
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: AuthRepository())
            ..add(AuthCheckStatusEvent()),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) =>
              CategoryBloc(categoryRepository: CategoryRepository()),
        ),
        BlocProvider<ProductBloc>(
          create: (context) =>
              ProductBloc(productRepository: ProductRepository()),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => OrderBloc(orderRepository: OrderRepository()),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        routes: {
          '/': (context) => LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
