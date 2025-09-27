import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderService {
  static const String _ordersKey = 'user_orders';
  static OrderService? _instance;

  List<Order> _memoryOrders = [];

  OrderService._();

  static OrderService get instance => _instance ??= OrderService._();

  Future<List<Order>> getUserOrders() async {
    try {
      if (kIsWeb) {
        try {
          final prefs = await SharedPreferences.getInstance();
          final ordersJson = prefs.getString(_ordersKey);

          if (ordersJson != null) {
            final List<dynamic> ordersList = jsonDecode(ordersJson);
            _memoryOrders =
                ordersList.map((item) => Order.fromJson(item)).toList();
          }
        } catch (e) {
          debugPrint(
              'SharedPreferences not available on web, using memory storage');
        }
        return List.from(_memoryOrders);
      } else {
        final prefs = await SharedPreferences.getInstance();
        final ordersJson = prefs.getString(_ordersKey);

        if (ordersJson == null) return [];

        final List<dynamic> ordersList = jsonDecode(ordersJson);
        return ordersList.map((item) => Order.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error getting user orders: $e');
      return [];
    }
  }

  Future<void> saveOrders(List<Order> orders) async {
    try {
      if (kIsWeb) {
        _memoryOrders = List.from(orders);
        try {
          final prefs = await SharedPreferences.getInstance();
          final ordersJson =
              jsonEncode(orders.map((order) => order.toJson()).toList());
          await prefs.setString(_ordersKey, ordersJson);
        } catch (e) {
          debugPrint(
              'SharedPreferences not available on web, using memory storage only');
        }
      } else {
        final prefs = await SharedPreferences.getInstance();
        final ordersJson =
            jsonEncode(orders.map((order) => order.toJson()).toList());
        await prefs.setString(_ordersKey, ordersJson);
      }
    } catch (e) {
      debugPrint('Error saving orders: $e');
    }
  }

  Future<Order> createOrder({
    required List<CartItem> cartItems,
    required ShippingAddress shippingAddress,
    String? paymentIntentId,
  }) async {
    try {
      final orderId = const Uuid().v4();
      final total =
          cartItems.fold<double>(0, (sum, item) => sum + item.totalPrice);

      final order = Order(
        id: orderId,
        items: List.from(cartItems),
        total: total,
        createdAt: DateTime.now(),
        status: OrderStatus.pending,
        paymentIntentId: paymentIntentId,
        shippingAddress: shippingAddress,
      );

      final orders = await getUserOrders();
      orders.insert(0, order);
      await saveOrders(orders);

      return order;
    } catch (e) {
      debugPrint('Error creating order: $e');
      throw Exception('Failed to create order');
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      final orders = await getUserOrders();
      final orderIndex = orders.indexWhere((order) => order.id == orderId);

      if (orderIndex != -1) {
        final updatedOrder = Order(
          id: orders[orderIndex].id,
          items: orders[orderIndex].items,
          total: orders[orderIndex].total,
          createdAt: orders[orderIndex].createdAt,
          status: status,
          paymentIntentId: orders[orderIndex].paymentIntentId,
          shippingAddress: orders[orderIndex].shippingAddress,
        );

        orders[orderIndex] = updatedOrder;
        await saveOrders(orders);
      }
    } catch (e) {
      debugPrint('Error updating order status: $e');
    }
  }

  Future<Order?> getOrderById(String orderId) async {
    try {
      final orders = await getUserOrders();
      return orders.firstWhere(
        (order) => order.id == orderId,
        orElse: () => throw StateError('Order not found'),
      );
    } catch (e) {
      debugPrint('Error getting order by ID: $e');
      return null;
    }
  }
}
