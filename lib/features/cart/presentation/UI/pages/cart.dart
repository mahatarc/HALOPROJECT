import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/buy_now/location.dart';
import 'package:flutterproject/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutterproject/features/cart/models/cart_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartBloc cartBloc;
  late List<CartItemModel> updatedProducts;

  @override
  void initState() {
    cartBloc = BlocProvider.of<CartBloc>(context);
    cartBloc.add(MyCartInitialEvent());
    updatedProducts = [];
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
            final listOfProducts = state.products;

            //calculate total
            double totalAmount = listOfProducts.fold<double>(
              0,
              (previousValue, product) =>
                  previousValue +
                  (double.parse(product.price) * product.selectedQuantity + 50),
            );

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
                                // listOfProducts[index].quantity++;
                                updatedProducts = listOfProducts;
                              });
                            },
                            decreaseQuantity: () {
                              setState(() {
                                // if (listOfProducts[index].quantity > 1) {
                                //   listOfProducts[index].quantity--;
                                //   updatedProducts = listOfProducts;
                                // }
                              });
                            },
                            deleteItem: () {
                              _showDeleteConfirmationDialog(
                                  listOfProducts[index]);
                            },
                          );
                        },
                      ),
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
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delivery Charge: रु50'),
                            Text('Total Amount: रु${totalAmount}'),
                          ],
                        ),
                      ), // Display total amount
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the DeliveryAddressScreen and pass product details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeliveryAddressScreen(
                                product_detail_name:
                                    listOfProducts.first.productName,
                                product_detail_picture:
                                    listOfProducts.first.imageUrl,
                                product_detail_price:
                                    listOfProducts.first.price,
                              ),
                            ),
                          );
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

  void _showDeleteConfirmationDialog(CartItemModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                cartBloc.add(DeleteItemEvent(item));
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // IconButton(
                      //   onPressed: decreaseQuantity,
                      //   icon: const Icon(Icons.remove),
                      // ),
                      Text(
                        'Qty=${product.selectedQuantity}',
                        // Display the current count from the database
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      // IconButton(
                      //   onPressed: increaseQuantity,
                      //   icon: const Icon(Icons.add),
                      // ),
                    ],
                  ),
                  IconButton(
                    alignment: Alignment.topRight,
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
