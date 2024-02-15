class CartItemModel {
  final String productName;
  final String imageUrl;
  final String price;

  CartItemModel({
    required this.productName,
    required this.imageUrl,
    required this.price,
  });
  // Create CartItemModel from JSON data
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productName: json['name'],
      imageUrl: json['image_url'],
      price: json['price'],
    );
  }
}
