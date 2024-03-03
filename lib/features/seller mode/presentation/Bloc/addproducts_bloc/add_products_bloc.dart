import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'add_products_event.dart';
part 'add_products_state.dart';

class AddProductsBloc extends Bloc<AddProductsEvent, AddProductsStates> {
  AddProductsBloc() : super(AddProductInitialState()) {
    on<AddProductInitialEvent>(addProductInitialEvent);

    on<AddProductsButtonPressedEvent>(addProductsButtonPressedEvent);
  }

  FutureOr<void> addProductInitialEvent(
      AddProductInitialEvent event, Emitter<AddProductsStates> emit) {
    emit(AddProductInitialState());
  }

  FutureOr<void> addProductsButtonPressedEvent(
      AddProductsButtonPressedEvent event,
      Emitter<AddProductsStates> emit) async {
    try {
      {
        // Validate and parse product price
        double price = double.tryParse(event.price.text) ?? 0.0;
        if (price <= 0) {
          emit(AddProductErrorState());
        }

        // Upload image to Firebase Storage
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('product_images/${DateTime.now().millisecondsSinceEpoch}');
        UploadTask uploadTask = ref.putFile(event.image);
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        // Add product data to Firestore
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          return;
        }
        DocumentReference newProductRef =
            await FirebaseFirestore.instance.collection('products').add({
          'name': event.name.text,
          'price': event.price.text,
          'image_url': imageUrl,
          'product_details': event.details.text,
          'category_type': event.categorytype,
          'user_id': user.uid, // Store the user ID who added the product
        });

        // Get the seller's information
        final sellerDoc = await FirebaseFirestore.instance
            .collection('sellers')
            .doc(user
                .uid) // Assuming the seller's document ID is the same as their user ID
            .get();

        if (sellerDoc.exists) {
          // Store the seller's information with the product
          await newProductRef.update({
            'seller': sellerDoc.data(),
          });
        } else {
          print('Seller document does not exist.');
        }

        String productId = newProductRef.id;
        print('Successful');
        print(productId);
      }
    } catch (e) {
      print('Error uploading product: $e');
    }

    emit(AddProductInitialState());
  }
}
