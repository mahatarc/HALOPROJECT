import 'package:flutter/material.dart';
import 'package:flutterproject/consts/lists.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/drawer/seller%20mode/edit_product.dart';

class yourProducts extends StatefulWidget {
  const yourProducts({Key? key});

  @override
  State<yourProducts> createState() => _yourProductsState();
}

class _yourProductsState extends State<yourProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Text('Your Products'),
      ),
      body: ListView.builder(
        //itemCount: your_products.length,
        itemBuilder: (BuildContext context, int index) {
          return SingleProduct(
            product_name: product_list[index]['name'],
            product_picture: product_list[index]['picture'],
            prod_old_price: product_list[index]['old_price'],
            prod_price: product_list[index]['price'],
          );
        },
      ),
    );
  }
}

class SingleProduct extends StatelessWidget {
  final product_name;
  final product_picture;
  final prod_old_price;
  final prod_price;

  SingleProduct({
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
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditProduct(
                edit_name: product_name,
                edit_price: prod_price,
                edit_old_price: prod_old_price,
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
                Text(
                  "\रु$prod_old_price",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
