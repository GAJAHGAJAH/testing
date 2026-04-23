import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final List<CartItem> _items = [];

  @override
  List<CartItem> getCartItems() => List.unmodifiable(_items);

  @override
  void addToCart(CartItem item) {
    _items.add(item);
  }

  @override
  void removeFromCart(int productId) {
    _items.removeWhere((item) => item.id == productId);
  }

  @override
  void updateQuantity(int productId, int quantity) {
    final index = _items.indexWhere((item) => item.id == productId);
    if (index != -1) {
      _items[index] = _items[index].copyWith(quantity: quantity);
    }
  }

  @override
  void clearCart() {
    _items.clear();
  }
}
