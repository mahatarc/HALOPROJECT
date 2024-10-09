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
  int? selectedIndex;

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
                  (double.parse(product.price) * product.selectedQuantity),
            );

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green[100],
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
                            isSelected: selectedIndex == index,
                            onTap: () {
                              setState(() {
                                selectedIndex =
                                    selectedIndex == index ? null : index;
                              });
                            },
                            increaseQuantity: () {
                              setState(() {
                                updatedProducts = listOfProducts;
                              });
                            },
                            decreaseQuantity: () {
                              setState(() {
                                updatedProducts = listOfProducts;
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
                            Text(
                              'Delivery Charge: रु50',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              selectedIndex != null
                                  ? 'Total Amount: रु${listOfProducts[selectedIndex!].price}'
                                  : 'Total Amount: रु${totalAmount + 50}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ), // Display total amount
                      ElevatedButton(
                        onPressed: () {
                          if (selectedIndex != null) {
                            final selectedProduct =
                                listOfProducts[selectedIndex!];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeliveryAddressScreen(
                                  product_detail_name:
                                      selectedProduct.productName,
                                  product_detail_picture:
                                      selectedProduct.imageUrl,
                                  product_detail_price:
                                      (double.parse(selectedProduct.price) + 50)
                                          .toString(),
                                ),
                              ),
                            );
                          } else {
                            // Handle case where no item is selected
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[200],
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(color: Colors.white),
                        ),
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
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                cartBloc.add(DeleteItemEvent(item));
                Navigator.of(context).pop();
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CartProduct extends StatefulWidget {
  final CartItemModel product;
  final VoidCallback increaseQuantity;
  final VoidCallback decreaseQuantity;
  final VoidCallback deleteItem;
  final bool isSelected;
  final VoidCallback onTap;

  const CartProduct({
    required this.product,
    required this.increaseQuantity,
    required this.decreaseQuantity,
    required this.deleteItem,
    required this.isSelected,
    required this.onTap,
  });

  @override
  _CartProductState createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        children: [
          ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: widget.isSelected,
                  onChanged: (newValue) {
                    setState(() {
                      if (newValue == true) {
                        // If the checkbox is checked
                        widget.onTap();
                      } else {
                        // If the checkbox is unchecked
                        if (widget.isSelected) {
                          // Deselect the item
                          widget.onTap();
                        }
                      }
                    });
                  },
                ),
                SizedBox(
                  width: 80.0,
                  height: 80.0,
                  child: Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            title: Text(
              widget.product.productName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "रु${widget.product.price}",
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
                        // Text(
                        //   'Qty=${widget.product.selectedQuantity}',
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //   ),
                        // ),
                      ],
                    ),
                    IconButton(
                      alignment: Alignment.topRight,
                      onPressed: widget.deleteItem,
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
