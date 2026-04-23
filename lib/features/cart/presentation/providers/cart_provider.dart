import 'package:flutter/material.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/cart_usecases.dart';
import '../../data/repositories/cart_repository_impl.dart';

class CartProvider extends ChangeNotifier {
  // Simple DI for this example, but structured to follow the flow
  late final CartUseCases _useCases;

  CartProvider() {
    _useCases = CartUseCases(CartRepositoryImpl());
  }

  List<CartItem> get items => _useCases.getCartItems();
  double get totalPrice => _useCases.calculateTotal();
  int get itemCount => _useCases.getItemCount();

  void addItem(CartItem item) {
    _useCases.addToCart(item);
    notifyListeners();
  }

  void removeItem(int productId) {
    _useCases.removeFromCart(productId);
    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    _useCases.updateQuantity(productId, quantity);
    notifyListeners();
  }

  void clear() {
    _useCases.clearCart();
    notifyListeners();
  }
}
