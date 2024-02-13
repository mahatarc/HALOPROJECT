class ProductModel {
  final String productname;
  final String productpicture;
  // final double prod_old_price;
  final String productprice;
  final String categorytype;
  final String productdetails;

  ProductModel({
    required this.productname,
    required this.productpicture,
    // this.prod_old_price,
    required this.productprice,
    required this.categorytype,
    required this.productdetails,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
        productname: map['name'],
        productpicture: map['image_url'],
        productprice: map['price'],
        productdetails: map['product_details'],
        categorytype: map['category_type']
        // prod_old_price: map['old_price'],
        );
  }
}
