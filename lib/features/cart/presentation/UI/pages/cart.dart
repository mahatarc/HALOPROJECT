import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/cart/presentation/bloc/cart_bloc.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartBloc cartBloc;

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
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MyCartLoadedState) {
            final listOfProducts = state.products;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green[200],
                title: Text('My Cart'),
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
                            productname: listOfProducts[index].productName,
                            productpicture: listOfProducts[index].imageUrl,
                            productprice: listOfProducts[index].price,
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
                      Text('Delivery Charge: रु50'),
                      ElevatedButton(
                        onPressed: () {
                          // Implement your checkout logic here
                          // This is just a placeholder
                          print('Checkout pressed');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 156, 199,
                              107), // Set the button color to green
                        ),
                        child: Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold();
          }
        },
      ),
    );
  }
}

// Calculate and return the total price of all items in the cart
// double calculateTotal() {
//   double total = 0.0;
//   for (var item in cartItems) {
//     total += item.quantity * item.price;
//   }
//   total += 50;
//   return total;
// }

class CartProduct extends StatelessWidget {
  final productname;
  final productpicture;
  final productprice;

  CartProduct({
    this.productname,
    this.productpicture,
    this.productprice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Image.network(
            productpicture,
            fit: BoxFit.contain,
            width: 80.0,
            height: 80.0,
          ),
          title: Text(
            productname,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "\रु$productprice",
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


 // bottomNavigationBar: BottomAppBar(
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(5.0),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         // Text('Total: \रु${calculateTotal()}'),
                      //         Text('Delivery Charge: रु50'),
                      //         ElevatedButton(
                      //           onPressed: () {
                      //             // Implement your checkout logic here
                      //             // This is just a placeholder
                      //             print('Checkout pressed');
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //             backgroundColor: const Color.fromARGB(255, 156,
                      //                 199, 107), // Set the button color to green
                      //           ),
                      //           child: Text('Checkout'),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),