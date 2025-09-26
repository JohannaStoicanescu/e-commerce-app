import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../data/models/product.dart';
import '../../../data/services/platform_service.dart';
import '../../viewmodels/cart_viewmodel.dart';

class PlatformProductDetailPage extends StatefulWidget {
  final Product product;

  const PlatformProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<PlatformProductDetailPage> createState() =>
      _PlatformProductDetailPageState();
}

class _PlatformProductDetailPageState extends State<PlatformProductDetailPage> {
  final PlatformService _platformService = PlatformService.instance;

  Future<void> _shareProduct() async {
    await _platformService.shareProduct(
      productName: widget.product.title,
      productDescription: widget.product.description,
      price: widget.product.price,
      imageUrl: widget.product.image,
    );
  }

  void _addToCart() {
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    cartViewModel.addToCart(widget.product);

    const message = 'Produit ajouté au panier !';

    if (_platformService.shouldUseCupertinoStyle()) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Succès'),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_platformService.shouldUseCupertinoStyle()) {
      return _buildCupertinoStyle();
    } else {
      return _buildMaterialStyle();
    }
  }

  Widget _buildCupertinoStyle() {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          widget.product.title,
          style: const TextStyle(fontSize: 17),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _shareProduct,
          child: const Icon(CupertinoIcons.share),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: _platformService.getPlatformPadding(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(),
              const SizedBox(height: 16),
              _buildProductInfo(),
              const SizedBox(height: 24),
              _buildCupertinoAddButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialStyle() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareProduct,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: _platformService.getPlatformPadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            const SizedBox(height: 16),
            _buildProductInfo(),
            const SizedBox(height: 24),
            _buildMaterialAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: widget.product.image,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.image_not_supported,
              size: 64,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.title,
          style: _platformService.shouldUseCupertinoStyle()
              ? const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                )
              : Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
        ),
        const SizedBox(height: 8),
        Text(
          '${widget.product.price.toStringAsFixed(2)} €',
          style: _platformService.shouldUseCupertinoStyle()
              ? TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.systemBlue,
                )
              : Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
        ),
        const SizedBox(height: 16),
        Text(
          'Description',
          style: _platformService.shouldUseCupertinoStyle()
              ? const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )
              : Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.product.description,
          style: _platformService.shouldUseCupertinoStyle()
              ? const TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.secondaryLabel,
                )
              : Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildCupertinoAddButton() {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton.filled(
        onPressed: _addToCart,
        child: const Text(
          'Ajouter au panier',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialAddButton() {
    return SizedBox(
      width: double.infinity,
      height: _platformService.getPlatformButtonHeight(),
      child: ElevatedButton.icon(
        onPressed: _addToCart,
        icon: const Icon(Icons.shopping_cart_outlined),
        label: const Text(
          'Ajouter au panier',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
