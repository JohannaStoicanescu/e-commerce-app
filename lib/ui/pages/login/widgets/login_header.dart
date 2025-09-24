import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _boxDecoration(),
          child: const Icon(
            Icons.login_rounded,
            size: 64,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Bienvenue',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Connectez-vous à votre compte',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6C757D),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
      ),
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF667EEA).withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}
