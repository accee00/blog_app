import 'package:blog_app/features/blog/domain/entities/reaction.dart';

class ReactionModel extends Reaction {
  ReactionModel({
    super.id,
    required super.postId,
    required super.userId,
    required super.type,
    required super.createdAt,
  });

  ReactionModel copyWith({
    String? id,
    String? postId,
    String? userId,
    ReactionType? type,
    DateTime? createdAt,
  }) {
    return ReactionModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'type': type.name,
      'created_at': createdAt.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  factory ReactionModel.fromMap(Map<String, dynamic> map) {
    return ReactionModel(
      id: map['id'] as String,
      postId: map['post_id'] as String,
      userId: map['user_id'] as String,
      type: ReactionType.values.byName(map['type']),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  @override
  String toString() {
    return 'Reaction(id: $id, postId: $postId, userId: $userId, type: $type, createdAt: $createdAt)';
  }
}
