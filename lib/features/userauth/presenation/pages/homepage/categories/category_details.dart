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
