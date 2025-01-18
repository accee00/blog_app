// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

// initial state of app that means user is [logged out]
final class AppUserInitial extends AppUserState {}

class AppUserLoggedIn extends AppUserState {
  final User user;
  AppUserLoggedIn({
    required this.user,
  });
}
//core cannot depend on other feature
//but other features can depend on core.
