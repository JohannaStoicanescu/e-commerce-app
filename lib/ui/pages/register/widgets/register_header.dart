import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _boxDecoration(),
          child: _icon(),
        ),
        const SizedBox(height: 15),
        _text(),
        const SizedBox(height: 10),
      ],
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: const Color(0xFF28A745),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.7),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  Icon _icon() {
    return const Icon(
      Icons.person_add_rounded,
      size: 50,
      color: Color(0xFF28A745),
    );
  }

  Text _text() {
    return const Text(
      'Créer un compte',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2C3E50),
      ),
    );
  }
}
