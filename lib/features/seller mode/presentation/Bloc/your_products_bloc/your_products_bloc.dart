import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'your_products_events.dart';
part 'your_products_states.dart';

class YourProductsBloc extends Bloc<YourProductsEvents, YourProductsState> {
  YourProductsBloc() : super(YourProductsInitialState()) {
    on<YourProductsInitialEvent>(yourProductsInitialEvent);
  }

  FutureOr<void> yourProductsInitialEvent(
      YourProductsInitialEvent event, Emitter<YourProductsState> emit) {
    emit(YourProductsInitialState());
  }
}
