part of 'category_bloc.dart';

abstract class CategoryState {}

class CategoryLoadingState extends CategoryState{}

class CategoryLoadedState extends CategoryState{}

class CategoryInitialState extends CategoryState {}

class CategoryActionState extends CategoryState {}

class CategoryTypeSeedPressedNavigateState extends CategoryActionState {}

class CategoryTypePlantPressedNavigateState extends CategoryActionState {}

class CategoryTypeToolsPressedNavigateState extends CategoryActionState{}


