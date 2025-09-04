import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panier')),
      drawer: const AppDrawer(),
      body: const Center(child: Text('TODO: Contenu de la page de panier')),
    );
  }
}
