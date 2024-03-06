import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/cart/models/cart_model.dart';
part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(MyCartInitialState()) {
    on<MyCartInitialEvent>(myCartInitialEvent);
    on<CheckOutPressedEvent>(checkOutPressedEvent);
    on<IncreaseQuantityEvent>(increaseQuantityEvent);
    on<DecreaseQuantityEvent>(decreaseQuantityEvent);
    on<DeleteItemEvent>(deleteItemEvent);
  }

  Future<void> myCartInitialEvent(
    MyCartInitialEvent event,
    Emitter<CartState> emit,
  ) async {
    print('Fetching cart data from Firestore...');
    emit(MyCartLoadingState());
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      List<CartItemModel> cartItems = [];
      List<String> productIDList = [];

      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('carts')
          .doc(userId)
          .collection(userId)
          .get();
      if (cartSnapshot == null) {
        print('Error: No cart snapshot available');
        return;
      }
      cartSnapshot.docs.forEach((doc) {
        productIDList.add(doc.id);
      });

      print('Retrieved ${productIDList.length} products from Firestore');

      List<DocumentSnapshot> documentSnapshot = [];
      for (var item in productIDList) {
        final singleItem = await FirebaseFirestore.instance
            .collection('products')
            .doc(item)
            .get();
        print(singleItem.data());
        if (singleItem != null) {
          documentSnapshot.add(singleItem);
        }
      }

      print('Retrieved details for ${documentSnapshot.length} products');

      for (var item in documentSnapshot) {
        final data = item.data();
        if (data != null) {
          cartItems.add(CartItemModel.fromJson(data as Map<String, dynamic>));
        }
      }

      print('Converted Firestore data to CartItemModel');

      for (int i = 0; i < productIDList.length; i++) {
        cartItems[i].productId = productIDList[i];
      }
      print(cartItems.first.productId);
      emit(MyCartLoadedState(cartItems));

      print('Cart data loaded successfully');
    } catch (e) {
      print('Error getting cart: $e');
    }
  }

  Future<void> checkOutPressedEvent(
    CheckOutPressedEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CheckoutPressedState());
  }

  Future<void> increaseQuantityEvent(
    IncreaseQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state is MyCartLoadedState) {
        final List<CartItemModel> updatedCartItems =
            List<CartItemModel>.from((state as MyCartLoadedState).products);

        final index = updatedCartItems.indexOf(event.item);

        if (index != -1) {
          //  updatedCartItems[index].quantity++;
          emit(MyCartLoadedState(updatedCartItems));
        }
      }
    } catch (e) {
      print('Error increasing quantity: $e');
    }
  }

  Future<void> decreaseQuantityEvent(
    DecreaseQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state is MyCartLoadedState) {
        final List<CartItemModel> updatedCartItems =
            List<CartItemModel>.from((state as MyCartLoadedState).products);

        final index = updatedCartItems.indexOf(event.item);

        // if (index != -1 && updatedCartItems[index].quantity > 1) {
        //   updatedCartItems[index].quantity--;
        emit(MyCartLoadedState(updatedCartItems));
        // }
      }
    } catch (e) {
      print('Error decreasing quantity: $e');
    }
  }

  Future<void> deleteItemEvent(
    DeleteItemEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state is MyCartLoadedState) {
        final List<CartItemModel> updatedCartItems =
            List<CartItemModel>.from((state as MyCartLoadedState).products);
        print('..............................................');
        print(event.item.productId);
        // Find the index of the item to delete
        final index = updatedCartItems.indexWhere((item) {
          // print(item.productId);
          // print(event.item.productId);
          return item.productId == event.item.productId;
        });
        print(index);
        print(
            '.....................................................................');
        if (index != -1) {
          // Remove the item at the found index
          updatedCartItems.removeAt(index);

          // Update Firestore with the new list of items
          await updateFirestoreCart(updatedCartItems);

          emit(MyCartLoadedState(updatedCartItems)); // Update the state
        } else {
          print('Item to delete not found in cart');
        }
      }
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  Future<void> updateFirestoreCart(List<CartItemModel> cartItems) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final cartRef = FirebaseFirestore.instance
          .collection('carts')
          .doc(userId)
          .collection(userId);

      // Get the list of product IDs for the items to be removed
      final List<String?> productIdsInCart =
          cartItems.map((item) => item.productId).toList();

      // Get all documents in the cart collection
      final snapshot = await cartRef.get();

      // Iterate through each document
      for (DocumentSnapshot doc in snapshot.docs) {
        // Check if the product ID of the current document is in the updated cart
        if (!productIdsInCart.contains(doc.id)) {
          // If the product ID is not in the updated cart, delete the document
          await doc.reference.delete();
        }
      }

      // Add or update the cart items in Firestore
      for (var item in cartItems) {
        // Create a new map containing only the necessary fields for updating the document
        Map<String, dynamic> data = {
          'productId': item.productId,
          'name': item.productName,
          'image_url': item.imageUrl,
          'price': item.price,
          'selectedQuantity': item.selectedQuantity,

          // Use the selected quantity instead of the default quantity
        };
        print(cartItems.first.selectedQuantity);
        print('...................................................................');

        // Set the data in Firestore using the product ID as the document ID
        await cartRef.doc(item.productId).set(data);
      }

      print('Firestore cart updated successfully');
    } catch (e) {
      print('Error updating Firestore cart: $e');
    }
  }
}
