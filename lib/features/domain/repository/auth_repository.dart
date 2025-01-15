import 'package:blog_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  // All methods in an interface class must be implemented
  // explicitly by the implementing class.
  Future<Either<Failure, String>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  });
  Future<Either<Failure, String>> logInWithEmailPassword({
    required String email,
    required String password,
  });
}
