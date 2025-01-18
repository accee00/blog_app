// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blog_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp userSignUp;
  final UserSignIn userSignIn;
  final CurrentUser currentUser;
  final AppUserCubit appUserCubit;
  AuthBloc({
    required this.userSignIn,
    required this.userSignUp,
    required this.currentUser,
    required this.appUserCubit,
  }) : super(AuthInitial()) {
    on<AuthSignUp>(_signUp);
    on<AuthSignIn>(_signIn);
    on<AuthIsUserLoggedIn>(_getCurrentUser);
  }

  void _getCurrentUser(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await currentUser(Noparams());
    res.fold(
      (l) => AuthFailure(l.message),
      (user) {
        print(user.email);
        appUserCubit.updateUser(user);
        emit(AuthSuccess(user));
      },
    );
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
      (user) {
        appUserCubit.updateUser(user);
        emit(
          AuthSuccess(user),
        );
      },
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
      (user) {
        appUserCubit.updateUser(user);
        emit(
          AuthSuccess(
            user,
          ),
        );
      },
    );
  }
}
