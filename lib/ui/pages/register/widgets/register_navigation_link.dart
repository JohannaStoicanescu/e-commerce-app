import 'package:flutter/material.dart';

class RegisterNavigationLink extends StatelessWidget {
  final bool isLoading;

  const RegisterNavigationLink({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _container()),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _button(context)),
          Expanded(child: _container()),
        ],
      ),
    );
  }

  Widget _container() {
    return Container(
      height: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget _text() {
    return const Text(
      'Déjà un compte ? Se connecter',
      style: TextStyle(
        fontSize: 14,
        color: Colors.black54,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
        decorationColor: Colors.black54,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _button(BuildContext context) {
    return TextButton(
        onPressed: !isLoading
            ? () => Navigator.pushReplacementNamed(context, '/login')
            : null,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        child: _text());
  }
}
