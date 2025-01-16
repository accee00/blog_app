import 'package:blog_app/core/error/exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<String> logInWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImplementation implements AuthRemoteDataSource {
  // injecting supabase client over here.
  final SupabaseClient client;
  AuthRemoteDataSourceImplementation({required this.client});
  @override
  Future<String> logInWithEmailPassword({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<String> signUpWithEmailPassword({
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
      return response.user!.id;
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
