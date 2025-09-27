import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../../data/services/auth_service.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartViewModel, AuthService>(
      builder: (context, cartViewModel, authService, child) {
        if (!authService.isLoggedIn) {
          return const SizedBox.shrink();
        }

        return Stack(
          children: [
            _iconButton(context),
            if (cartViewModel.itemCount > 0)
              _quantitySelector(cartViewModel, cartViewModel.itemCount),
          ],
        );
      },
    );
  }

  IconButton _iconButton(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.shopping_cart_rounded,
        color: Colors.white,
        size: 24,
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/cart');
      },
    );
  }

  Positioned _quantitySelector(
    CartViewModel cartViewModel,
    cartItem,
  ) {
    return Positioned(
      right: 6,
      top: 6,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: _boxDecoration(),
        constraints: _boxConstraints(),
        child: _text(cartViewModel.itemCount),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: const Color(0xFFFF6B35),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  BoxConstraints _boxConstraints() {
    return const BoxConstraints(
      minWidth: 18,
      minHeight: 18,
    );
  }

  Text _text(int itemCount) {
    return Text(
      '$itemCount',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}
