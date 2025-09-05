import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodels/products_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../widgets/drawer.dart';
import '../widgets/cart_icon.dart';
import '../../data/models/product.dart';
import '../../data/services/auth_service.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Toutes';
  double _minPrice = 0;
  double _maxPrice = 1000;
  double _minRating = 0;
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produits'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          const CartIcon(),
          Stack(
            children: [
              IconButton(
                icon: Icon(
                    _showFilters ? Icons.filter_list_off : Icons.filter_list),
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
              ),
              if (_hasActiveFilters())
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Consumer<ProductsViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              _buildSearchBar(),
              if (_showFilters) _buildFilters(viewModel),
              Expanded(child: _buildBody(viewModel)),
            ],
          );
        },
      ),
    );
  }

  bool _hasActiveFilters() {
    return _searchQuery.isNotEmpty ||
        _selectedCategory != 'Toutes' ||
        _minPrice > 0 ||
        _maxPrice < 1000 ||
        _minRating > 0;
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCategory = 'Toutes';
      _minPrice = 0;
      _maxPrice = 1000;
      _minRating = 0;
    });
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher un produit...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildFilters(ProductsViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtres',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (_hasActiveFilters())
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text('Tout effacer'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _buildCategoryFilter(viewModel),
          const SizedBox(height: 16),
          _buildPriceFilter(),
          const SizedBox(height: 16),
          _buildRatingFilter(),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(ProductsViewModel viewModel) {
    final categories = [
      'Toutes',
      ...viewModel.products.map((p) => p.category).toSet()
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catégorie',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: categories.map((category) {
            return FilterChip(
              label: Text(category),
              selected: _selectedCategory == category,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prix',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: RangeValues(_minPrice, _maxPrice),
          min: 0,
          max: 1000,
          divisions: 20,
          labels: RangeLabels(
            '${_minPrice.round()}€',
            '${_maxPrice.round()}€',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _minPrice = values.start;
              _maxPrice = values.end;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${_minPrice.round()}€'),
            Text('${_maxPrice.round()}€'),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Note minimum',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Slider(
          value: _minRating,
          min: 0,
          max: 5,
          divisions: 10,
          label: '${_minRating.toStringAsFixed(1)} ⭐',
          onChanged: (value) {
            setState(() {
              _minRating = value;
            });
          },
        ),
        Text('${_minRating.toStringAsFixed(1)} ⭐ et plus'),
      ],
    );
  }

  Widget _buildBody(ProductsViewModel viewModel) {
    if (viewModel.isLoading) {
      return _buildLoadingState();
    }

    if (viewModel.hasError) {
      return _buildErrorState(viewModel);
    }

    return _buildSuccessState(viewModel);
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Chargement des produits...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(ProductsViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              viewModel.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: viewModel.loadProducts,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState(ProductsViewModel viewModel) {
    final filteredProducts = _filterProducts(viewModel.products);

    if (filteredProducts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Aucun produit trouvé',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              'Essayez de modifier vos critères de recherche',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  List<Product> _filterProducts(List<Product> products) {
    return products.where((product) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final titleMatch = product.title.toLowerCase().contains(query);
        final categoryMatch = product.category.toLowerCase().contains(query);
        if (!titleMatch && !categoryMatch) return false;
      }

      if (_selectedCategory != 'Toutes' &&
          product.category != _selectedCategory) {
        return false;
      }

      if (product.price < _minPrice || product.price > _maxPrice) {
        return false;
      }

      if (product.rating.rate < _minRating) {
        return false;
      }

      return true;
    }).toList();
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(product.image),
            const SizedBox(width: 16),
            Expanded(child: _buildProductInfo(product)),
            const SizedBox(width: 8),
            _buildAddToCartButton(product),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(Product product) {
    return Consumer2<CartViewModel, AuthService>(
      builder: (context, cartViewModel, authService, child) {
        final isLoggedIn = authService.isLoggedIn;

        return Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: isLoggedIn ? Colors.blue[600] : Colors.grey[400],
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(
              isLoggedIn ? Icons.add_shopping_cart : Icons.login,
              color: Colors.white,
              size: 20,
            ),
            onPressed: isLoggedIn
                ? () async {
                    try {
                      await cartViewModel.addToCart(product);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.title} ajouté au panier'),
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Erreur lors de l\'ajout au panier: $e'),
                            duration: const Duration(seconds: 3),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                : () {
                    _showLoginDialog(context);
                  },
          ),
        );
      },
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connexion requise'),
          content: const Text(
            'Vous devez être connecté pour ajouter des articles au panier.\n\nSouhaitez-vous vous connecter maintenant ?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
              ),
              child: const Text('Se connecter'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 80,
          height: 80,
          color: Colors.grey[200],
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildProductInfo(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            product.category.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.formattedPrice,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          product.starsDisplay,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
