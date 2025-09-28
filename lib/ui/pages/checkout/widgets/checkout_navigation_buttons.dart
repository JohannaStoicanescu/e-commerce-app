import 'package:flutter/material.dart';

class CheckoutNavigationButtons extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final String? nextLabel;
  final bool showBack;

  const CheckoutNavigationButtons({
    super.key,
    this.onBack,
    this.onNext,
    this.nextLabel,
    this.showBack = true,
  });

  @override
  Row build(BuildContext context) {
    return Row(
      children: [
        if (showBack && onBack != null)
          Expanded(
            child: OutlinedButton(
              onPressed: onBack,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF667EEA),
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFF667EEA)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Précédent',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        if (showBack && onBack != null) const SizedBox(width: 16),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 147, 169, 255),
                  Color.fromARGB(255, 75, 110, 248)
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
              ),
              child: Text(
                nextLabel ?? 'Suivant',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}