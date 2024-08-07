import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:market/core/services/location_service.dart';
import 'package:market/core/utils/delivery_fee_util.dart';
import 'package:market/modules/cart/data/models/cart_item_model.dart';
import 'package:market/shared/models/order_list.dart';
import 'package:market/modules/cart/data/repositories/cart_repository.dart';
import 'package:market/modules/cart/data/services/hive_services.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;
  final HiveService _hiveService;
  final LocationService _locationService;

  OrderBloc({
    required OrderRepository orderRepository,
    required HiveService hiveService,
    required LocationService locationService,
  })  : _orderRepository = orderRepository,
        _hiveService = hiveService,
        _locationService = locationService,
        super(OrderInitial()) {
    on<AddOrderItem>(_onAddOrderItem);
    on<SubmitOrder>(_onSubmitOrder);
    on<LoadCart>(_onLoadCart);
    on<RemoveOrderItem>(_onRemoveOrderItem);
    on<UpdateOrderItemQuantity>(_onUpdateOrderItemQuantity);
    on<LoadOrdersOnAppStart>(_onLoadOrdersOnAppStart);
    on<Logout>(_onLogout);
  }

  Future<bool> _isUserLoggedIn() async {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  void _onAddOrderItem(AddOrderItem event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    final isLoggedIn = await _isUserLoggedIn();
    try {
      if (isLoggedIn) {
        final user = FirebaseAuth.instance.currentUser;
        final userId = user?.uid;
        await _orderRepository.addItemToCart(
            event.orderItem, userId.toString());
      } else {
        await _hiveService.addItemToCart(event.orderItem);
      }
      add(LoadCart());
    } catch (e) {
      emit(OrderError(error: 'Failed to add item: ${e.toString()}'));
    }
  }

  void _onSubmitOrder(SubmitOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final isLoggedIn = await _isUserLoggedIn();
      final cartItems = isLoggedIn
          ? await _orderRepository.fetchCartItems(event.userId)
          : await _hiveService.getCartItems();

      final availableItems = <OrderItem>[];
      final outOfStockItems = <OrderItem>[];

      for (var item in cartItems) {
        final currentQuantity =
            await _orderRepository.getProductQuantity(item.productId);
        final updatedQuantity = currentQuantity - item.quantity;

        if (updatedQuantity < 0) {
          // Item is out of stock
          outOfStockItems.add(item);
        } else {
          availableItems.add(item);
          if (updatedQuantity == 0) {
            await _orderRepository.updateProductQuantity(
                item.productId, updatedQuantity, event.userId);
          } else {
            await _orderRepository.updateProductQuantity(
                item.productId, updatedQuantity, event.userId);
          }
        }
      }

      if (availableItems.isEmpty) {
        emit(const OrderError(error: 'All items are out of stock.'));
        return;
      }

      final orderList = OrderList(
        id: 'orderId',
        items: availableItems,
        status: 'pending',
        total: availableItems
                .fold(
                  0,
                  (sum, item) => sum + (item.price * item.quantity).toInt(),
                )
                .toDouble() +
            event.deliveryFees,
        deliveryAddress: event.deliveryAddress,
        deliveryFee: event.deliveryFees,
        date: DateTime.now(),
      );

      if (isLoggedIn) {
        final user = FirebaseAuth.instance.currentUser;
        final userId = user!.uid;

        await _orderRepository.addOrder(orderList, userId);
        await _orderRepository.clearCart(userId);
      } else {
        await _hiveService.clearCart();
      }

      emit(OrderSubmitted());
    } catch (e) {
      emit(OrderError(error: 'Failed to submit order: ${e.toString()}'));
    }
  }

  void _onLoadCart(LoadCart event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    final isLoggedIn = await _isUserLoggedIn();
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    try {
      final cartItems = isLoggedIn
          ? await _orderRepository.fetchCartItems(userId.toString())
          : await _hiveService.getCartItems();

      final availableItems = <OrderItem>[];
      final outOfStockItems = <OrderItem>[]; // Initialize outOfStockItems

      for (var item in cartItems) {
        final availability =
            await _orderRepository.getAvailability(item.productId);
        if (availability == true) {
          availableItems.add(item);
        } else {
          outOfStockItems.add(item); // Add to outOfStockItems if not available
        }
      }

      Position position = await _locationService.getCurrentPosition();
      String address = await _locationService.getAddressFromLatLng(position);

      const double storeLat = 37.7749;
      const double storeLon = -122.4194;
      double distance = calculateDistance(
          position.latitude, position.longitude, storeLat, storeLon);
      double deliveryFee = calculateDeliveryFee(distance);

      final total = availableItems.fold(
          0, (sum, item) => sum + (item.price * item.quantity).toInt());

      final orderList = OrderList(
        id: 'tempOrderId',
        items: availableItems,
        status: 'pending',
        total: total.toDouble(),
        deliveryAddress: address,
        deliveryFee: deliveryFee,
        date: DateTime.now(),
      );

      emit(CartLoaded(
          cartItems: orderList,
          outOfStockItems: outOfStockItems)); // Pass outOfStockItems
    } catch (e) {
      emit(OrderError(error: 'Failed to load cart: ${e.toString()}'));
    }
  }

  void _onRemoveOrderItem(
      RemoveOrderItem event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    final isLoggedIn = await _isUserLoggedIn();
    try {
      if (isLoggedIn) {
        final user = FirebaseAuth.instance.currentUser;
        final userId = user?.uid;
        await _orderRepository.removeItemFromCart(
            event.orderItem, userId.toString());
      } else {
        await _hiveService.removeItemFromCart(event.orderItem);
      }
      add(LoadCart());
    } catch (e) {
      emit(OrderError(error: 'Failed to remove item: ${e.toString()}'));
    }
  }

  void _onUpdateOrderItemQuantity(
      UpdateOrderItemQuantity event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    final isLoggedIn = await _isUserLoggedIn();
    try {
      if (event.quantity <= 0) {
        if (isLoggedIn) {
          final user = FirebaseAuth.instance.currentUser;
          final userId = user?.uid;
          if (userId != null) {
            await _orderRepository.removeItemFromCart(event.orderItem, userId);
          } else {
            emit(const OrderError(error: 'User not logged in'));
            return;
          }
        } else {
          await _hiveService.removeItemFromCart(event.orderItem);
        }
      } else {
        if (isLoggedIn) {
          final user = FirebaseAuth.instance.currentUser;
          final userId = user?.uid;
          if (userId != null) {
            await _orderRepository.updateItemQuantityInCart(
                event.orderItem, event.quantity, userId);
          } else {
            emit(const OrderError(error: 'User not logged in'));
            return;
          }
        } else {
          await _hiveService.updateItemQuantityInCart(
              event.orderItem, event.quantity);
        }
      }
      add(LoadCart());
    } catch (e) {
      emit(
          OrderError(error: 'Failed to update item quantity: ${e.toString()}'));
    }
  }

  void _onLoadOrdersOnAppStart(
      LoadOrdersOnAppStart event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    add(FetchOrders(userId: event.userId));
    add(LoadCart());
  }

  void _onLogout(Logout event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final isLoggedIn = await _isUserLoggedIn();
      if (isLoggedIn) {
        final user = FirebaseAuth.instance.currentUser;
        final userId = user?.uid;
        final cartItems = await _hiveService.getCartItems();
        final cartData = cartItems.map((item) => item.toMap()).toList();
        await _orderRepository.saveCartToUser(userId.toString(), cartData);
        await _hiveService.clearCart();
      } else {
        await _hiveService.clearCart();
      }
      emit(LogoutSuccess());
    } catch (e) {
      emit(OrderError(error: 'Failed to handle logout: ${e.toString()}'));
    }
  }
}

