import 'package:flutter/material.dart';
import '../../../viewmodels/cart_viewmodel.dart';
import 'cart_item_card.dart';
import 'cart_summary.dart';

class CartContent extends StatelessWidget {
  final CartViewModel cartViewModel;

  const CartContent({
    super.key,
    required this.cartViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartViewModel.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartViewModel.cartItems[index];
                return CartItemCard(
                  cartItem: cartItem,
                  cartViewModel: cartViewModel,
                );
              },
            ),
          ),
          CartSummary(cartViewModel: cartViewModel),
        ],
      ),
    );
  }
}
