part of 'reaction_cubit.dart';

abstract class ReactionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReactionInitial extends ReactionState {}

class ReactionLoading extends ReactionState {}

class ReactionLoaded extends ReactionState {
  final Map<ReactionType, int> counts;
  ReactionLoaded(this.counts);

  @override
  List<Object?> get props => [counts];
}

class ReactionError extends ReactionState {
  final String message;
  ReactionError(this.message);

  @override
  List<Object?> get props => [message];
}
