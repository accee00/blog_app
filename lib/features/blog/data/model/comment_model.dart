import 'package:blog_app/features/blog/domain/entities/comment.dart';
import 'package:flutter/foundation.dart';

class CommentModel extends Comment {
  CommentModel({
    required super.id,
    required super.postId,
    required super.userId,
    required super.userName,
    required super.userAvatar,
    required super.content,
    required super.createdAt,
    super.updatedAt,
    super.isEdited,
    super.isLikedByCurrentUser,
    super.likesCount,
    super.parentCommentId,
    super.replies,
  });

  Comment copyWith({
    String? id,
    String? postId,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? parentCommentId,
    List<Comment>? replies,
    int? likesCount,
    bool? isLikedByCurrentUser,
    bool? isEdited,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      replies: replies ?? this.replies,
      likesCount: likesCount ?? this.likesCount,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
      isEdited: isEdited ?? this.isEdited,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'id': id,
  //     'postId': postId,
  //     'userId': userId,
  //     'userName': userName,
  //     'userAvatar': userAvatar,
  //     'content': content,
  //     'createdAt': createdAt.toIso8601String(),
  //     'updatedAt': updatedAt?.toIso8601String(),
  //     'parentCommentId': parentCommentId,
  //     'replies': replies?.map((x) => x.toMap()).toList(),
  //     'likesCount': likesCount,
  //     'isLikedByCurrentUser': isLikedByCurrentUser,
  //     'isEdited': isEdited,
  //   };
  // }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as String,
      postId: map['postId'] as String,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      userAvatar: map['userAvatar'] as String,
      content: map['content'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
      parentCommentId: map['parentCommentId'] != null
          ? map['parentCommentId'] as String
          : null,
      replies: map['replies'] != null
          ? (map['replies'] as List<dynamic>)
              .map((reply) =>
                  CommentModel.fromMap(reply as Map<String, dynamic>))
              .toList()
          : null,
      likesCount: map['likesCount'] as int,
      isLikedByCurrentUser: map['isLikedByCurrentUser'] as bool,
      isEdited: map['isEdited'] as bool,
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, postId: $postId, userId: $userId, userName: $userName, userAvatar: $userAvatar, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, parentCommentId: $parentCommentId, replies: $replies, likesCount: $likesCount, isLikedByCurrentUser: $isLikedByCurrentUser, isEdited: $isEdited)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.postId == postId &&
        other.userId == userId &&
        other.userName == userName &&
        other.userAvatar == userAvatar &&
        other.content == content &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.parentCommentId == parentCommentId &&
        listEquals(other.replies, replies) &&
        other.likesCount == likesCount &&
        other.isLikedByCurrentUser == isLikedByCurrentUser &&
        other.isEdited == isEdited;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        postId.hashCode ^
        userId.hashCode ^
        userName.hashCode ^
        userAvatar.hashCode ^
        content.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        parentCommentId.hashCode ^
        replies.hashCode ^
        likesCount.hashCode ^
        isLikedByCurrentUser.hashCode ^
        isEdited.hashCode;
  }
}
