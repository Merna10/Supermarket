import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    on<FetchOrders>(_onFetchOrders);
    on<LoadCart>(_onLoadCart);
    on<RemoveOrderItem>(_onRemoveOrderItem);
    on<UpdateOrderItemQuantity>(_onUpdateOrderItemQuantity);
    on<LoadOrdersOnAppStart>(_onLoadOrdersOnAppStart);
  }

  void _onAddOrderItem(AddOrderItem event, Emitter<OrderState> emit) async {
    try {
      await _hiveService.addItemToCart(event.orderItem);
      print('Added item: ${event.orderItem.toMap()}');
      add(LoadCart());
    } catch (e) {
      emit(OrderError(error: 'Failed to add item: ${e.toString()}'));
    }
  }

  void _onSubmitOrder(SubmitOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final cartItems = await _hiveService.getCartItems();
      final orderList = OrderList(
        id: 'orderId',
        items: cartItems,
        status: 'pending',
        total: cartItems
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

      await _orderRepository.addOrder(orderList, event.userId);
      await _hiveService.clearCart();
      emit(OrderSubmitted());
    } catch (e) {
      emit(OrderError(error: 'Failed to submit order: ${e.toString()}'));
    }
  }

  void _onFetchOrders(FetchOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orders = await _orderRepository.fetchOrders(event.userId);
      emit(OrderLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(error: 'Failed to fetch orders: ${e.toString()}'));
    }
  }

  void _onLoadCart(LoadCart event, Emitter<OrderState> emit) async {
    try {
      final cartItems = await _hiveService.getCartItems();
      Position position = await _locationService.getCurrentPosition();
      String address = await _locationService.getAddressFromLatLng(position);

      const double storeLat = 37.7749;
      const double storeLon = -122.4194;
      double distance = calculateDistance(
          position.latitude, position.longitude, storeLat, storeLon);
      double deliveryFee = calculateDeliveryFee(distance);

      print(
          'Loaded cart items: ${cartItems.map((item) => item.toMap()).toList()}');
      final total = cartItems.fold(
          0, (sum, item) => sum + (item.price * item.quantity).toInt());
      final orderList = OrderList(
        id: 'tempOrderId',
        items: cartItems,
        status: 'pending',
        total: total.toDouble(),
        deliveryAddress: address,
        deliveryFee: deliveryFee,
        date: DateTime.now(),
      );
      emit(CartLoaded(cartItems: orderList));
    } catch (e) {
      emit(OrderError(error: 'Failed to load cart: ${e.toString()}'));
    }
  }

  void _onRemoveOrderItem(
      RemoveOrderItem event, Emitter<OrderState> emit) async {
    try {
      await _hiveService.removeItemFromCart(event.orderItem);
      add(LoadCart());
    } catch (e) {
      emit(OrderError(error: 'Failed to remove item: ${e.toString()}'));
    }
  }

  void _onUpdateOrderItemQuantity(
      UpdateOrderItemQuantity event, Emitter<OrderState> emit) async {
    try {
      await _hiveService.updateItemQuantityInCart(
          event.orderItem, event.quantity);
      add(LoadCart());
    } catch (e) {
      emit(
          OrderError(error: 'Failed to update item quantity: ${e.toString()}'));
    }
  }

  void _onLoadOrdersOnAppStart(
      LoadOrdersOnAppStart event, Emitter<OrderState> emit) async {
    add(FetchOrders(userId: event.userId));
    add(LoadCart());
  }
}
