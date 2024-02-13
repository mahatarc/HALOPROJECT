import 'package:flutter/material.dart';

class Order extends StatelessWidget {
  const Order({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Text('Orders'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: List.generate(
              20,
              (index) => Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 160, 235, 162),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  onTap: () {
                    // Handle tap on the order item, e.g., navigate to order details page
                    print('Tapped on Order ID: Order$index');
                  },
                  title: Text('Product Title'),
                  subtitle: Text('\$40'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


/*class OrderList extends StatelessWidget {
  final List<OrderData> orders = [
    OrderData(
        id: '1',
        customerName: 'John Doe',
        productName: 'Product A',
        amount: 50.0),
    OrderData(
        id: '2',
        customerName: 'Jane Doe',
        productName: 'Product B',
        amount: 30.0),
    // Add more orders as needed
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Order ID: ${orders[index].id}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer: ${orders[index].customerName}'),
              Text('Product: ${orders[index].productName}'),
              Text('Amount: \$${orders[index].amount.toString()}'),
            ],
          ),
          onTap: () {
            print('Tapped on Order ID: ${orders[index].id}');
          },
        );
      },
    );
  }
}

class OrderData {
  final String id;
  final String customerName;
  final String productName;
  final double amount;

  OrderData({
    required this.id,
    required this.customerName,
    required this.productName,
    required this.amount,
  });
}*/
