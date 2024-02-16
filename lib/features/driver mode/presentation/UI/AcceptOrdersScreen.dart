import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptedOrdersPage extends StatefulWidget {
  @override
  _AcceptedOrdersPageState createState() => _AcceptedOrdersPageState();
}

class _AcceptedOrdersPageState extends State<AcceptedOrdersPage> {
  final List<Order> acceptedOrders = [
    Order("Order #1", "Product A", "2022-03-01", "123 Street, City A"),
    Order("Order #2", "Product B", "2022-03-02", "456 Street, City B"),
    Order("Order #3", "Product C", "2022-03-03", "789 Street, City C"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accepted Orders'),
        backgroundColor: Colors.green[100],
      ),
      body: Container(
        // color: Color.fromARGB(255, 211, 245, 172),
        child: ListView.builder(
          itemCount: acceptedOrders.length,
          itemBuilder: (context, index) {
            return Container(
              child: ListTile(
                title: Text(acceptedOrders[index].orderNumber),
                subtitle: Text('Product: ${acceptedOrders[index].productName}'),
                onTap: () {
                  _navigateToOrderDetails(context, acceptedOrders[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToOrderDetails(BuildContext context, Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(order),
      ),
    );
  }
}

class Order {
  final String orderNumber;
  final String productName;
  final String orderDate;
  final String deliveryLocation;

  Order(this.orderNumber, this.productName, this.orderDate,
      this.deliveryLocation);
}

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  OrderDetailsScreen(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: Colors.green[100],
      ),
      // backgroundColor: Color.fromARGB(255, 211, 245, 172),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Number: ${order.orderNumber}'),
            Text('Product: ${order.productName}'),
            Text('Order Date: ${order.orderDate}'),
            GestureDetector(
              onTap: () {
                _openMap(order.deliveryLocation);
              },
              child: Text(
                'Delivery Location: ${order.deliveryLocation}',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openMap(String location) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$location';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
