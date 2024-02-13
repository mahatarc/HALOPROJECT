part of 'home_bloc.dart';

abstract class HomePageEvent {}

class HomePageInitialEvent extends HomePageEvent {}

class HomeIconPressedEvent extends HomePageEvent {}

class NewsFeedIconPressedEvent extends HomePageEvent {}

class CartIconPressedEvent extends HomePageEvent {}

class DrawerPressedEvent extends HomePageEvent {}

class CategoriesPressedEvent extends HomePageEvent {}

class CategoryTypePressedEvent extends HomePageEvent {
  final String categoryType;

  CategoryTypePressedEvent({required this.categoryType});
}
