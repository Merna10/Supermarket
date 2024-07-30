import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:market/modules/cart/data/models/cart_item_model.dart';

class HiveService {
  Future<void> initHive() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(OrderItemAdapter());
    print('Hive initialized at path: ${appDocumentDir.path}');
  }

  Future<void> addItemToCart(OrderItem orderItem) async {
    var box = await Hive.openBox<OrderItem>('cart');
    final existingItemIndex = box.values.toList().indexWhere(
          (item) => item.productId == orderItem.productId,
        );

    if (existingItemIndex != -1) {
      final existingItem = box.getAt(existingItemIndex) as OrderItem;
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + orderItem.quantity,
      );
      await box.putAt(existingItemIndex, updatedItem);
      print('Updated item in cart: ${updatedItem.toMap()}');
    } else {
      await box.add(orderItem);
      print('Added new item to cart: ${orderItem.toMap()}');
    }
  }

  Future<void> removeItemFromCart(OrderItem orderItem) async {
    var box = await Hive.openBox<OrderItem>('cart');
    final existingItemIndex = box.values.toList().indexWhere(
          (item) => item.productId == orderItem.productId,
        );

    if (existingItemIndex != -1) {
      await box.deleteAt(existingItemIndex);
      print('Removed item from cart: ${orderItem.toMap()}');
    }
  }

  Future<void> updateItemQuantityInCart(OrderItem orderItem, int quantity) async {
    var box = await Hive.openBox<OrderItem>('cart');
    final existingItemIndex = box.values.toList().indexWhere(
          (item) => item.productId == orderItem.productId,
        );

    if (existingItemIndex != -1) {
      final existingItem = box.getAt(existingItemIndex) as OrderItem;
      final updatedItem = existingItem.copyWith(quantity: quantity);
      await box.putAt(existingItemIndex, updatedItem);
      print('Updated item quantity in cart: ${updatedItem.toMap()}');
    }
  }

  Future<List<OrderItem>> getCartItems() async {
    var box = await Hive.openBox<OrderItem>('cart');
    print('Retrieved cart items: ${box.values.toList()}');
    return box.values.toList();
  }

  Future<void> clearCart() async {
    var box = await Hive.openBox<OrderItem>('cart');
    await box.clear();
    print('Cleared cart');
  }
}
