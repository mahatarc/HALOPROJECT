part of 'your_products_bloc.dart';

abstract class YourProductsState {}

class YourProductsInitialState extends YourProductsState {}

class YourProductsLoadingState extends YourProductsState {}

class YourProductsLoadedState extends YourProductsState {
  final List<ProductModel> products;

  YourProductsLoadedState(this.products);

  
}
