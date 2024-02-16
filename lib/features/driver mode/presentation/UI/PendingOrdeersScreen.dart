import 'package:flutter/material.dart';

class PendingOrdersPage extends StatefulWidget {
  @override
  _PendingOrdersPageState createState() => _PendingOrdersPageState();
}

class _PendingOrdersPageState extends State<PendingOrdersPage> {
  final List<Order> pendingOrders = [
    Order("Order #128", "Product K, Product L", "2022-02-20"),
    Order("Order #129", "Product M, Product N", "2022-02-21"),
    Order("Order #130", "Product O, Product P", "2022-02-22"),
    Order("Order #131", "Product Q, Product R", "2022-02-23"),
    Order("Order #132", "Product S, Product T", "2022-02-24"),
    Order("Order #133", "Product U, Product V", "2022-02-25"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Orders'),
        backgroundColor: Colors.green[100],
      ),
      body: Container(
        //  color: Color.fromARGB(255, 211, 245, 172),
        child: ListView.builder(
          itemCount: pendingOrders.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(pendingOrders[index].orderNumber),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Products: ${pendingOrders[index].productNames}'),
                  Text('Placed on: ${pendingOrders[index].placementDate}'),
                ],
              ),
              onTap: () {
                _showOrderOptions(context, pendingOrders[index]);
              },
            );
          },
        ),
      ),
    );
  }

  void _showOrderOptions(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Accept Order'),
              onTap: () {
                Navigator.pop(context); // Close the modal
                _acceptOrder(order);
              },
            ),
            ListTile(
              title: Text('Reject Order'),
              onTap: () {
                Navigator.pop(context); // Close the modal
                _rejectOrder(order);
              },
            ),
          ],
        );
      },
    );
  }

  void _acceptOrder(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcceptOrderScreen(order),
      ),
    );
  }

  void _rejectOrder(Order order) {
    setState(() {
      pendingOrders.remove(order);
    });
  }
}

class Order {
  final String orderNumber;
  final String productNames;
  final String placementDate;

  Order(this.orderNumber, this.productNames, this.placementDate);
}

class AcceptOrderScreen extends StatelessWidget {
  final Order order;

  AcceptOrderScreen(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accept Order'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Order Number: ${order.orderNumber}'),
            Text('Products: ${order.productNames}'),
            Text('Placed on: ${order.placementDate}'),
            // Add more details or actions as needed
          ],
        ),
      ),
    );
  }
}
