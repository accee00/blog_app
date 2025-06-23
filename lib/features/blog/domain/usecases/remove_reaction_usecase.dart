import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class RemoveReactionParams {
  final String postId;
  final String userId;

  RemoveReactionParams({required this.postId, required this.userId});
}

class RemoveReaction implements Usecase<void, RemoveReactionParams> {
  final BlogRepository repository;
  RemoveReaction(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveReactionParams params) {
    return repository.removeReaction(params.postId, params.userId);
  }
}
