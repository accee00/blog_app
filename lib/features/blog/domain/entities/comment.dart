class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? parentCommentId;
  final List<Comment>? replies;
  final int likesCount;
  final bool isLikedByCurrentUser;
  final bool isEdited;

  const Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.parentCommentId,
    this.replies,
    this.likesCount = 0,
    this.isLikedByCurrentUser = false,
    this.isEdited = false,
  });
}
