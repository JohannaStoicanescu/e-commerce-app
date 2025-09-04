import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Application E Commerce')),
      drawer: const AppDrawer(),
      body: const Center(child: Text('TODO: Contenu de la page d\'accueil')),
    );
  }
}
