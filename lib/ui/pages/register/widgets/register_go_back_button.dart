import 'package:flutter/material.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: _boxDecoration(),
      child: _iconButton(context),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.3),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.white.withOpacity(0.5),
        width: 2,
      ),
    );
  }

  Widget _iconButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/');
      },
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
