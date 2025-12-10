class CartProduct {
  final int productId;
  final int quantity;

  CartProduct(this.productId, this.quantity);

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      (json['productId'] is int) 
          ? json['productId'] as int 
          : (json['productId'] as num).toInt(),
      (json['quantity'] is int) 
          ? json['quantity'] as int 
          : (json['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }
}

