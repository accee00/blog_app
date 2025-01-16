import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/data/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImplementation implements AuthRemoteDataSource {
  // injecting supabase client over here.
  final SupabaseClient client;
  AuthRemoteDataSourceImplementation({required this.client});
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
}
