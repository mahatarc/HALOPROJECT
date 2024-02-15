class CartService {
  // Define a list to store cart items
  List<CartItem> _cartItems = [];

  // Method to add an item to the cart
  void addToCart(
    String name,
    double price,
    String imageUrl,
    int quantity,
  ) {
    _cartItems.add(
      CartItem(
          name: name, price: price, imageUrl: imageUrl, quantity: quantity),
    );
  }

  // Getter method to retrieve the cart items
  List<CartItem> get cartItems => _cartItems;
}

// Define a class to represent an item in the cart
class CartItem {
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });
}
