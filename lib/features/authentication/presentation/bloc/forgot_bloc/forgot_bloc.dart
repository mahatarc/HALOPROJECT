import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'forgot_event.dart';
part 'forgot_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial());

  @override
  Stream<ForgotPasswordState> mapEventToState(
    ForgotPasswordEvent event,
  ) async* {
    if (event is ResetPasswordRequested) {
      yield* _mapResetPasswordRequestedToState(event);
    }
  }

  Stream<ForgotPasswordState> _mapResetPasswordRequestedToState(
      ResetPasswordRequested event) async* {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);
      yield PasswordResetSent();
    } catch (e) {
      yield ForgotPasswordError(errorMessage: 'Error resetting password: $e');
    }
  }
}
