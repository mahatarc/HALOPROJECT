part of 'sign_in_bloc.dart';

abstract class SignInStates {}

class SignInActionState extends SignInStates {}

class SignInInitialState extends SignInStates {}

class SignInLoadingState extends SignInStates {}

class SignInNavigateToBuyerHomePageActionState extends SignInActionState {}

class SignInNavigateToSellerHomePageActionState extends SignInActionState {}

class SignUpPressedNavigateToSignUpActionState extends SignInActionState {}

class SignInErrorState extends SignInStates {}

class SignInLoadedState extends SignInStates{}
