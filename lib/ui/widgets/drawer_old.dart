import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../data/services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _goRouter(BuildContext context, String route) {
    Navigator.pop(context);
    final current = ModalRoute.of(context)?.settings.name;
    if (current == route) return;
    Navigator.pushReplacementNamed(context, route);
  }

  Future<void> _signOut(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.signOut();

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Déconnecté avec succès')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser;
        
        return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Menu principal',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                const SizedBox(height: 10),
                if (user != null) ...[
                  const Icon(Icons.account_circle,
                      color: Colors.white, size: 40),
                  const SizedBox(height: 5),
                  Text(
                    user.email ?? 'Utilisateur connecté',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ] else
                  const Text(
                    'Non connecté',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Accueil'),
            onTap: () => _goRouter(context, '/'),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Catalogue'),
            onTap: () => _goRouter(context, '/products'),
          ),
          if (user == null) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.login, color: Colors.green),
              title: const Text('Se connecter'),
              onTap: () => _goRouter(context, '/login'),
            ),
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.blue),
              title: const Text('S\'inscrire'),
              onTap: () => _goRouter(context, '/register'),
            ),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Panier'),
              onTap: () => _goRouter(context, '/cart'),
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Historique des commandes'),
              onTap: () => _goRouter(context, '/orders'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Se déconnecter'),
              onTap: () => _signOut(context),
            ),
          ],
        ),
      );
      },
    );
  }
}
