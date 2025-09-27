import 'package:flutter/material.dart';

class SizedBox extends StatelessWidget {
  final double height;

  const SizedBox({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
