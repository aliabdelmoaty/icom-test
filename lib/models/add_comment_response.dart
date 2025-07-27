import 'package:equatable/equatable.dart';

import 'comment_model.dart';

class AddCommentResponse extends Equatable {
  final bool error;
  final String status;
  final String message;
  final CommentModel comment;

  const AddCommentResponse({
    required this.error,
    required this.status,
    required this.message,
    required this.comment,
  });

  factory AddCommentResponse.fromJson(Map<String, dynamic> json) {
    return AddCommentResponse(
      error: json['error'] ?? false,
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      comment: CommentModel.fromJson(json['comment'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'status': status,
      'message': message,
      'comment': comment.toJson(),
    };
  }

  @override
  List<Object?> get props => [error, status, message, comment];
}
