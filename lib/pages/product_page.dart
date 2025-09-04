import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import 'catalog_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, this.product});

  final Product? product;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails du produit')),
      drawer: const AppDrawer(),
      body: const Center(child: Text('TODO: Contenu de la page de produit')),
    );
  }
}
