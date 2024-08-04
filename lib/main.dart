import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:market/app/routes/routes.dart';
import 'package:market/app/theme/app_theme.dart';
import 'package:market/core/services/location_service.dart';
import 'package:market/modules/authentication/data/repositories/authentication_repository.dart';
import 'package:market/modules/authentication/logic/bloc/auth_bloc.dart';
import 'package:market/modules/cart/data/repositories/cart_repository.dart';
import 'package:market/modules/cart/data/services/cart_service.dart';
import 'package:market/modules/cart/data/services/hive_services.dart';
import 'package:market/modules/cart/logic/bloc/order_bloc.dart';
import 'package:market/modules/categories/data/repositories/category_repository.dart';
import 'package:market/modules/categories/logic/bloc/category_bloc.dart';
import 'package:market/modules/products/data/repositories/product_repository.dart';
import 'package:market/modules/products/logic/bloc/product_bloc.dart';
import 'package:market/modules/order_history/data/repositories/history_repository.dart';
import 'package:market/modules/order_history/logic/bloc/history_bloc.dart';
import 'package:market/modules/review/data/repositories/review_repository.dart';
import 'package:market/modules/review/data/services/review_service.dart';
import 'package:market/modules/review/logic/bloc/review_bloc.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepository: AuthRepository(), cartRepository: OrderRepository())
            ..add(AuthCheckStatusEvent()),
        ),
        BlocProvider<CategoryBloc>(
          create: (_) => CategoryBloc(categoryRepository: CategoryRepository()),
        ),
        BlocProvider<ProductBloc>(
          create: (_) => ProductBloc(productRepository: ProductRepository()),
        ),
        BlocProvider<OrderBloc>(
          create: (_) => OrderBloc(
            locationService: LocationService(),
            orderRepository: OrderRepository(orderService: OrderService()),
            hiveService: hiveService,
            ),
        ),
        BlocProvider<HistoryBloc>(
          create: (_) => HistoryBloc(historyRepository:  HistoryRepository()),
        ),
        BlocProvider<ReviewBloc>(
          create: (_) => ReviewBloc( ReviewRepository(ReviewService()))
            ..add(FetchReviewsEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.home,
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
