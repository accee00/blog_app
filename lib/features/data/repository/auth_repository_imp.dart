import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/data/datasource/auth_remote_data_source.dart';
import 'package:blog_app/features/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImplementation implements AuthRepository {
  // calls function from Auth Remote datasource
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImplementation(this.remoteDataSource);
  @override
  Future<Either<Failure, String>> logInWithEmailPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement logInWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userId = await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      // right means this is a success and here is my userId.
      return right(userId);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }
}
