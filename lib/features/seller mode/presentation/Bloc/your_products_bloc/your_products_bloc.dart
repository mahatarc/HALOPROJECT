import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/seller%20mode/model/productmodel.dart';

part 'your_products_events.dart';
part 'your_products_states.dart';

class YourProductsBloc extends Bloc<YourProductsEvents, YourProductsState> {
  YourProductsBloc() : super(YourProductsInitialState()) {
    on<YourProductsInitialEvent>(yourProductsInitialEvent);
  }

  FutureOr<void> yourProductsInitialEvent(
      YourProductsInitialEvent event, Emitter<YourProductsState> emit) async {
    emit(YourProductsLoadingState());

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      List<ProductModel> productModelList =
          []; // querysnapshop==collection of documents in firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('user_id', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> products = [];
      querySnapshot.docs.forEach((document) {
        //converts every docs to map string dynamic and made a list of map string dynamic
        products.add(document.data() as Map<String, dynamic>);
      });

      for (var productData in products) {
        ProductModel productModel =
            ProductModel.fromMap(productData); //productdata==map string dynamic
        print(productModel); //product model=object
        productModelList.add(productModel); //added object to list
      }
      print(productModelList);
      print('successful');
      emit(YourProductsLoadedState(productModelList));
    } catch (e) {
      print('Error getting products: $e');
    }
  }
}
