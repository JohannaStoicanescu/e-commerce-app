import 'package:flutter/foundation.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/order.dart';
import '../../data/services/payment_service.dart';
import '../../data/services/order_service.dart';

class CheckoutViewModel extends ChangeNotifier {
  final PaymentService _paymentService = PaymentService.instance;
  final OrderService _orderService = OrderService.instance;

  bool _isProcessing = false;
  String? _errorMessage;
  Order? _completedOrder;

  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;
  Order? get completedOrder => _completedOrder;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearCompletedOrder() {
    _completedOrder = null;
    notifyListeners();
  }

  Future<bool> processCheckout({
    required List<CartItem> cartItems,
    required ShippingAddress shippingAddress,
    required BillingDetails billingDetails,
    String? cardNumber,
    Function? onClearCart,
  }) async {
    try {
      _setProcessing(true);
      _clearError();

      // Simulate payment processing
      final paymentResult = await _paymentService.mockPaymentFlow(
        cartItems: cartItems,
        shippingAddress: shippingAddress,
        billingDetails: billingDetails,
        cardNumber: cardNumber,
      );

      if (paymentResult.status == PaymentStatus.succeeded) {
        // Create order
        final order = await _orderService.createOrder(
          cartItems: cartItems,
          shippingAddress: shippingAddress,
          paymentIntentId: paymentResult.paymentIntentId,
        );

        // Update order status to processing
        await _orderService.updateOrderStatus(order.id, OrderStatus.processing);

        // Clear the cart after successful order
        if (onClearCart != null) {
          await onClearCart();
        }

        _completedOrder = order;
        _setProcessing(false);
        return true;
      } else {
        _setError(paymentResult.error ?? 'Erreur lors du paiement');
        _setProcessing(false);
        return false;
      }
    } catch (e) {
      _setError('Erreur lors du traitement de la commande: ${e.toString()}');
      _setProcessing(false);
      return false;
    }
  }

  void _setProcessing(bool processing) {
    _isProcessing = processing;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
