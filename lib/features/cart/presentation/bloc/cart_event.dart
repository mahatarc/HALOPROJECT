part of 'cart_bloc.dart';

abstract class CartEvent {}

class MyCartInitialEvent extends CartEvent {}

class CheckOutPressedEvent extends CartEvent {}

class IncreaseQuantityEvent extends CartEvent {
  final CartItemModel item;

  IncreaseQuantityEvent(this.item);
}

class DecreaseQuantityEvent extends CartEvent {
  final CartItemModel item;

  DecreaseQuantityEvent(this.item);
}

class DeleteItemEvent extends CartEvent {
  final CartItemModel item;

  DeleteItemEvent(this.item);
}
