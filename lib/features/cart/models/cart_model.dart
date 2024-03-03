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
    this.quantity = 1,
    required this.productId,
  });
  // Create CartItemModel from JSON data
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
        productId: json['productId'] ?? 'defaultID',
        productName: json['name'],
        imageUrl: json['image_url'],
        price: json['price'],
        quantity: 1);
  }
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': productName,
      'image_url': imageUrl,
      'price': price,
    };
  }
}
