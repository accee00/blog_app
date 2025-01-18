import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/entities/user.dart';
import 'package:blog_app/features/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class CurrentUser implements Usecase<User, Noparams> {
  final AuthRepository repository;
  CurrentUser(this.repository);
  @override
  Future<Either<Failure, User>> call(parameter) async {
    return await repository.getCurrentUser();
  }
}

class Noparams {}
