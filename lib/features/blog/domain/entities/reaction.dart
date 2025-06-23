class Reaction {
  final String? id;
  final String postId;
  final String userId;
  final ReactionType type;
  final DateTime createdAt;

  Reaction({
    this.id,
    required this.postId,
    required this.userId,
    required this.type,
    required this.createdAt,
  });
}

enum ReactionType { like, love, laugh, angry, sad }
