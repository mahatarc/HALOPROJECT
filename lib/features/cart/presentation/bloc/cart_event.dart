part of 'cart_bloc.dart';

abstract class CartEvent {}

class MyCartInitialEvent extends CartEvent {
}

class CheckOutPressedEvent extends CartEvent {}
