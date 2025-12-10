class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  Product(this.id, this.title, this.price, this.description, this.category, this.image);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      json['id'] as int,
      json['title'] as String,
      (json['price'] as num).toDouble(),
      json['description'] as String,
      json['category'] as String,
      json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
    };
  }
}

