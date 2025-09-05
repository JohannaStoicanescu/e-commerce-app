import 'package:flutter/foundation.dart';
import '../../data/models/product.dart';
import '../../data/services/fakestore_api.dart';

class ProductsViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _products = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;

  ProductsViewModel() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    if (_isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      _products = await _apiService.fetchProducts();
    } catch (error) {
      _setError('Impossible de charger les produits');
    }

    _setLoading(false);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
