import 'package:flutter/material.dart';

class RegisterErrorMessage extends StatelessWidget {
  final String message;

  const RegisterErrorMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: _boxDecoration(),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: _childrenBoxDecoration(),
                child: _icon(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _text(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0xFFDC3545).withValues(alpha: 0.3),
        width: 1.5,
      ),
    );
  }

  BoxDecoration _childrenBoxDecoration() {
    return BoxDecoration(
      color: const Color(0xFFDC3545).withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _icon() {
    return const Icon(
      Icons.error_outline_rounded,
      color: Color(0xFFDC3545),
      size: 20,
    );
  }

  Widget _text() {
    return Text(
      message,
      style: const TextStyle(
        color: Color(0xFFDC3545),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
    );
  }
}
