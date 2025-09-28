import 'package:flutter/material.dart';
import '../../../viewmodels/cart_viewmodel.dart';

class CheckoutOrderTotal extends StatelessWidget {
  final CartViewModel cartViewModel;

  const CheckoutOrderTotal({
    super.key,
    required this.cartViewModel,
  });

  @override
  Container build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sous-total:',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                cartViewModel.formattedTotal,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Livraison:',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Gratuite',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF667EEA),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                cartViewModel.formattedTotal,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}