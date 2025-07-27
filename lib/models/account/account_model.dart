import 'package:equatable/equatable.dart';

import 'meta_model.dart';
import 'rating_model.dart';

class AccountModel extends Equatable {
  final int id;
  final String login;
  final String avatarUrl;
  final String email;
  final String url;
  final List<String> roles;
  final MetaModel meta;
  final RatingModel rating;
  final int totalCourses;
  final String profileUrl;

  const AccountModel({
    required this.id,
    required this.login,
    required this.avatarUrl,
    required this.email,
    required this.url,
    required this.roles,
    required this.meta,
    required this.rating,
    required this.totalCourses,
    required this.profileUrl,
  });

  const AccountModel.empty()
    : id = 0,
      login = '',
      avatarUrl = '',
      email = '',
      url = '',
      roles = const [],
      meta = const MetaModel.empty(),
      rating = const RatingModel.empty(),
      totalCourses = 0,
      profileUrl = '';

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] ?? 0,
      login: json['login'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      email: json['email'] ?? '',
      url: json['url'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      meta: MetaModel.fromJson(json['meta'] ?? {}),
      rating: RatingModel.fromJson(json['rating'] ?? {}),
      totalCourses: json['total_courses'] ?? 0,
      profileUrl: json['profile_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login': login,
      'avatar_url': avatarUrl,
      'email': email,
      'url': url,
      'roles': roles,
      'meta': meta.toJson(),
      'rating': rating.toJson(),
      'total_courses': totalCourses,
      'profile_url': profileUrl,
    };
  }

  @override
  List<Object?> get props => [
    id,
    login,
    avatarUrl,
    email,
    url,
    roles,
    meta,
    rating,
    totalCourses,
    profileUrl,
  ];
}


