import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/categories/category_details.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/categories/category_viewmore.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/drawer/drawer_a.dart';
import 'package:flutterproject/features/feed/presentation/UI/pages/newsfeed.dart';
import 'package:flutterproject/features/cart/presentation/UI/pages/cart.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/product_details.dart';
import 'package:flutterproject/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutterproject/features/mapservice/presentation/maps.dart';
import 'package:flutterproject/nav.dart';

List myCart = [];
int currentIndex = 0;
List<Widget> pages = [
  Home(),
  NewsFeed(),
  BlocProvider(
    create: (context) => CartBloc(),
    child: CartPage(),
  ),
  MapService(),
];

class LandingPage extends StatelessWidget {
  final int? pageIndex;
  const LandingPage({
    super.key,
    this.pageIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Scaffold(
          body: pages[0],
          bottomNavigationBar:
              BottomBar2(screenList: pages, selectedIndex: pageIndex),
        ),
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
  late TextEditingController _searchController;
  late List<Map<String, dynamic>> _filteredProducts;
  Map<String, dynamic>? _searchedProduct;
  @override
  void initState() {
    homePageBloc = BlocProvider.of<HomePageBloc>(context);
    homePageBloc.add(HomePageInitialEvent());
    _searchController = TextEditingController();
    super.initState();
  }

  Future<void> fetchProduct(String query) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('products').get();
      final List<Map<String, dynamic>> products =
          snapshot.docs.map((doc) => doc.data()).toList();

      setState(() {
        if (query.isNotEmpty) {
          _searchedProduct = products.firstWhere((product) =>
              product['name'].toLowerCase().contains(query.toLowerCase()));

          // Retrieve seller information for the searched product
          final sellerId = _searchedProduct!['user_id'];
          FirebaseFirestore.instance
              .collection('sellers')
              .doc(sellerId)
              .get()
              .then((sellerDoc) {
            if (sellerDoc.exists) {
              print('Seller information retrieved: ${sellerDoc.data()}');
              setState(() {
                _searchedProduct!['sellers'] = sellerDoc.data();
                print("Successful.......................................");
              });
            } else {
              print('Seller document does not exist.');
            }
          }).catchError((error) {
            print('Error fetching seller details: $error');
          });
        } else {
          _searchedProduct = null;
          // Remove focus from the search field
          FocusScope.of(context).requestFocus(FocusNode());
        }
      });
    } catch (e) {
      print('Error fetching product: $e');
    }
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
                  'HALO',
                  /* style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),*/
                ),
                backgroundColor: Colors.green[100],
              ),
              backgroundColor: Color.fromARGB(255, 243, 247, 241),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextFormField(
                            controller: _searchController,
                            onChanged: (value) {
                              fetchProduct(value.trim());
                            },
                            decoration: InputDecoration(
                              label: Text(
                                "Search your product...",
                                /* style: GoogleFonts.actor(),*/
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
                      ),
                      SizedBox(height: 20),
                      if (_searchedProduct != null)
                        ListTile(
                          title: Text(_searchedProduct!['name'] ?? ''),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductsDetails(
                                  product_detail_id:
                                      _searchedProduct!['id'] ?? '',
                                  product_detail_name:
                                      _searchedProduct!['name'] ?? '',
                                  product_detail_price:
                                      _searchedProduct!['price'] ?? '',
                                  product_detail_picture:
                                      _searchedProduct!['image_url'] ?? '',
                                  product_detail_details:
                                      _searchedProduct!['product_details'] ??
                                          '',
                                  seller: _searchedProduct![
                                      'sellers'], // Pass the seller information here
                                ),
                              ),
                            );
                          },
                        ),

                      SizedBox(height: 20),
                      ImageCarouselSlider(),
                      SizedBox(height: 20),

                      ///Categoriess---------------------------------------------------------
                      Card(
                        child: Column(
                          children: [
                            Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Categories',
                                      /* style: GoogleFonts.firaSans(
                                        //  fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),*/
                                      textScaleFactor: 1.5,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        homePageBloc
                                            .add(CategoriesPressedEvent());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromARGB(255, 239, 244, 249),
                                        onPrimary:
                                            const Color.fromARGB(255, 11, 3, 3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        'View More',
                                        /* style: GoogleFonts.firaSans(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),*/
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
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      // Recommended Section
                      Card(
                        child: Container(
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
                                  /* style: GoogleFonts.firaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),*/
                                  textScaleFactor: 1.5,
                                ),
                              ),
                              RecommendProduct(),
                            ],
                          ),
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
  const RecommendProduct({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: FutureBuilder<QuerySnapshot>(
        future:
            FirebaseFirestore.instance.collection('products').limit(1).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Loading');
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Error');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            List<QueryDocumentSnapshot> products =
                snapshot.data!.docs.cast<QueryDocumentSnapshot>();
            print(products.first);
            print('Categories received');
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                var productData =
                    products[index].data() as Map<String, dynamic>;
                var productId = products[index].id;
                return SingleProduct(
                  productId: productId,
                  product_name: productData['name'],
                  product_picture: productData['image_url'],
                  prod_price: productData['price'],
                  prod_details: productData['product_details'],
                );
              },
            );
          }
          return SizedBox(); // Return an empty widget if none of the conditions are met
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
        'images/advertisement.png',
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
