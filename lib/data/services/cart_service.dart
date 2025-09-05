import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartService {
  static const String _cartKey = 'cart_items';
  static CartService? _instance;
  
  // In-memory storage for web fallback
  List<CartItem> _memoryCart = [];
  
  CartService._();
  
  static CartService get instance => _instance ??= CartService._();

  Future<List<CartItem>> getCartItems() async {
    try {
      if (kIsWeb) {
        // For web, try SharedPreferences but fallback to memory if it fails
        try {
          final prefs = await SharedPreferences.getInstance();
          final cartJson = prefs.getString(_cartKey);
          
          if (cartJson != null) {
            final List<dynamic> cartList = jsonDecode(cartJson);
            _memoryCart = cartList.map((item) => CartItem.fromJson(item)).toList();
          }
        } catch (e) {
          debugPrint('SharedPreferences not available on web, using memory storage');
        }
        return List.from(_memoryCart);
      } else {
        // For mobile platforms
        final prefs = await SharedPreferences.getInstance();
        final cartJson = prefs.getString(_cartKey);
        
        if (cartJson == null) return [];
        
        final List<dynamic> cartList = jsonDecode(cartJson);
        return cartList.map((item) => CartItem.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error getting cart items: $e');
      return [];
    }
  }

  Future<void> saveCartItems(List<CartItem> cartItems) async {
    try {
      if (kIsWeb) {
        // For web, save to memory and try SharedPreferences
        _memoryCart = List.from(cartItems);
        try {
          final prefs = await SharedPreferences.getInstance();
          final cartJson = jsonEncode(cartItems.map((item) => item.toJson()).toList());
          await prefs.setString(_cartKey, cartJson);
        } catch (e) {
          debugPrint('SharedPreferences not available on web, using memory storage only');
        }
      } else {
        // For mobile platforms
        final prefs = await SharedPreferences.getInstance();
        final cartJson = jsonEncode(cartItems.map((item) => item.toJson()).toList());
        await prefs.setString(_cartKey, cartJson);
      }
    } catch (e) {
      debugPrint('Error saving cart items: $e');
    }
  }

  Future<void> addToCart(Product product) async {
    try {
      final cartItems = await getCartItems();
      
      // Check if product already exists in cart
      final existingItemIndex = cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );
      
      if (existingItemIndex != -1) {
        // If product exists, increase quantity
        cartItems[existingItemIndex].quantity++;
      } else {
        // If product doesn't exist, add new item
        cartItems.add(CartItem(product: product));
      }
      
      await saveCartItems(cartItems);
    } catch (e) {
      debugPrint('Error adding to cart: $e');
    }
  }

  Future<void> removeFromCart(int productId) async {
    try {
      final cartItems = await getCartItems();
      cartItems.removeWhere((item) => item.product.id == productId);
      await saveCartItems(cartItems);
    } catch (e) {
      debugPrint('Error removing from cart: $e');
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    try {
      final cartItems = await getCartItems();
      final itemIndex = cartItems.indexWhere(
        (item) => item.product.id == productId,
      );
      
      if (itemIndex != -1) {
        if (quantity <= 0) {
          cartItems.removeAt(itemIndex);
        } else {
          cartItems[itemIndex].quantity = quantity;
        }
        await saveCartItems(cartItems);
      }
    } catch (e) {
      debugPrint('Error updating quantity: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      if (kIsWeb) {
        _memoryCart.clear();
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove(_cartKey);
        } catch (e) {
          debugPrint('SharedPreferences not available on web');
        }
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_cartKey);
      }
    } catch (e) {
      debugPrint('Error clearing cart: $e');
    }
  }

  Future<int> getCartItemCount() async {
    try {
      final cartItems = await getCartItems();
      return cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
    } catch (e) {
      debugPrint('Error getting cart item count: $e');
      return 0;
    }
  }

  Future<double> getCartTotal() async {
    try {
      final cartItems = await getCartItems();
      return cartItems.fold<double>(0, (sum, item) => sum + item.totalPrice);
    } catch (e) {
      debugPrint('Error getting cart total: $e');
      return 0.0;
    }
  }
}
