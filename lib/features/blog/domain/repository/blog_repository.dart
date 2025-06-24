import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/entities/reaction.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required Uint8List image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });

  Future<Either<Failure, List<Blog>>> getAllBlog();

  Future<Either<Failure, Blog>> updateBlog({
    required String blogId,
    required String title,
    required String content,
  });

  Future<Either<Failure, void>> deleteBlog({
    required String blogId,
  });

  Future<Either<Failure, Reaction>> addReaction(Reaction reaction);

  Future<Either<Failure, void>> removeReaction(String postId, String userId);

  Future<Either<Failure, List<Reaction>>> getReactionsByPostId(String postId);

  Future<Either<Failure, Map<ReactionType, int>>> getReactionCounts(
      String postId);

  Future<Either<Failure, Reaction?>> getUserReaction(
      String postId, String userId);
}
