import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/categories/category_details.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/categories/category_viewmore.dart';
import 'package:flutterproject/consts/lists.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/drawer/drawer_a.dart';
import 'package:flutterproject/features/feed/presentation/UI/pages/newsfeed.dart';
import 'package:flutterproject/features/cart/presentation/UI/pages/cart.dart';
import 'package:flutterproject/features/home/presentation/bloc/home_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
  ];
  List<IconData> iconlist = [
    Icons.home,
    Icons.feed_rounded,
    Icons.add_shopping_cart,
  ];
  List label = ['Home', 'Newsfeed', 'Cart'];
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
  // int currentIndex = 0;
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
                title: Text(
                  'Halo',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(),
                  ),
                ),
                backgroundColor: Colors.green[100],
                actions: [
                  Icon(Icons.notification_add),
                ],
              ),
              backgroundColor: Color.fromARGB(255, 243, 247, 241),
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
                            label: Text(
                              "Search your product...",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(),
                              ),
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              size: 30,
                              color: Colors.green[200],
                            ),
                          ),
                        ),
                      ),
                      // SizedBox to create some space between the search bar and carousel
                      SizedBox(height: 20),
                      ImageCarouselSlider(),
                      SizedBox(height: 20),

                      ///Categoriess---------------------------------------------------------
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Categories',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                textScaleFactor: 1.5,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  homePageBloc.add(CategoriesPressedEvent());
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 239, 244, 249),
                                  onPrimary:
                                      const Color.fromARGB(255, 11, 3, 3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'View More',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        height: 100.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
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
                      SizedBox(height: 20),

                      // Recommended Section
                      Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Recommended for you',
                                /* style: TextStyle(fontWeight: FontWeight.bold,
                                ),*/
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                textScaleFactor: 1.5,
                              ),
                            ),
                            RecommendProduct(),
                          ],
                        ),
                      ),
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

class RecommendProduct extends StatelessWidget {
  const RecommendProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('products').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Loading');
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Errorr');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            List<QueryDocumentSnapshot> products =
                snapshot.data!.docs.cast<QueryDocumentSnapshot>();
            print(products.first);
            print('categories receieved');
            return Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (BuildContext context, int index) {
                  var productData =
                      products[index].data() as Map<String, dynamic>;

                  return SingleProduct(
                    product_name: productData['name'],
                    product_picture: productData['image_url'],
                    prod_price: productData['price'],
                    prod_details: productData['product_details'],
                  );
                },
              ),
            );
          }
          return Scaffold();
        },
      ),
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
