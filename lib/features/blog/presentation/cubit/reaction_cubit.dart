import 'package:bloc/bloc.dart';
import 'package:blog_app/features/blog/domain/entities/reaction.dart';
import 'package:blog_app/features/blog/domain/usecases/add_reaction_usecase.dart';
import 'package:blog_app/features/blog/domain/usecases/get_reaction_count.dart';
import 'package:blog_app/features/blog/domain/usecases/get_user_reaction.dart';
import 'package:blog_app/features/blog/domain/usecases/remove_reaction_usecase.dart';
import 'package:equatable/equatable.dart';

part 'reaction_state.dart';

class ReactionCubit extends Cubit<ReactionState> {
  final GetReactionCounts getReactionCounts;
  final AddReaction addReactionUsecase;
  final RemoveReaction removeReactionUsecase;
  final GetUserReaction getUserReactionUsecase;

  ReactionCubit(
    this.getReactionCounts,
    this.addReactionUsecase,
    this.removeReactionUsecase,
    this.getUserReactionUsecase,
  ) : super(ReactionInitial());

  Future<void> loadReactions(String postId) async {
    emit(ReactionLoading());
    final result = await getReactionCounts(postId);
    result.fold(
      (failure) => emit(ReactionError(failure.message)),
      (counts) => emit(ReactionLoaded(counts)),
    );
  }

  Future<Reaction?> getUserReaction(String postId, String userId) async {
    final result = await getUserReactionUsecase(
        GetUserReactionParams(postId: postId, userId: userId));
    return result.fold((_) => null, (reaction) => reaction);
  }

  Future<void> addReaction(Reaction reaction) async {
    await addReactionUsecase(reaction);
  }

  Future<void> removeReaction(String postId, String userId) async {
    await removeReactionUsecase(
        RemoveReactionParams(postId: postId, userId: userId));
  }
}
