import 'package:flutter/cupertino.dart';
import '../models/cart.model.dart';
import '../services/cart.service.dart';

class CartViewModel extends ChangeNotifier {
  final CartService _cartService = CartService();

  List<Cart> _carts = [];
  bool _cargando = false;
  String? _error;

  List<Cart> get carts => _carts;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> fetchCarts() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _carts = await _cartService.fetchCarts();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> fetchCart(int id) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      await _cartService.fetchCart(id);
      // Si quieres mostrar un solo carrito, puedes agregar una propiedad para eso
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> fetchCartsByUser(int userId) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _carts = await _cartService.fetchCartsByUser(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}

