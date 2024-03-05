class CartItemModel {
  final String productName;
  final String imageUrl;
  final String price;
  late final int selectedQuantity; // New field for the selected quantity
  String? productId; // Nullable productId

  CartItemModel({
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.selectedQuantity,
    required this.productId,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json,
      {int selectedQuantity = 1}) {
    return CartItemModel(
      productId: json['productId'],
      productName: json['name'],
      imageUrl: json['image_url'],
      price: json['price'],
      selectedQuantity:
          selectedQuantity, // Set selected quantity from parameter
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': productName,
      'image_url': imageUrl,
      'price': price,
      'selectedQuantity': selectedQuantity
    };
  }
}
