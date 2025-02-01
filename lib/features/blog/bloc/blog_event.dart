part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUploadEvent extends BlogEvent {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  BlogUploadEvent({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}

final class BlogFetchAllBlogs extends BlogEvent {}

final class BlogUpdateEvent extends BlogEvent {
  final String posterId;
  final String title;
  final String content;

  BlogUpdateEvent({
    required this.posterId,
    required this.title,
    required this.content,
  });
}
