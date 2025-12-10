import 'package:flutter/cupertino.dart';
import '../models/product.model.dart';
import '../services/product.service.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  bool _cargando = false;
  String? _error;

  List<Product> get products => _products;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _productService.fetchProducts();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> fetchProduct(int id) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      await _productService.fetchProduct(id);
      // Si quieres mostrar un solo producto, puedes agregar una propiedad para eso
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductsByCategory(String category) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _productService.fetchProductsByCategory(category);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}

