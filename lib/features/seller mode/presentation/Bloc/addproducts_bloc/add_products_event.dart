part of 'add_products_bloc.dart';

abstract class AddProductsEvent {}

class AddProductInitialEvent extends AddProductsEvent {}

class AddProductsButtonPressedEvent extends AddProductsEvent {
  final TextEditingController name;
  final TextEditingController price;
   File image;

  AddProductsButtonPressedEvent({
    required this.name,
    required this.price,
    required this.image,
  });
}
