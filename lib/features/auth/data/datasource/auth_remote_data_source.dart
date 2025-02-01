import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/auth/data/model/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModel?> getCurrentUserData();
  Future<Unit> logOutCurrentUser();
}

class AuthRemoteDataSourceImplementation implements AuthRemoteDataSource {
  // injecting supabase client over here.
  final SupabaseClient client;
  AuthRemoteDataSourceImplementation({required this.client});

  @override
  Session? get currentUserSession => client.auth.currentSession;

  @override
  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw ServerExceptions("User in null");
      }
      return UserModel.fromJason(response.user!.toJson());
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response =
          await client.auth.signUp(password: password, email: email, data: {
        'name': name,
      });
      if (response.user == null) {
        throw ServerExceptions("User in null");
      }
      return UserModel.fromJason(
        response.user!.toJson(),
      );
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        /// I want data from profiles table select all column.
        /// Get user id that is equal to current user id.
        final userData = await client.from('profiles').select().eq(
              'id',
              currentUserSession!.user.id,
            );
        return UserModel.fromJason(userData.first).copyWith(
          email: currentUserSession!.user.email,
        );
      }
      return null;
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<Unit> logOutCurrentUser() async {
    try {
      await client.auth.signOut();
      return unit;
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
