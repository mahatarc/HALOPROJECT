import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/homepage/product_details.dart';
import 'package:flutter_application_1/consts/lists.dart';
import 'package:flutter_application_1/drawer.dart';
import 'package:flutter_application_1/homepage/home_icons/newsfeed.dart';
import 'package:flutter_application_1/homepage/home_icons/wishlist.dart';
import 'package:flutter_application_1/homepage/categories/category.dart';
import 'package:flutter_application_1/homepage/categories/category_details.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int myIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
            ),
            onPressed: () {},
          ),
          IconButton(
              icon: Icon(
                Icons.card_giftcard_rounded,
              ),
              onPressed: () {}),
        ],
        title: const Text("Halo"),
      ),
      body: SingleChildScrollView(
        //scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                //  width: MediaQuery.of(context).size.width / 1.12,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 207, 254, 210),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    label: Text("Search your product..."),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      size: 30,
                      color: Color.fromARGB(134, 107, 241, 100),
                    ),
                  ),
                ),
              ),
              // SizedBox to create some space between the search bar and carousel
              SizedBox(height: 20),
              ImageCarouselSlider(),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textScaleFactor: 1.5,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 239, 244,
                              249), // Change the background color
                          onPrimary: const Color.fromARGB(
                              255, 11, 3, 3), // Change the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      child: Text(
                        'View More',
                        style: TextStyle(
                          fontSize: 16, // Adjust text size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 100.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Category(
                        imagePath: categoryImages[index],
                        categoryName: categoriesList[index],
                      ),
                    );
                  },
                ),
              ),

              // Recommended Section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Recommended for you',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.5,
                ),
              ),
              Products(),
            ],
          ),
        ),
      ),
      drawer: const Mydrawer(),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            myIndex = index;
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsFeed()),
              );
            }
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            }
          });
        },
        height: 80,
        elevation: 0,
        selectedIndex: myIndex,
        backgroundColor: Colors.green[100],
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.newspaper), label: 'Feed'),
          NavigationDestination(
              icon: Icon(Icons.add_shopping_cart), label: 'Cart'),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String imagePath;
  final String categoryName;

  Category({required this.imagePath, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to CategoryDetails page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetails(
              title: categoryName,
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

class Products extends StatefulWidget {
  // const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: product_list.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return single_prod(
            product_name: product_list[index]['name'],
            product_picture: product_list[index]['picture'],
            prod_old_price: product_list[index]['old_price'],
            prod_price: product_list[index]['price'],
          );
        });
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
            builder: (context) => new ProductsDetails(
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

class ImageCarouselSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.easeInOut,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
      items: [
        'images/logo.png',
        'images/discount.png',
      ].map((String imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
