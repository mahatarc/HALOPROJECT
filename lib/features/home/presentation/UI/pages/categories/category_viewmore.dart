import 'package:flutter/material.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/categories/category_details.dart';

class Category extends StatelessWidget {
  final String imagePath;
  final String categoryName;
  // Add categoryType parameter

  Category({
    required this.imagePath,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to CategoryDetails page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetails(
              selectedCategory: categoryName,
            ),
          ),
        );
      },
      child: Container(
        height: 200,
        child: Column(
          children: <Widget>[
            Image.asset(
              imagePath,
              width: 100,
              height: 60,
            ),
            Text(categoryName)
          ],
        ),
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: const Text("Categories"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: GridView.builder(
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => CategoryDetails(
                //       selectedCategory: categoriesList[index],
                //     ),
                //   ),
                // );
                Navigator.of(context, rootNavigator: true)
                    .pushReplacement(MaterialPageRoute(
                  builder: (context) =>
                      CategoryDetails(selectedCategory: categoriesList[index]),
                ));
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

const categoriesList = ['Seed', 'Tools', 'Plant'];

const categoryImages = [
  'images/crops.png',
  'images/gardening.png',
  'images/plants.png',
];
