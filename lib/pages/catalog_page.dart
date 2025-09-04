import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catalogue')),
      drawer: const AppDrawer(),
      body: const Center(child: Text('TODO: Contenu de la page de tous les produits')),
    );
  }
}
