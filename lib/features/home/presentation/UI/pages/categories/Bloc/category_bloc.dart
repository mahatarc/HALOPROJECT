import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitialState()) {
    on<CategoryInitialEvent>(categoryInitialEvent);
    on<CategoryTypeSeedPressedEvent>(categoryTypeSeedPressedEvent);
    on<CategoryTypePlantPressedEvent>(categoryTypePlantPressedEvent);
    on<CategoryTypeToolsPressedEvent>(categoryTypeToolsPressedEvent);
  }
  FutureOr<void> categoryInitialEvent(
      CategoryInitialEvent event, Emitter<CategoryState> emit) {
    emit(CategoryInitialState());
  }

  FutureOr<void> categoryTypeSeedPressedEvent(
      CategoryTypeSeedPressedEvent event, Emitter<CategoryState> emit) {
    emit(CategoryTypeSeedPressedNavigateState());
  }

  FutureOr<void> categoryTypePlantPressedEvent(
      CategoryTypePlantPressedEvent event, Emitter<CategoryState> emit) {
    emit(CategoryTypePlantPressedNavigateState());
  }

  FutureOr<void> categoryTypeToolsPressedEvent(
      CategoryTypeToolsPressedEvent event, Emitter<CategoryState> emit) {
    emit(CategoryTypeToolsPressedNavigateState());
  }
}
