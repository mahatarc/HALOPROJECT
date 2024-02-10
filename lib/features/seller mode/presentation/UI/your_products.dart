import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/seller%20mode/presentation/Bloc/your_products_bloc/your_products_bloc.dart';
import 'package:flutterproject/features/seller%20mode/presentation/UI/edit_product.dart';
import 'package:flutterproject/features/seller%20mode/model/productmodel.dart';

class yourProducts extends StatefulWidget {
  const yourProducts({Key? key});

  @override
  State<yourProducts> createState() => _yourProductsState();
}

class _yourProductsState extends State<yourProducts> {
  late YourProductsBloc yourProductsBloc;
  late List<ProductModel> listOfProducts;
  // Future<List<ProductModel>> getProductsByUser(String userId) async {
  //   try {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('products')
  //         .where('userId', isEqualTo: userId)
  //         .get();

  //     // Convert QuerySnapshot to List<Map<String, dynamic>>
  //     List<Map<String, dynamic>> products = [];
  //     querySnapshot.docs.forEach((document) {
  //       products.add(document.data() as Map<String, dynamic>);
  //     });
  //     List<ProductModel> productModelList = [];
  //     for (var productData in products) {
  //       ProductModel productModel = ProductModel.fromMap(productData);
  //       productModelList.add(productModel);
  //     }
  //     return productModelList;
  //   } catch (e) {
  //     print('Error getting products: $e');
  //     return [];
  //   }
  // }

  @override
  void initState() {
    yourProductsBloc = BlocProvider.of<YourProductsBloc>(context);
    yourProductsBloc.add(YourProductsInitialEvent());
    super.initState();
  }

  // void initial() async {
  //   listOfProducts =
  //       await getProductsByUser(FirebaseAuth.instance.currentUser!.uid);
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YourProductsBloc, YourProductsState>(
        bloc: yourProductsBloc,
        builder: (context, state) {
          if (state is YourProductsInitialState) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green[200],
                title: Text('Your Products'),
              ),
              body: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        yourProductsBloc.add(YourProductsInitialEvent());
                        //     listOfProducts =
                        // await getProductsByUser(FirebaseAuth.instance.currentUser!.uid);
                      },
                      child: Text('Hello')),
                  ListView.builder(
                    itemCount: listOfProducts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SingleProduct(
                        product_name: listOfProducts[index].product_name,
                        product_picture: listOfProducts[index].product_picture,
                        //  prod_old_price: product_list[index]['old_price'],
                        prod_price: listOfProducts[index].prod_price,
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return Scaffold();
          }
        });
  }
}

class SingleProduct extends StatelessWidget {
  final product_name;
  final product_picture;
  // final prod_old_price;
  final prod_price;

  SingleProduct({
    this.product_name,
    this.product_picture,
    //this.prod_old_price,
    this.prod_price,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditProduct(
                edit_name: product_name,
                edit_price: prod_price,
                //  edit_old_price: prod_old_price,
                edit_picture: product_picture,
              ),
            ),
          ),
          child: ListTile(
            leading: Image.asset(
              product_picture,
              fit: BoxFit.contain,
              width: 80.0,
              height: 80.0,
            ),
            title: Text(
              product_name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\रु$prod_price",
                  style: TextStyle(
                    color: Colors.brown,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                // Text(
                //   "\रु$prod_old_price",
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontWeight: FontWeight.w800,
                //     decoration: TextDecoration.lineThrough,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
