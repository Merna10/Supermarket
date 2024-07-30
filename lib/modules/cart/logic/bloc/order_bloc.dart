import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market/modules/cart/data/models/cart_item_model.dart';
import 'package:market/modules/cart/data/models/order_list.dart';
import 'package:market/modules/cart/data/repositories/cart_repository.dart';
import 'package:market/modules/cart/data/services/hive_services.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;
  final HiveService _hiveService;

  OrderBloc({
    required OrderRepository orderRepository,
    required HiveService hiveService,
  })  : _orderRepository = orderRepository,
        _hiveService = hiveService,
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
    await _hiveService.addItemToCart(event.orderItem);
    print('Added item: ${event.orderItem.toMap()}');
    add(LoadCart());
  }

  void _onSubmitOrder(SubmitOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final cartItems = await _hiveService.getCartItems();
      final orderList = OrderList(
        id: 'orderId',
        items: cartItems,
        status: 'pending',
        total: cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity).toInt()),
      );

      await _orderRepository.addOrder(orderList, event.userId);
      await _hiveService.clearCart();
      emit(OrderSubmitted());
    } catch (e) {
      emit(OrderError(error: e.toString()));
    }
  }

  void _onFetchOrders(FetchOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orders = await _orderRepository.fetchOrders(event.userId);
      emit(OrderLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(error: e.toString()));
    }
  }

  void _onLoadCart(LoadCart event, Emitter<OrderState> emit) async {
    final cartItems = await _hiveService.getCartItems();
    print('Loaded cart items: ${cartItems.map((item) => item.toMap()).toList()}');
    final total = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity).toInt());
    final orderList = OrderList(id: 'tempOrderId', items: cartItems, status: 'pending', total: total.toDouble());
    emit(CartLoaded(cartItems: orderList));
  }

  void _onRemoveOrderItem(RemoveOrderItem event, Emitter<OrderState> emit) async {
    await _hiveService.removeItemFromCart(event.orderItem);
    add(LoadCart());
  }

  void _onUpdateOrderItemQuantity(UpdateOrderItemQuantity event, Emitter<OrderState> emit) async {
    await _hiveService.updateItemQuantityInCart(event.orderItem, event.quantity);
    add(LoadCart());
  }

  void _onLoadOrdersOnAppStart(LoadOrdersOnAppStart event, Emitter<OrderState> emit) async {
    add(FetchOrders(userId: event.userId));
    add(LoadCart());
  }
}
