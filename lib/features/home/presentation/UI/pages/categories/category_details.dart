import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/consts/lists.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/product_details.dart';

class CategoryDetails extends StatefulWidget {
  final String selectedCategory;

  CategoryDetails({required this.selectedCategory});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  // void initState() {
  //   super.initState();
  //   selectedCategory = widget.selectedCategory;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Text(widget.selectedCategory),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('products')
              .where('category_type', isEqualTo: widget.selectedCategory)
              .get(),
          // future: FirebaseFirestore.instance
          //     .collection('categories')
          //     .doc(selectedCategory)
          //     .collection('products')
          //     .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('LOadingggggggggggggggggg');
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              print('Errorrrrrrrrrrr');
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.done) {
              List<QueryDocumentSnapshot> products =
                  snapshot.data!.docs.cast<QueryDocumentSnapshot>();
              print(products.first);
              print('categories receieved');
              return Container(
                height: MediaQuery.of(context)
                    .size
                    .height, // Or set any desired height
                child: Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      var productData =
                          products[index].data() as Map<String, dynamic>;

                      return SingleProduct(
                        product_name: productData['name'],
                        product_picture: productData['image_url'],
                        prod_price: productData['price'],
                        prod_details: productData['product_details'],
                      );
                    },
                  ),
                ),
              );
            }
            return Scaffold();
          },
        ),
      ),
    );
  }
}

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: product_list.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return SingleProduct(
            product_name: product_list[index]['name'],
            product_picture: product_list[index]['picture'],
            prod_price: product_list[index]['price'],
          );
        });
  }
}

class SingleProduct extends StatelessWidget {
  // const single_prod({super.key});
  final product_name;
  final product_picture;
  final prod_price;
  final prod_details;
  // final prod_quantity;
  // final prod_id;

  SingleProduct({
    this.product_name,
    this.product_picture,
    this.prod_price,
    this.prod_details,
    //   this.prod_quantity
    // this.prod_id,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Material(
      child: InkWell(
        onTap: () => Navigator.of(context).push(new MaterialPageRoute(
            //passing the values of products of this page to product details page
            builder: (context) => new ProductsDetails(
                  product_detail_name: product_name,
                  product_detail_price: prod_price,
                  product_detail_picture: product_picture,
                  //  product_detail_id: prod_id,
                  product_detail_details: prod_details,
                  // product_detail_quantity: prod_quantity,
                ))),
        child: GridTile(
          footer: Container(
            color: Colors.white70,
            child: ListTile(
              title: Text(
                product_name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              subtitle: Text(
                "\रु$prod_price",
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          child: Image.network(product_picture, fit: BoxFit.fill),
        ),
      ),
    ));
  }
}
