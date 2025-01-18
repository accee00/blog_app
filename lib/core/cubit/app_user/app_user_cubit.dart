import 'package:bloc/bloc.dart';
import 'package:blog_app/core/entities/user.dart';

import 'package:flutter/material.dart';

part 'app_user_state.dart';

// In cubit we can directly call the function
class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user) {
    if (user == null) {
      emit(AppUserInitial());
    } else {
      emit(AppUserLoggedIn(user: user));
    }
  }
}
