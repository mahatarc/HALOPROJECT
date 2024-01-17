import 'package:flutter/material.dart';
import 'package:flutterproject/features/userauth/presenation/pages/consts/lists.dart';
import 'package:flutterproject/features/userauth/presenation/pages/homepage/home.dart';

class CategoryDetails extends StatefulWidget {
  final String title;
// final String? selectedCategory;
  final String selectedCategory;
  CategoryDetails({required this.selectedCategory, required this.title});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory;
  }

  void changeCategory(String categoryname) {
    setState(() {
      selectedCategory = categoryname;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> selectedList;

    switch (selectedCategory) {
      case 'Crops':
        selectedList = Crops_list;
        break;
      case 'Tools':
        selectedList = tools_list;
        break;
      case 'Machineries':
        selectedList = machineries;
        break;
      case 'Books':
        selectedList = books_list;
        break;
      default:
        selectedList = Crops_list;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: selectedList.length,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return single_prod(
              product_name: selectedList[index]['name'],
              product_picture: selectedList[index]['picture'],
              prod_old_price: selectedList[index]['old_price'],
              prod_price: selectedList[index]['price'],
            );
          },
        ),
      ),
    );
  }
}

/*class single_prod extends StatelessWidget {
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
*/