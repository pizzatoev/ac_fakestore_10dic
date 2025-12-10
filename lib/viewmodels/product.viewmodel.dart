import 'package:flutter/cupertino.dart';
import '../models/product.model.dart';
import '../services/product.service.dart';
import '../services/product_local.service.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final ProductLocalService _localService = ProductLocalService();

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
      // Obtener productos de la API
      final apiProducts = await _productService.fetchProducts();
      
      // Obtener productos locales
      final localProducts = await _localService.getAllLocalProducts();
      
      // Combinar productos (los locales primero, luego los de la API)
      _products = [...localProducts, ...apiProducts];
      _error = null;
    } catch (e) {
      // Si falla la API, intentar cargar solo productos locales
      try {
        _products = await _localService.getAllLocalProducts();
        _error = null;
      } catch (localError) {
        _error = e.toString();
      }
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
      // Obtener productos de la API por categoría
      final apiProducts = await _productService.fetchProductsByCategory(category);
      
      // Obtener productos locales por categoría
      final localProducts = await _localService.getProductsByCategory(category);
      
      // Combinar productos
      _products = [...localProducts, ...apiProducts];
      _error = null;
    } catch (e) {
      // Si falla la API, intentar cargar solo productos locales
      try {
        _products = await _localService.getProductsByCategory(category);
        _error = null;
      } catch (localError) {
        _error = e.toString();
      }
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<bool> createProduct(Product product) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      // Guardar en base de datos local
      final localId = await _localService.insertProduct(product);
      
      // Crear producto con el ID local
      final newProduct = Product(
        localId,
        product.title,
        product.price,
        product.description,
        product.category,
        product.image,
      );
      
      // Intentar guardar en la API (opcional, no crítico)
      try {
        await _productService.createProduct(product);
      } catch (apiError) {
        // Ignorar error de API, ya que guardamos localmente
      }
      
      // Agregar al inicio de la lista (productos locales primero)
      _products.insert(0, newProduct);
      _error = null;
      _cargando = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _cargando = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(int id, Product product) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      // Verificar si es un producto local (ID negativo)
      final isLocal = id < 0;
      
      if (isLocal) {
        // Actualizar en base de datos local
        await _localService.updateProduct(product);
        final index = _products.indexWhere((p) => p.id == id);
        if (index != -1) {
          _products[index] = product;
        }
      } else {
        // Intentar actualizar en la API
        try {
          final updatedProduct = await _productService.updateProduct(id, product);
          final index = _products.indexWhere((p) => p.id == id);
          if (index != -1) {
            _products[index] = updatedProduct;
          }
        } catch (apiError) {
          // Si falla la API, guardar localmente
          final localId = await _localService.insertProduct(product);
          final index = _products.indexWhere((p) => p.id == id);
          if (index != -1) {
            _products[index] = Product(
              localId,
              product.title,
              product.price,
              product.description,
              product.category,
              product.image,
            );
          }
        }
      }
      
      _error = null;
      _cargando = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _cargando = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      // Verificar si es un producto local (ID negativo)
      final isLocal = id < 0;
      
      if (isLocal) {
        // Eliminar de base de datos local
        await _localService.deleteProduct(id);
      } else {
        // Intentar eliminar de la API
        try {
          await _productService.deleteProduct(id);
        } catch (apiError) {
          // Si falla la API, solo eliminar de la lista local
        }
      }
      
      _products.removeWhere((p) => p.id == id);
      _error = null;
      _cargando = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _cargando = false;
      notifyListeners();
      return false;
    }
  }
}
