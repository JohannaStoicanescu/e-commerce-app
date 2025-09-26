import 'package:flutter/material.dart';

class NavigationLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onPressed;

  const NavigationLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onPressed,
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _text(),
                _textButton(),
              ],
            ),
          ),
          Expanded(child: _container()),
        ],
      ),
    );
  }

  Container _container() {
    return Container(
      height: 1,
      color: Colors.black.withValues(alpha: 0.3),
    );
  }

  Text _text() {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black.withOpacity(0.8),
        fontSize: 14,
      ),
    );
  }

  TextButton _textButton() {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
      child: Text(
        linkText,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
          decorationColor: Colors.black,
        ),
      ),
    );
  }
}
