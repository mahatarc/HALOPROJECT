import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutterproject/features/cart/models/cart_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartBloc cartBloc;
  late List<CartItemModel> listOfProducts = []; // Initialize here
  late List<CartItemModel> updatedProducts = [];

  @override
  void initState() {
    cartBloc = BlocProvider.of<CartBloc>(context);
    cartBloc.add(MyCartInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>(
      create: (context) => cartBloc,
      child: BlocBuilder<CartBloc, CartState>(
        bloc: cartBloc,
        builder: (context, state) {
          if (state is MyCartLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MyCartLoadedState) {
            listOfProducts = state.products; // Update the existing list
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green[200],
                title: const Text('My Cart'),
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  cartBloc.add(MyCartInitialEvent());
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: listOfProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CartProduct(
                            product: listOfProducts[index],
                            increaseQuantity: () {
                              setState(() {
                                listOfProducts[index].quantity++;
                                updatedProducts = listOfProducts;
                              });
                            },
                            decreaseQuantity: () {
                              setState(() {
                                if (listOfProducts[index].quantity > 1) {
                                  listOfProducts[index].quantity--;
                                  updatedProducts = listOfProducts;
                                }
                              });
                            },
                            deleteItem: () {
                              cartBloc
                                  .add(DeleteItemEvent(listOfProducts[index]));
                            },
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Save the updated quantities to Firestore
                        saveQuantitiesToFirestore(updatedProducts);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Delivery Charge: रु50'),
                      ElevatedButton(
                        onPressed: () {
                          print('Checkout pressed');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 156, 199, 107),
                        ),
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Scaffold();
          }
        },
      ),
    );
  }

  void saveQuantitiesToFirestore(List<CartItemModel> updatedProducts) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final cartRef = FirebaseFirestore.instance
          .collection('carts')
          .doc(userId)
          .collection(userId);

      for (var product in updatedProducts) {
        await cartRef
            .doc(product
                .product_detail_id) // Use product_detail_id as the document ID
            .update({'quantity': product.quantity});
      }
      setState(() {
        // Assign the updated products list to the original list
        listOfProducts = updatedProducts;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantities saved successfully')),
      );
    } catch (e) {
      print('Error saving quantities: $e');
    }
  }
}

// CartProduct widget
class CartProduct extends StatelessWidget {
  final CartItemModel product;
  final VoidCallback increaseQuantity;
  final VoidCallback decreaseQuantity;
  final VoidCallback deleteItem;

  const CartProduct({
    required this.product,
    required this.increaseQuantity,
    required this.decreaseQuantity,
    required this.deleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Image.network(
            product.imageUrl,
            fit: BoxFit.contain,
            width: 80.0,
            height: 80.0,
          ),
          title: Text(
            product.productName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "रु${product.price}",
                style: const TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: decreaseQuantity,
                    icon: const Icon(Icons.remove),
                  ),
                  Text(product.quantity.toString()),
                  IconButton(
                    onPressed: increaseQuantity,
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: deleteItem,
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
