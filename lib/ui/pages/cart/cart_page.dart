import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/services/auth_service.dart';
import '../_global_widgets/drawer.dart';
import '../_global_widgets/app_bar.dart';
import '../../viewmodels/cart_viewmodel.dart';
import 'widgets/index.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteAppBar(
        title: '🛒 Panier',
        hasDrawer: true,
      ),
      drawer: const AppDrawer(),
      body: Consumer2<CartViewModel, AuthService>(
        builder: (context, cartViewModel, authService, child) {
          if (!authService.isLoggedIn) {
            return _notLoggedIn();
          }

          return _body(cartViewModel);
        },
      ),
    );
  }

  Widget _notLoggedIn() {
    return const CartNotLoggedIn();
  }

  Widget _body(CartViewModel cartViewModel) {
    if (cartViewModel.isLoading) {
      return const CartLoading();
    }

    if (cartViewModel.cartItems.isEmpty) {
      return const EmptyCart();
    }

    return CartContent(cartViewModel: cartViewModel);
  }
}
