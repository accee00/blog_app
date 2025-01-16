// abstract interface forces sub class to must implement the Parent class functions.
import 'package:blog_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  // Either if it is a success return User
  // if failure return Failuer
  Future<Either<Failure, String>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, String>> logInWithEmailPassword({
    required String email,
    required String password,
  });
}
