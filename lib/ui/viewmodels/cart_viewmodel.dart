import 'package:flutter/foundation.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/product.dart';
import '../../data/services/cart_service.dart';

class CartViewModel extends ChangeNotifier {
  final CartService _cartService = CartService.instance;

  List<CartItem> _cartItems = [];
  bool _isLoading = false;

  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  int get itemCount =>
      _cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
  double get total =>
      _cartItems.fold<double>(0, (sum, item) => sum + item.totalPrice);
  String get formattedTotal => '${total.toStringAsFixed(2)} €';

  CartViewModel() {
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    _setLoading(true);
    try {
      _cartItems = await _cartService.getCartItems();
      debugPrint('Loaded ${_cartItems.length} items from cart');
    } catch (error) {
      debugPrint('Error loading cart items: $error');
      _cartItems = [];
    }
    _setLoading(false);
  }

  Future<void> addToCart(Product product) async {
    try {
      await _cartService.addToCart(product);
      await loadCartItems();
      debugPrint('Added ${product.title} to cart');
    } catch (error) {
      debugPrint('Error adding to cart: $error');
    }
  }

  Future<void> removeFromCart(int productId) async {
    try {
      await _cartService.removeFromCart(productId);
      await loadCartItems();
    } catch (error) {
      debugPrint('Error removing from cart: $error');
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    try {
      await _cartService.updateQuantity(productId, quantity);
      await loadCartItems();
    } catch (error) {
      debugPrint('Error updating quantity: $error');
    }
  }

  Future<void> clearCart() async {
    try {
      await _cartService.clearCart();
      await loadCartItems();
    } catch (error) {
      debugPrint('Error clearing cart: $error');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
