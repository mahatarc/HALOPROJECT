class ProductModel {
  final String productname;
  final String productpicture;
  // final double prod_old_price;
  final String productprice;

  ProductModel({
    required this.productname,
    required this.productpicture,
    // this.prod_old_price,
    required this.productprice,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productname: map['name'],
      productpicture: map['image_url'],
      productprice: map['price'],
      // prod_old_price: map['old_price'],
    );
  }
}
