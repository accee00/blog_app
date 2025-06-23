import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/reaction.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetReactionsByPostId implements Usecase<List<Reaction>, String> {
  final BlogRepository repository;
  GetReactionsByPostId(this.repository);

  @override
  Future<Either<Failure, List<Reaction>>> call(String postId) {
    return repository.getReactionsByPostId(postId);
  }
}
