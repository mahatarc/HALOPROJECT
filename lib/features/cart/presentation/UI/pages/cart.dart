import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [
    CartItem("Sprayer", "images/sprayer.jpg", 1, 100.0),
    CartItem("Garden Fork", "images/gardenfork.webp", 2, 150.0),
    CartItem("Shovel", "images/shovel.jpg", 3, 200.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Text('My Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return buildCartItem(cartItems[index]);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: \रु${calculateTotal()}'),
              Text('Delivery Charge: रु50'),
              ElevatedButton(
                onPressed: () {
                  // Implement your checkout logic here
                  // This is just a placeholder
                  print('Checkout pressed');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 156, 199, 107), // Set the button color to green
                ),
                child: Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build each item in the cart
  Widget buildCartItem(CartItem item) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        // Leading section with image and delete icon
        leading: Stack(
          children: [
            Image.asset(
              item.image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            /* Positioned(
              top: 0,
              right:10,
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Remove the item when delete icon is pressed
                  setState(() {
                    cartItems.remove(item);
                  });
                },
              ),
            ),*/
          ],
        ),
        title: Text(item.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quantity control section with +/- buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    // Decrease quantity when the '-' button is pressed
                    setState(() {
                      if (item.quantity > 1) {
                        item.quantity--;
                      }
                    });
                  },
                ),
                Text(item.quantity.toString()),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // Increase quantity when the '+' button is pressed
                    setState(() {
                      item.quantity++;
                    });
                  },
                ),
              ],
            ),
            // Display the price of the item
            Text('Price: \रु${item.price}'),
          ],
        ),
      ),
    );
  }

  // Calculate and return the total price of all items in the cart
  double calculateTotal() {
    double total = 0.0;
    for (var item in cartItems) {
      total += item.quantity * item.price;
    }
    total += 50;
    return total;
  }
}

// Class to represent an item in the cart
class CartItem {
  final String name;
  final String image;
  int quantity;
  final double price;

  CartItem(this.name, this.image, this.quantity, this.price);
}
