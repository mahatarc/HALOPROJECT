import 'package:flutter/material.dart';
//import 'package:flutter_application_1/consts/lists.dart';
//import 'package:flutter_application_1/homepage/categories/category_details.dart';
import 'package:flutterproject/features/userauth/presenation/pages/categories/category_details.dart';
import 'package:flutterproject/features/userauth/presenation/pages/consts/lists.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: const Text("Categories"),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
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
            return GestureDetector(
              onTap: () {
                // Handle category tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryDetails(
                      title: categoriesList[index],
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Image.asset(
                    categoryImages[index],
                    height: 130,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 8),
                  Text(
                    categoriesList[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
