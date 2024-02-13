part of 'add_products_bloc.dart';

abstract class AddProductsEvent {}

class AddProductInitialEvent extends AddProductsEvent {}

class AddProductsButtonPressedEvent extends AddProductsEvent {
  final TextEditingController name;
  final TextEditingController price;
  File image;
  final String categorytype;
  final TextEditingController details;

  AddProductsButtonPressedEvent({
    required this.name,
    required this.price,
    required this.image,
    String? imagePath,
    required this.categorytype,
    required this.details,
  });
}
