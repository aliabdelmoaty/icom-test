import 'package:equatable/equatable.dart';

import 'comment_author.dart';

class CommentModel extends Equatable {
  final String commentId;
  final String content;
  final CommentAuthor author;
  final String datetime;
  final String repliesCount;
  final List<CommentModel> replies;

  const CommentModel({
    required this.commentId,
    required this.content,
    required this.author,
    required this.datetime,
    required this.repliesCount,
    required this.replies,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['comment_ID']?.toString() ?? '',
      content: json['content'] ?? '',
      author: CommentAuthor.fromJson(json['author'] ?? {}),
      datetime: json['datetime'] ?? '',
      repliesCount: json['replies_count'] ?? '0 replies',
      replies:
          (json['replies'] as List<dynamic>?)
              ?.map((reply) => CommentModel.fromJson(reply))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_ID': commentId,
      'content': content,
      'author': author.toJson(),
      'datetime': datetime,
      'replies_count': repliesCount,
      'replies': replies.map((reply) => reply.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    commentId,
    content,
    author,
    datetime,
    repliesCount,
    replies,
  ];
}


