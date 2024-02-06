part of 'sign_up_bloc.dart';

abstract class SignUpState {}

class SignUpActionState extends SignUpState {}

class SignUpInitialState extends SignUpState {}

class SignUpLoadingState extends SignUpState {}

class SignUpNavigateToHomePageActionState extends SignUpActionState {}

class LoginPressedNavigateToLoginActionState extends SignUpActionState {}

class SignUpErrorState extends SignUpState {}
