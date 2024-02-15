part of 'cart_bloc.dart';

abstract class CartState {}

class MyCartInitialState extends CartState {}

class MyCartLoadingState extends CartState {}

class MyCartLoadedState extends CartState {
final List<CartItemModel> products;

 MyCartLoadedState(this.products);
}

class CheckoutPressedState extends CartState{}
