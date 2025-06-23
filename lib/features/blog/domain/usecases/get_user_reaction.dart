import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/reaction.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUserReactionParams {
  final String postId;
  final String userId;

  GetUserReactionParams({required this.postId, required this.userId});
}

class GetUserReaction implements Usecase<Reaction?, GetUserReactionParams> {
  final BlogRepository repository;
  GetUserReaction(this.repository);

  @override
  Future<Either<Failure, Reaction?>> call(GetUserReactionParams params) {
    return repository.getUserReaction(params.postId, params.userId);
  }
}
