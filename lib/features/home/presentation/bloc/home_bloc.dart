import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageInitialState()) {
    on<HomePageInitialEvent>(homePageInitialEvent);
    on<HomeIconPressedEvent>(homeIconPressedEvent);
    on<NewsFeedIconPressedEvent>(newsFeedIconPressedEvent);
    on<CartIconPressedEvent>(cartIconPressedEvent);
    on<DrawerPressedEvent>(drawerPressedEvent);
    on<CategoriesPressedEvent>(categoriesPressedEvent);
  }

  FutureOr<void> homePageInitialEvent(
      HomePageInitialEvent event, Emitter<HomePageState> emit) {
    emit(HomePageInitialState());
  }

  FutureOr<void> homeIconPressedEvent(
      HomeIconPressedEvent event, Emitter<HomePageState> emit) {
    emit(HomePageInitialState());
  }

  FutureOr<void> newsFeedIconPressedEvent(
      NewsFeedIconPressedEvent event, Emitter<HomePageState> emit) {
    emit(HomeToNewsFeedNavigateState());
  }

  FutureOr<void> cartIconPressedEvent(
      CartIconPressedEvent event, Emitter<HomePageState> emit) {
    emit(HomeToCartNavigateState());
  }

  FutureOr<void> drawerPressedEvent(
      DrawerPressedEvent event, Emitter<HomePageState> emit) {
    emit(HomeToDrawerNavigateState());
  }

  FutureOr<void> categoriesPressedEvent(
      CategoriesPressedEvent event, Emitter<HomePageState> emit) {
    emit(HomeToCategoriesNavigateState());
  }
}
