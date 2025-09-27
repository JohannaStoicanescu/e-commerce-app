import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../data/models/cart_item.dart';
import '../../../viewmodels/cart_viewmodel.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final CartViewModel cartViewModel;

  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.cartViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                _productImage(),
                const SizedBox(width: 16),
                Expanded(child: _productInfo()),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _quantityControls(),
                _removeButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _productImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: cartItem.product.image,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.image_not_supported_rounded,
              color: Color(0xFF6C757D),
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _productInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cartItem.product.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF667EEA).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            cartItem.product.formattedPrice,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF667EEA),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text(
              'Total: ',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6C757D),
              ),
            ),
            Text(
              '${cartItem.totalPrice.toStringAsFixed(2)} €',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _quantityControls() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _quantityButton(
            icon: Icons.remove_rounded,
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
          Container(
            width: 48,
            height: 40,
            alignment: Alignment.center,
            child: Text(
              '${cartItem.quantity}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
          ),
          _quantityButton(
            icon: Icons.add_rounded,
            onPressed: () async {
              await cartViewModel.updateQuantity(
                cartItem.product.id,
                cartItem.quantity + 1,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          size: 18,
          color: const Color(0xFF667EEA),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _removeButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () async {
        await cartViewModel.removeFromCart(cartItem.product.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${cartItem.product.title} supprimé du panier'),
              backgroundColor: const Color(0xFFDC3545),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      icon: const Icon(
        Icons.delete_outline_rounded,
        size: 18,
        color: Color(0xFFDC3545),
      ),
      label: const Text(
        'Supprimer',
        style: TextStyle(
          color: Color(0xFFDC3545),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
