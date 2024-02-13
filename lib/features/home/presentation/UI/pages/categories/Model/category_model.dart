// import 'package:flutterproject/features/seller%20mode/model/productmodel.dart';

// class CategoryModel {
//   final String type;
//   final List<ProductModel> products;

//   CategoryModel({
//     required this.type,
//     required this.products,
//   });

//   static List<CategoryModel> fromProducts(List<ProductModel> products) {
//     // Extract unique category types from products
//     Set<String> uniqueCategoryTypes = products.map((product) => product.categorytype).toSet();

//     // Create CategoryModel instances for each unique category type
//     List<CategoryModel> categories = uniqueCategoryTypes.map((categoryType) {
//       // Filter products for the current category type
//       List<ProductModel> filteredProducts = products.where((product) => product.categorytype == categoryType).toList();
//       // Create CategoryModel instance for the current category type
//       return CategoryModel(
//         type: categoryType,
//         products: filteredProducts,
//       );
//     }).toList();

//     return categories;
//   }
// }
class CategoryModel {
  final String name;

  CategoryModel({required this.name});

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'],
    );
  }
}
