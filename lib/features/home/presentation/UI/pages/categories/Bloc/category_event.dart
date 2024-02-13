part of 'category_bloc.dart';

abstract class CategoryEvent {}

class CategoryInitialEvent extends CategoryEvent {}


class CategoryTypeSeedPressedEvent extends CategoryEvent {}

class CategoryTypePlantPressedEvent extends CategoryEvent {}

class CategoryTypeToolsPressedEvent extends CategoryEvent {}
