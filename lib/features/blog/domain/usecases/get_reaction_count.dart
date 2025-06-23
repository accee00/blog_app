import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/reaction.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetReactionCounts implements Usecase<Map<ReactionType, int>, String> {
  final BlogRepository repository;
  GetReactionCounts(this.repository);

  @override
  Future<Either<Failure, Map<ReactionType, int>>> call(String postId) {
    return repository.getReactionCounts(postId);
  }
}
