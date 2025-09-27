import 'package:flutter/foundation.dart';
import '../../data/models/order.dart';
import '../../data/services/order_service.dart';

class OrdersViewModel extends ChangeNotifier {
  final OrderService _orderService = OrderService.instance;

  List<Order> _orders = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  bool get hasOrders => _orders.isNotEmpty;

  OrdersViewModel() {
    loadOrders();
  }

  Future<void> loadOrders() async {
    _setLoading(true);
    _clearError();

    try {
      _orders = await _orderService.getUserOrders();
    } catch (error) {
      _setError('Impossible de charger les commandes: ${error.toString()}');
    }

    _setLoading(false);
  }

  Future<void> refreshOrders() async {
    await loadOrders();
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  List<Order> getOrdersByStatus(OrderStatus status) {
    return _orders.where((order) => order.status == status).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
