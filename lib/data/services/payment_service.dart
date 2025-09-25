import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class PaymentService {
  static PaymentService? _instance;
  PaymentService._();

  static PaymentService get instance => _instance ??= PaymentService._();

  // Test publishable key - replace with your actual test key in production
  static const String _publishableKey =
      'pk_test_51HvjKdLCnwSKD...'; // Add your test key here

  static void init() {
    // Stripe initialization - disabled for web compatibility
    // On web, we'll use the mock implementation only
    if (!kIsWeb) {
      try {
        Stripe.publishableKey = _publishableKey;
        debugPrint('Stripe initialized for mobile platforms');
      } catch (e) {
        debugPrint('Stripe initialization failed: $e');
      }
    } else {
      debugPrint('Running on web - using mock payment only');
    }
  }

  Future<String> createPaymentIntent({
    required double amount,
    required String currency,
    required String description,
  }) async {
    try {
      // Mock implementation for demo purposes
      debugPrint('Mock payment intent creation for $amount $currency');
      await Future.delayed(const Duration(milliseconds: 300));
      return 'pi_mock_${DateTime.now().millisecondsSinceEpoch}_secret_${amount.toInt()}';
    } catch (e) {
      debugPrint('Error in createPaymentIntent: $e');
      throw Exception('Payment service error: $e');
    }
  }

  Future<PaymentResult> processPayment({
    required String clientSecret,
    required BillingDetails billingDetails,
    String? cardNumber,
  }) async {
    try {
      // For demo purposes, we'll simulate a successful payment
      // In a real app, you would use Stripe.instance.confirmPayment

      await Future.delayed(
          const Duration(seconds: 2)); // Simulate processing time

      // Validate French test cards (always succeed for valid test numbers)
      if (cardNumber != null) {
        final cleanNumber = cardNumber.replaceAll(RegExp(r'\s'), '');

        // French test card numbers that always succeed
        final validFrenchCards = [
          '4000000000000002', // Visa France
          '4000000760000002', // Visa France with 3D Secure
          '5555555555554444', // Mastercard
          '4242424242424242', // Test card
        ];

        if (validFrenchCards.contains(cleanNumber)) {
          return PaymentResult(
            status: PaymentStatus.succeeded,
            paymentIntentId:
                'pi_french_${DateTime.now().millisecondsSinceEpoch}',
          );
        }

        // Invalid card numbers
        final invalidCards = [
          '4000000000000127', // Generic decline
          '4000000000000069', // Expired card
        ];

        if (invalidCards.contains(cleanNumber)) {
          return PaymentResult(
            status: PaymentStatus.failed,
            error:
                'Votre carte a été refusée. Veuillez vérifier vos informations.',
          );
        }
      }

      // For any other card number, simulate 90% success rate
      final isSuccess = DateTime.now().millisecond % 10 != 0;

      if (isSuccess) {
        return PaymentResult(
          status: PaymentStatus.succeeded,
          paymentIntentId: 'pi_mock_${DateTime.now().millisecondsSinceEpoch}',
        );
      } else {
        return PaymentResult(
          status: PaymentStatus.failed,
          error:
              'Votre carte a été refusée. Veuillez essayer avec une autre carte.',
        );
      }
    } catch (e) {
      debugPrint('Error processing payment: $e');
      return PaymentResult(
        status: PaymentStatus.failed,
        error: 'Erreur lors du traitement du paiement: ${e.toString()}',
      );
    }
  }

  Future<PaymentResult> mockPaymentFlow({
    required List<CartItem> cartItems,
    required ShippingAddress shippingAddress,
    required BillingDetails billingDetails,
    String? cardNumber,
  }) async {
    try {
      // Create payment intent (mock)
      await Future.delayed(const Duration(milliseconds: 500));

      final clientSecret =
          'pi_mock_${DateTime.now().millisecondsSinceEpoch}_secret';

      // Process payment (mock)
      final result = await processPayment(
        clientSecret: clientSecret,
        billingDetails: billingDetails,
        cardNumber: cardNumber,
      );

      return result;
    } catch (e) {
      return PaymentResult(
        status: PaymentStatus.failed,
        error: 'Erreur lors du paiement: ${e.toString()}',
      );
    }
  }
}

enum PaymentStatus {
  succeeded,
  failed,
  canceled,
}

class PaymentResult {
  final PaymentStatus status;
  final String? paymentIntentId;
  final String? error;

  PaymentResult({
    required this.status,
    this.paymentIntentId,
    this.error,
  });
}

class BillingDetails {
  final String name;
  final String email;
  final String? phone;
  final Address? address;

  BillingDetails({
    required this.name,
    required this.email,
    this.phone,
    this.address,
  });
}

class Address {
  final String? line1;
  final String? line2;
  final String? city;
  final String? postalCode;
  final String? country;

  Address({
    this.line1,
    this.line2,
    this.city,
    this.postalCode,
    this.country,
  });
}
