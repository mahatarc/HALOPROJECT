import 'package:flutter/material.dart';
import 'package:flutterproject/features/userauth/presenation/pages/consts/lists.dart';
import 'package:flutterproject/features/userauth/presenation/pages/seller%20mode/edit_product.dart';

class yourProducts extends StatefulWidget {
  const yourProducts({super.key});

  @override
  State<yourProducts> createState() => _yourProductsState();
}

class _yourProductsState extends State<yourProducts> {
  int currerntIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Text('Your Products'),
      ),
      body: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: your_products.length,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return single_prod(
              product_name: product_list[index]['name'],
              product_picture: product_list[index]['picture'],
              prod_old_price: product_list[index]['old_price'],
              prod_price: product_list[index]['price'],
            );
          }),
    );
  }
}

class single_prod extends StatelessWidget {
  // const single_prod({super.key});
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
            builder: (context) => new EditProduct(
                  edit_name: product_name,
                  edit_price: prod_price,
                  edit_old_price: prod_old_price,
                  edit_picture: product_picture,
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
                "\रु$prod_price",
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.w800,
                ),
              ),
              subtitle: Text(
                "\रु$prod_old_price",
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
