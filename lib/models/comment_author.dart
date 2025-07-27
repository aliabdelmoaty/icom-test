import 'package:equatable/equatable.dart';

class CommentAuthor extends Equatable {
  final int id;
  final String login;
  final String avatar;
  final String avatarUrl;
  final String email;
  final String url;
  final List<String> roles;

  const CommentAuthor({
    required this.id,
    required this.login,
    required this.avatar,
    required this.avatarUrl,
    required this.email,
    required this.url,
    required this.roles,
  });

  factory CommentAuthor.fromJson(Map<String, dynamic> json) {
    List<String> rolesList = [];
    if (json['roles'] != null) {
      if (json['roles'] is List) {
        rolesList = List<String>.from(json['roles']);
      } else if (json['roles'] is Map) {
        rolesList = (json['roles'] as Map).values.cast<String>().toList();
      }
    }

    return CommentAuthor(
      id: json['id'] ?? 0,
      login: json['login'] ?? '',
      avatar: json['avatar'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      email: json['email'] ?? '',
      url: json['url'] ?? '',
      roles: rolesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login': login,
      'avatar': avatar,
      'avatar_url': avatarUrl,
      'email': email,
      'url': url,
      'roles': roles,
    };
  }

  @override
  List<Object?> get props => [id, login, avatar, avatarUrl, email, url, roles];
}
