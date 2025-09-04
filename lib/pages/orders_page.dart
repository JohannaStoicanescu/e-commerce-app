import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique des commandes')),
      drawer: const AppDrawer(),
      body: const Center(child: Text('TODO: Contenu de la page d\'historique des commandes')),
    );
  }
}
