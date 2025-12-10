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

  Future<bool> createCart(Cart cart) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final newCart = await _cartService.createCart(cart);
      _carts.add(newCart);
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

  Future<bool> updateCart(int id, Cart cart) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final updatedCart = await _cartService.updateCart(id, cart);
      final index = _carts.indexWhere((c) => c.id == id);
      if (index != -1) {
        _carts[index] = updatedCart;
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

  Future<bool> deleteCart(int id) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      await _cartService.deleteCart(id);
      _carts.removeWhere((c) => c.id == id);
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
