part of 'sign_in_bloc.dart';

abstract class SignInStates {}

class SignInActionState extends SignInStates {}

class SignInInitialState extends SignInStates {}

class SignInLoadingState extends SignInStates {}

class SignInNavigateToBuyerHomePageActionState extends SignInActionState {}

class SignInNavigateToSellerHomePageActionState extends SignInActionState {}

class SignInNavigateToDriverHomePageActionState extends SignInActionState {}

class SignUpPressedNavigateToSignUpActionState extends SignInActionState {}

class SignInLoadedState extends SignInStates {}

class SignInErrorState extends SignInStates {
  final String errorMessage;
  final String errorCode;

  SignInErrorState(this.errorCode,this.errorMessage);
}
