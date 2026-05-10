import 'user_model.dart';

class ProviderModel {
  final String id;
  final UserModel user;
  final String skill;
  final String city;
  final double hourlyRate;
  final String bio;
  final bool isVerified;
  final double averageRating;

  ProviderModel({
    required this.id,
    required this.user,
    required this.skill,
    required this.city,
    required this.hourlyRate,
    required this.bio,
    required this.isVerified,
    required this.averageRating,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) => ProviderModel(
    id: json['id'],
    user: UserModel.fromJson(json['user']),
    skill: json['skill'] ?? '',
    city: json['city'] ?? '',
    hourlyRate: (json['hourlyRate'] ?? 0).toDouble(),
    bio: json['bio'] ?? '',
    isVerified: json['isVerified'] ?? false,
    averageRating: (json['averageRating'] ?? 0).toDouble(),
  );
}