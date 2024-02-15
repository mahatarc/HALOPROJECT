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
  }

  Future<void> myCartInitialEvent(
      MyCartInitialEvent event, Emitter<CartState> emit) async {
    emit(MyCartLoadingState());
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      print(userId);
      List<CartItemModel> cartItems = [];
      List<String> productIDList = [];

      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('carts')
          .doc(userId)
          .collection(userId)
          .get();
      print('hello');
      //retrieved product Id
      cartSnapshot.docs.forEach((doc) {
        productIDList.add(doc.id);
        print('Retrieved item');
        print(productIDList);
      });
      List<DocumentSnapshot> documentSnapshot = [];
      for (var item in productIDList) {
        final singleItem = await FirebaseFirestore.instance
            .collection('products')
            .doc(item)
            .get();
        documentSnapshot.add(singleItem);
      }

      for (var item in documentSnapshot) {
        // cartItems
        // .add(CartItemModel.fromJson(item.data() as Map<String, dynamic>));
        for (var item in documentSnapshot) {
          final data = item.data();
          if (data != null) {
            cartItems.add(CartItemModel.fromJson(data as Map<String, dynamic>));
            print('Successful');
          } else {
            print('Item data is null');
          }
        }

        print('Successful');
      }
      print(cartItems.first.productName);
      emit(MyCartLoadedState(cartItems));
    } catch (e) {
      print('Error getting cart: $e');
    }
  }

  Future<void> checkOutPressedEvent(
      CheckOutPressedEvent event, Emitter<CartState> emit) async {
    emit(CheckoutPressedState());
  }
}
