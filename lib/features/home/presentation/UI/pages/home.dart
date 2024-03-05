import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/feed/feedprofile.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/categories/category.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/categories/category_details.dart';
import 'package:flutterproject/consts/lists.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/drawer/drawer_a.dart';
import 'package:flutterproject/features/feed/presentation/UI/pages/newsfeed.dart';
import 'package:flutterproject/features/cart/presentation/UI/pages/cart.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/product_details.dart';
import 'package:flutterproject/features/home/presentation/bloc/home_bloc.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List myCart = [];
  int currentIndex = 0;
  List<Widget> pages = [
    Home(),
    NewsFeed(),
    CartPage(),
    FeedProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type:
            BottomNavigationBarType.fixed, // Set type to fixed for even spacing
        selectedItemColor: Color.fromARGB(255, 64, 64, 64),
        // unselectedItemColor: Colors.black.withOpacity(.5),
        backgroundColor: Colors.green[100],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed_rounded),
            label: 'Newsfeed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: 'My Posts',
          ),
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late HomePageBloc homePageBloc;
  @override
  void initState() {
    homePageBloc = BlocProvider.of<HomePageBloc>(context);
    homePageBloc.add(HomePageInitialEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageState>(
        bloc: homePageBloc,
        listenWhen: (previous, current) => current is HomePageActionState,
        buildWhen: (previous, current) => current is! HomePageActionState,
        builder: (context, state) {
          if (state is HomePageInitialState) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Halo'),
                backgroundColor: Colors.green[100],
                actions: [
                  Icon(Icons.notification_add),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        //  width: MediaQuery.of(context).size.width / 1.12,
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            label: Text("Search your product..."),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              size: 30,
                              color: Colors.green[200],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ImageCarouselSlider(),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8),
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
                                homePageBloc.add(CategoriesPressedEvent());
                              },
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: const Color.fromARGB(
                                      255, 11, 3, 3), backgroundColor: Color.fromARGB(255, 239, 244,
                                      249), // Change the text color
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
                          itemCount: 4,
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
              drawer: Mydrawer(),
            );
          } else {
            return const Scaffold();
          }
        },
        listener: (context, state) {
          if (state is HomeToCategoriesNavigateState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryScreen(),
              ),
            );
          }
          if (state is HomeToCartNavigateState) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          }
          if (state is HomeToNewsFeedNavigateState) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewsFeed()),
            );
          }
        });
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
              selectedCategory: categoryName,
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
