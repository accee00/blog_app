import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/reaction.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddReaction implements Usecase<Reaction, Reaction> {
  final BlogRepository repository;
  AddReaction(this.repository);

  @override
  Future<Either<Failure, Reaction>> call(Reaction params) {
    return repository.addReaction(params);
  }
}
