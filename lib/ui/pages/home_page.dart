import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../widgets/cart_icon.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application E Commerce'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: const [CartIcon()],
      ),
      drawer: const AppDrawer(),
      body: const Center(child: Text('TODO: Contenu de la page d\'accueil')),
    );
  }
}
