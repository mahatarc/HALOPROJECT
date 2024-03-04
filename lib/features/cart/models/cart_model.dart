class CartItemModel {
  final String productName;
  final String imageUrl;
  final String price;
  int quantity;
   String? productId; // Nullable productId

  CartItemModel({
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.productId,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'],
      productName: json['name'],
      imageUrl: json['image_url'],
      price: json['price'],
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': productName,
      'image_url': imageUrl,
      'price': price,
      'count': quantity,
    };
  }
}
