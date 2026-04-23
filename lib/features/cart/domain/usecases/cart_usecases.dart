import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class CartUseCases {
  final CartRepository repository;

  CartUseCases(this.repository);

  List<CartItem> getCartItems() => repository.getCartItems();

  void addToCart(CartItem item) {
    final existingItems = repository.getCartItems();
    final index = existingItems.indexWhere((i) => i.id == item.id);
    
    if (index != -1) {
      repository.updateQuantity(item.id, existingItems[index].quantity + 1);
    } else {
      repository.addToCart(item);
    }
  }

  void removeFromCart(int productId) => repository.removeFromCart(productId);

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      repository.removeFromCart(productId);
    } else {
      repository.updateQuantity(productId, quantity);
    }
  }

  void clearCart() => repository.clearCart();

  double calculateTotal() {
    return repository.getCartItems().fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
  
  int getItemCount() {
    return repository.getCartItems().fold(0, (sum, item) => sum + item.quantity);
  }
}
