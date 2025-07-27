import 'package:equatable/equatable.dart';

import 'comment_model.dart';
import 'comments_args.dart';

class CommentsResponse extends Equatable {
  final List<CommentModel> posts;
  final CommentsArgs args;

  const CommentsResponse({required this.posts, required this.args});

  factory CommentsResponse.fromJson(Map<String, dynamic> json) {
    return CommentsResponse(
      posts:
          (json['posts'] as List<dynamic>?)
              ?.map((post) => CommentModel.fromJson(post))
              .toList() ??
          [],
      args: CommentsArgs.fromJson(json['args'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts': posts.map((post) => post.toJson()).toList(),
      'args': args.toJson(),
    };
  }

  @override
  List<Object?> get props => [posts, args];
}
