import 'package:flutter/material.dart';
import '../_global_widgets/drawer.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paiement')),
      drawer: const AppDrawer(),
      body: const Center(child: Text('TODO: Contenu de la page de paiement')),
    );
  }
}
