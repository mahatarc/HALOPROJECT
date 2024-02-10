class ProductModel {
  final product_name;
  final product_picture;
 // final prod_old_price;
  final prod_price;


  ProductModel({
    this.product_name,
    this.product_picture,
   // this.prod_old_price,
    this.prod_price,
  });
  // Factory method to create Product object from a map

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      product_name: map['name'],
      product_picture: map['image_url'],
      prod_price: map['price'],
    );
  }
}
