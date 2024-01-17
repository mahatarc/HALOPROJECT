import 'package:flutter/material.dart';
import 'package:flutterproject/features/userauth/presenation/pages/consts/lists.dart';
import 'package:flutterproject/features/userauth/presenation/pages/homepage/home.dart';

class CategoryDetails extends StatefulWidget {
  final String title;
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

  List<String> categoriesList = ['Crops', 'Tools', 'Machineries', 'Books'];

  Map<String, List<dynamic>> categoryLists = {
    'Crops': Crops_list,
    'Tools': tools_list,
    'Machineries': machineries,
    'Books': books_list,
  };

  Map<String, String> categoryImages = {
    'Crops': 'images/crops.png',
    'Tools': 'images/axe.png',
    'Machineries': 'images/machineries.jpg',
    'Books': 'images/books.png',
  };

  @override
  Widget build(BuildContext context) {
    List<dynamic> selectedList = categoryLists[selectedCategory] ?? [];

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
              product_picture: categoryImages[selectedCategory],
              prod_old_price: selectedList[index]['old_price'],
              prod_price: selectedList[index]['price'],
            );
          },
        ),
      ),
    );
  }
}
