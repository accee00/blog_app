// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:blog_app/features/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp userSignUp;

  AuthBloc({
    required this.userSignUp,
  }) : super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      final response = await userSignUp.call(
        UserSignupParameter(
            name: event.name, email: event.email, password: event.password),
      );
      response.fold(
        (l) => emit(
          AuthFailure(l.message),
        ),
        (f) => emit(
          AuthSuccess(f),
        ),
      );
    });
  }
}
