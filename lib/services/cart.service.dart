import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.model.dart';

class CartService {
  final String baseUrl = 'https://fakestoreapi.com';

  Future<List<Cart>> fetchCarts() async {
    final response = await http.get(Uri.parse('$baseUrl/carts'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Cart.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar carritos');
    }
  }

  Future<Cart> fetchCart(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/carts/$id'));
    if (response.statusCode == 200) {
      return Cart.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar el carrito');
    }
  }

  Future<List<Cart>> fetchCartsByUser(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/carts/user/$userId'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Cart.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar carritos del usuario');
    }
  }

  Future<Cart> createCart(Cart cart) async {
    final response = await http.post(
      Uri.parse('$baseUrl/carts'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cart.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Cart.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear el carrito');
    }
  }

  Future<Cart> updateCart(int id, Cart cart) async {
    final response = await http.put(
      Uri.parse('$baseUrl/carts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cart.toJson()),
    );
    if (response.statusCode == 200) {
      return Cart.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar el carrito');
    }
  }

  Future<Cart> patchCart(int id, Map<String, dynamic> updates) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/carts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updates),
    );
    if (response.statusCode == 200) {
      return Cart.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar parcialmente el carrito');
    }
  }

  Future<void> deleteCart(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/carts/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el carrito');
    }
  }
}

