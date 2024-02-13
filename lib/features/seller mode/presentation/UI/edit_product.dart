import 'package:flutter/material.dart';

class EditProduct extends StatefulWidget {
  final edit_name;
  final edit_price;
  final edit_old_price;
  final edit_picture;

  EditProduct({
    this.edit_name,
    this.edit_price,
    this.edit_old_price,
    this.edit_picture,
  });

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController oldPriceController = TextEditingController();
  int myIndex = 0;
  int selectedQuantity = 1;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.edit_name;
    priceController.text = widget.edit_price.toString();
    oldPriceController.text = widget.edit_old_price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              height: 300,
              child: GridTile(
                child: Container(
                  color: Colors.white,
                  child: Image.asset(
                    widget.edit_picture,
                    fit: BoxFit.contain,
                  ),
                ),
                footer: Container(
                  color: Colors.white60,
                  child: ListTile(
                    title: TextField(
                      controller: nameController,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Product Name',
                      ),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Old Price',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              TextField(
                                controller: oldPriceController,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  decoration: TextDecoration.lineThrough,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Old Price',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              TextField(
                                controller: priceController,
                                style: TextStyle(
                                  color: Colors.brown,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Price',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Quantity selection row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text("Quantity")),
                        DropdownButton<int>(
                          value: selectedQuantity,
                          items: List.generate(10, (index) => index + 1)
                              .map((quantity) => DropdownMenuItem<int>(
                                    value: quantity,
                                    child: Text('$quantity'),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedQuantity = value ?? 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Product description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Product Description:\nThis is a high-quality product with a detailed description.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            // Customer Reviews
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer Reviews',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  ListTile(
                    title: Text('Alpha'),
                    subtitle: Text('Excellent product!'),
                    trailing: Icon(Icons.star, color: Colors.yellow),
                  ),
                  ListTile(
                    title: Text('Beta'),
                    subtitle: Text('Very satisfied with the purchase.'),
                    trailing: Icon(Icons.star, color: Colors.yellow),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    oldPriceController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: EditProduct(
      edit_name: 'Product Name',
      edit_price: 20.0,
      edit_old_price: 25.0,
      edit_picture: 'assets/product_image.jpg',
    ),
  ));
}
