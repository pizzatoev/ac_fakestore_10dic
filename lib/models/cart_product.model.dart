class CartProduct {
  final int productId;
  final int quantity;

  CartProduct(this.productId, this.quantity);

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      json['productId'] as int,
      json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }
}

