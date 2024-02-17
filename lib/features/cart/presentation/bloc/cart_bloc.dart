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
        documentSnapshot.add(singleItem);
      }

      print('Retrieved details for ${documentSnapshot.length} products');

      for (var item in documentSnapshot) {
        final data = item.data();
        if (data != null) {
          cartItems.add(CartItemModel.fromJson(data as Map<String, dynamic>));
        }
      }

      print('Converted Firestore data to CartItemModel');

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
          updatedCartItems[index].quantity++;
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

        if (index != -1 && updatedCartItems[index].quantity > 1) {
          updatedCartItems[index].quantity--;
          emit(MyCartLoadedState(updatedCartItems));
        }
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

        updatedCartItems.remove(event.item);

        emit(MyCartLoadedState(updatedCartItems));
      }
    } catch (e) {
      print('Error deleting item: $e');
    }
  }
}
