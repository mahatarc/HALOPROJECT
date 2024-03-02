class ProductModel {
  final String productname;
  final String productpicture;
  final String productprice;
  final String categorytype;
  final String productdetails;

  ProductModel({
    required this.productname,
    required this.productpicture,
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
        categorytype: map['category_type']);
  }
}
