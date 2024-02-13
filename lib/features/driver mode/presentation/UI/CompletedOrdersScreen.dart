import 'package:flutter/material.dart';


class CompletedOrdersPage extends StatelessWidget {
  final List<Order> completedOrders = [
    Order("Order #001", "Axe, Sickle", "2024-01-15"),
    Order("Order #002", "Hoe, ", "2024-01-18"),
    Order("Order #003", "Shovel, Sickle", "2024-01-20"),
    Order("Order #004", "Sprayer, Hoe", "2024-02-01"),
    Order("Order #005", "Hoe, Product J", "2024-02-03"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Orders'),
      ),
      body: ListView.builder(
        itemCount: completedOrders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(completedOrders[index].orderNumber),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Products: ${completedOrders[index].productNames}'),
                Text('Completed on: ${completedOrders[index].completionDate}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Order {
  final String orderNumber;
  final String productNames;
  final String completionDate;

  Order(this.orderNumber, this.productNames, this.completionDate);
}
