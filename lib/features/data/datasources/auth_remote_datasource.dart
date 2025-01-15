import 'package:blog_app/core/error/exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDatasource {
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

class AuthRemoteDataSourcesImplementation implements AuthRemoteDatasource {
  final SupabaseClient client;
  AuthRemoteDataSourcesImplementation(this.client);
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
      final response = await client.auth.signUp(
        password: password,
        email: email,
        data: {'name': name},
      );
      if (response.user == null) {
        throw ServerExceptions('User is null');
      }
      return response.user!.id;
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
