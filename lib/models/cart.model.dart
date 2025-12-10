import 'cart_product.model.dart';

class Cart {
  final int id;
  final int userId;
  final List<CartProduct> products;

  Cart(this.id, this.userId, this.products);

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      (json['id'] is int) 
          ? json['id'] as int 
          : (json['id'] as num).toInt(),
      (json['userId'] is int) 
          ? json['userId'] as int 
          : (json['userId'] as num).toInt(),
      (json['products'] as List)
          .map((product) => CartProduct.fromJson(product as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}

