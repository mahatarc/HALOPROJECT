class CartItemModel {
  final String productName;
  final String imageUrl;
  final String price;
  int quantity;
  final String product_detail_id;

  CartItemModel({
    required this.productName,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    required this.product_detail_id,
  });
  // Create CartItemModel from JSON data
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
        product_detail_id: json['productId'] ?? 'defaultID',
        productName: json['name'],
        imageUrl: json['image_url'],
        price: json['price'],
        quantity: 1);
  }
}
