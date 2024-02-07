part of 'home_bloc.dart';

abstract class HomePageState {}

class HomePageInitialState extends HomePageState {}

class HomePageActionState extends HomePageState {}

class HomeToNewsFeedNavigateState extends HomePageActionState {}

class HomeToCartNavigateState extends HomePageActionState {}

class HomeToDrawerNavigateState extends HomePageActionState{}

class HomeToCategoriesNavigateState extends HomePageActionState{}
