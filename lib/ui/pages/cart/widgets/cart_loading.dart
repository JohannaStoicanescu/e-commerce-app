import 'package:flutter/material.dart';

class CartLoading extends StatelessWidget {
  const CartLoading({super.key});

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
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
              strokeWidth: 3,
            ),
            SizedBox(height: 24),
            Text(
              'Chargement du panier...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6C757D),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
