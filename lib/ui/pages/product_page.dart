import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import 'catalog_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails du produit')),
      drawer: const AppDrawer(),
      body: Center(
        child: Text('Produit : ${widget.product.name}\n'
            'Prix : ${widget.product.price.toStringAsFixed(2)} €\n'
            'Desc : ${widget.product.description}'),
      ),
    );
  }
}
