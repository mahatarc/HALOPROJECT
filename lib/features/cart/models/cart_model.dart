class CartItemModel {
  final String productName;
  final String imageUrl;
  final String price;
  int quantity;
  final String productId;

  CartItemModel({
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.productId,
  });

  // Create CartItemModel from JSON data
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final productId = json['productId'] ?? 'defaultID';

    return CartItemModel(
      productId: productId.isNotEmpty ? productId : 'defaultID',
      productName: json['name'],
      imageUrl: json['image_url'],
      price: json['price'],
      quantity: json['quantity'] ?? 1, // Initialize quantity from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': productName,
      'image_url': imageUrl,
      'price': price,
      'count': quantity, // Include the quantity field in JSON data
    };
  }
}
