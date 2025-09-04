import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import 'product_page.dart';

class Product {
  final String name;
  final String description;
  final double price;

  Product({
    required this.name,
    required this.description,
    required this.price,
  });
}

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {

  final products = List.generate(
    20,
    (index) => Product(
      name: 'Produit $index',
      description: 'Description du produit $index',
      price: (index + 1) * 10.0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catalogue')),
      drawer: const AppDrawer(),
      body: Center(
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(products[index].name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => ProductPage(product: products[index]),
                  ),
                );
              },
            );
          },
        ),
      )
    );
  }
}
