import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/categories/category_details.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/home.dart';
import 'package:flutterproject/features/home/presentation/bloc/home_bloc.dart';

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
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => CategoryDetails(
              selectedCategory: categoryName,
            ),
          ),
          // Remove all routes from the stack
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
        // );
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => HomePageBloc(),
                  child: LandingPage(),
                ),
              ),
            );
          },
        ),
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
                // Navigator.of(context, rootNavigator: true)
                //     .pushReplacement(MaterialPageRoute(
                //   builder: (context) =>
                //       CategoryDetails(selectedCategory: categoriesList[index]),
                // ));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryDetails(
                        selectedCategory: categoriesList[index]),
                    fullscreenDialog:
                        true, // Set fullscreenDialog to true to remove the AppBar
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

const categoriesList = ['Seed', 'Tools', 'Plant', 'Fertilizer'];

const categoryImages = [
  'images/crops.png',
  'images/gardening.png',
  'images/plants.png',
  'images/fertilizer.png'
];
