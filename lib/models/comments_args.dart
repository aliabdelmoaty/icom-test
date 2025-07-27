import 'package:equatable/equatable.dart';

class CommentsArgs extends Equatable {
  final int postId;
  final String number;
  final int offset;
  final String search;
  final int parent;

  const CommentsArgs({
    required this.postId,
    required this.number,
    required this.offset,
    required this.search,
    required this.parent,
  });

  factory CommentsArgs.fromJson(Map<String, dynamic> json) {
    return CommentsArgs(
      postId: json['post_id'] ?? 0,
      number: json['number']?.toString() ?? '10',
      offset: json['offset'] ?? 0,
      search: json['search'] ?? '',
      parent: json['parent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'number': number,
      'offset': offset,
      'search': search,
      'parent': parent,
    };
  }

  @override
  List<Object?> get props => [postId, number, offset, search, parent];
}
