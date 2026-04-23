import '../entities/cart_item.dart';

abstract class CartRepository {
  List<CartItem> getCartItems();
  void addToCart(CartItem item);
  void removeFromCart(int productId);
  void updateQuantity(int productId, int quantity);
  void clearCart();
}
