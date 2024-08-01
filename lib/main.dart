// lib/main.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/app/routes/routes.dart';
import 'package:market/app/theme/app_theme.dart';
import 'package:market/core/services/location_service.dart';
import 'package:market/modules/authentication/data/repositories/authentication_repository.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';
import 'package:market/modules/cart/data/repositories/cart_repository.dart';
import 'package:market/modules/cart/data/services/hive_services.dart';
import 'package:market/modules/cart/logic/bloc/order_bloc.dart';
import 'package:market/modules/categories/data/repositories/category_repository.dart';
import 'package:market/modules/categories/logic/bloc/category_bloc.dart';
import 'package:market/modules/products/data/repositories/product_repository.dart';
import 'package:market/modules/products/logic/bloc/product_bloc.dart';
import 'package:market/modules/order_history/data/repositories/history_repository.dart';
import 'package:market/modules/order_history/logic/bloc/history_bloc.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final hiveService = HiveService();
  await hiveService.initHive();
  await Geolocator.requestPermission();
  runApp(MyApp(hiveService: hiveService));
}

class MyApp extends StatelessWidget {
  final HiveService hiveService;

  const MyApp({super.key, required this.hiveService});

  @override
  Widget build(BuildContext context) {
   
    hiveService.getCartItems().then((items) {
      print('Loaded cart items on startup: $items');
    });

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
          create: (context) => OrderBloc(
              locationService: LocationService(),
              orderRepository: OrderRepository(FirebaseFirestore.instance),
              hiveService: hiveService),
        ),
        BlocProvider(
          create: (context) => HistoryBloc(
            HistoryRepository: HistoryRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.login,
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
