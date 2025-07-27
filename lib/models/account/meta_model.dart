import 'package:equatable/equatable.dart';

class MetaModel extends Equatable {
  final String facebook;
  final String twitter;
  final String instagram;
  final String googlePlus;
  final String position;
  final String description;
  final String firstName;
  final String lastName;

  const MetaModel({
    required this.facebook,
    required this.twitter,
    required this.instagram,
    required this.googlePlus,
    required this.position,
    required this.description,
    required this.firstName,
    required this.lastName,
  });
  const MetaModel.empty()
    : facebook = '',
      twitter = '',
      instagram = '',
      googlePlus = '',
      position = '',
      description = '',
      firstName = '',
      lastName = '';

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      facebook: json['facebook'] ?? '',
      twitter: json['twitter'] ?? '',
      instagram: json['instagram'] ?? '',
      googlePlus: json['google-plus'] ?? '',
      position: json['position'] ?? '',
      description: json['description'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'facebook': facebook,
      'twitter': twitter,
      'instagram': instagram,
      'google-plus': googlePlus,
      'position': position,
      'description': description,
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  @override
  List<Object?> get props => [
    facebook,
    twitter,
    instagram,
    googlePlus,
    position,
    description,
    firstName,
    lastName,
  ];
}
