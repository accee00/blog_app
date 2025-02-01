part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogFailure extends BlogState {
  final String error;
  BlogFailure(this.error);
}

final class BlogSuccess extends BlogState {}

final class BlogDisplaySucess extends BlogState {
  final List<Blog> blog;
  BlogDisplaySucess(this.blog);
}

final class BlogDeletedSuccess extends BlogState {}
