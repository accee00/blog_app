// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blog_app/features/domain/entities/user.dart';
import 'package:blog_app/features/domain/usecases/user_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:blog_app/features/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp userSignUp;
  final UserSignIn userSignIn;
  AuthBloc({
    required this.userSignIn,
    required this.userSignUp,
  }) : super(AuthInitial()) {
    on<AuthSignUp>(_signUp);
    on<AuthSignIn>(_signIn);
  }
  void _signUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await userSignUp.call(
      UserSignupParameter(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    response.fold(
      (l) => emit(
        AuthFailure(l.message),
      ),
      (user) => emit(
        AuthSuccess(user),
      ),
    );
  }

  void _signIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await userSignIn.call(
      UserSignInParameter(email: event.email, password: event.password),
    );
    response.fold(
      (fail) => emit(
        AuthFailure(fail.message),
      ),
      (user) => emit(
        AuthSuccess(
          user,
        ),
      ),
    );
  }
}
