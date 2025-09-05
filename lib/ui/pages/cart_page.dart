import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/drawer.dart';
import '../widgets/cart_icon.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../../data/models/cart_item.dart';
import '../../data/services/auth_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: const [CartIcon()],
      ),
      drawer: const AppDrawer(),
      body: Consumer2<CartViewModel, AuthService>(
        builder: (context, cartViewModel, authService, child) {
          // Check if user is logged in
          if (!authService.isLoggedIn) {
            return _buildNotLoggedIn();
          }
          
          return _buildBody(cartViewModel);
        },
      ),
    );
  }

  Widget _buildNotLoggedIn() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.login, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Connexion requise',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vous devez être connecté pour accéder à votre panier',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              icon: const Icon(Icons.login),
              label: const Text('Se connecter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(CartViewModel cartViewModel) {
    if (cartViewModel.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Chargement du panier...'),
          ],
        ),
      );
    }

    if (cartViewModel.cartItems.isEmpty) {
      return _buildEmptyCart();
    }

    return _buildCartContent(cartViewModel);
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Votre panier est vide',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Ajoutez des produits pour les voir ici',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(CartViewModel cartViewModel) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cartViewModel.cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = cartViewModel.cartItems[index];
              return _buildCartItemCard(cartItem, cartViewModel);
            },
          ),
        ),
        _buildCartSummary(cartViewModel),
      ],
    );
  }

  Widget _buildCartItemCard(CartItem cartItem, CartViewModel cartViewModel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildProductImage(cartItem.product.image),
            const SizedBox(width: 12),
            Expanded(child: _buildProductInfo(cartItem)),
            const SizedBox(width: 12),
            _buildQuantityControls(cartItem, cartViewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 60,
          height: 60,
          color: Colors.grey[200],
          child: const Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildProductInfo(CartItem cartItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cartItem.product.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          cartItem.product.formattedPrice,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.green,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Total: ${cartItem.totalPrice.toStringAsFixed(2)} €',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityControls(CartItem cartItem, CartViewModel cartViewModel) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.remove, size: 16),
                onPressed: () async {
                  if (cartItem.quantity > 1) {
                    await cartViewModel.updateQuantity(
                      cartItem.product.id,
                      cartItem.quantity - 1,
                    );
                  } else {
                    await cartViewModel.removeFromCart(cartItem.product.id);
                  }
                },
              ),
            ),
            Container(
              width: 40,
              height: 32,
              alignment: Alignment.center,
              child: Text(
                '${cartItem.quantity}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.add, size: 16),
                onPressed: () async {
                  await cartViewModel.updateQuantity(
                    cartItem.product.id,
                    cartItem.quantity + 1,
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () async {
            await cartViewModel.removeFromCart(cartItem.product.id);
          },
          child: const Text(
            'Supprimer',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCartSummary(CartViewModel cartViewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Articles (${cartViewModel.itemCount})',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                cartViewModel.formattedTotal,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await cartViewModel.clearCart();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Panier vidé'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Vider le panier'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement checkout
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fonctionnalité de commande à venir'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Commander'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
