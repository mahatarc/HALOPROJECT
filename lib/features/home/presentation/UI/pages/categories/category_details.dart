import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutterproject/consts/lists.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/product_details.dart';

class CategoryDetails extends StatefulWidget {
  final String selectedCategory;

  CategoryDetails({required this.selectedCategory});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
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
                    .height, // Set any desired height
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:
                        1.0, // Aspect ratio of items (adjust as needed)
                    mainAxisSpacing: 8.0, // Spacing between rows
                    crossAxisSpacing: 8.0, // Spacing between columns
                  ),
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    var productData =
                        products[index].data() as Map<String, dynamic>;
                    var productId = products[index].id;
                    return SingleProduct(
                      productId: productId,
                      product_name: productData['name'],
                      product_picture: productData['image_url'],
                      prod_price: productData['price'],
                      prod_details: productData['product_details'],
                    );
                  },
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

class SingleProduct extends StatelessWidget {
  final productId;
  final product_name;
  final product_picture;
  final prod_price;
  final prod_details;

  SingleProduct({
    this.productId,
    this.product_name,
    this.product_picture,
    this.prod_price,
    this.prod_details,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        child: InkWell(
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new ProductsDetails(
              product_detail_id: productId,
              product_detail_name: product_name,
              product_detail_price: prod_price,
              product_detail_picture: product_picture,
              product_detail_details: prod_details,
            ),
          )),
          child: GridTile(
            footer: Container(
              color: Color.fromARGB(179, 230, 238, 224),
              height: 60,
              child: ListTile(
                title: Text(
                  product_name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
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
            child: SizedBox(
              height: MediaQuery.of(context).size.height *
                  100, // Adjust the height as needed
              child: Image.network(product_picture, fit: BoxFit.fill),
            ),
          ),
        ),
      ),
    );
  }
}
