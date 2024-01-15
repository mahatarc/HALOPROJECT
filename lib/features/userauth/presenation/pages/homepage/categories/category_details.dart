import 'package:flutter/material.dart';
import 'package:flutterproject/features/userauth/presenation/pages/consts/lists.dart';
import 'package:flutterproject/features/userauth/presenation/pages/product_details.dart';

class CategoryDetails extends StatefulWidget {
  final String? title;
  CategoryDetails({Key? key, required this.title}) : super(key: key);

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  Widget build(BuildContext context) {
    // List<ProductModel> productList = getProductList(title);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[200],
          title: Text(widget.title ??
              'Category Details'), // Display the category name in the AppBar
        ),
        body: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                  child: GridView.builder(
                shrinkWrap: true,
                itemCount: categoryImages.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 200,
                ),
                itemBuilder: (context, index) {
                  return single_prod(
                    product_name: Crops_list[index]['name'],
                    product_picture: Crops_list[index]['picture'],
                    prod_old_price: Crops_list[index]['old_price'],
                    prod_price: Crops_list[index]['price'],
                  );
                },
              ))
            ],
          ),
        ));
  }
}

class single_prod extends StatelessWidget {
  final product_name;
  final product_picture;
  final prod_old_price;
  final prod_price;
  single_prod({
    this.product_name,
    this.product_picture,
    this.prod_old_price,
    this.prod_price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
          child: InkWell(
        onTap: () => Navigator.of(context).push(new MaterialPageRoute(
            //passing the values of products of this page to product details page
            builder: (context) => ProductsDetails(
                  product_detail_name: product_name,
                  product_detail_price: prod_price,
                  product_detail_old_price: prod_old_price,
                  product_detail_picture: product_picture,
                ))),
        child: GridTile(
          footer: Container(
            color: Colors.white70,
            child: ListTile(
              leading: Text(
                product_name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              title: Text(
                "\₹$prod_price",
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.w800,
                ),
              ),
              subtitle: Text(
                "\₹$prod_old_price",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.lineThrough),
              ),
            ),
          ),
          child: Image.asset(
            product_picture,
            fit: BoxFit.cover,
          ),
        ),
      )),
    );
  }
}
