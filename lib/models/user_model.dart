// lib/models/user_model.dart

class UserModel {
  final String id;
  final String username;
  final String email;
  final String role;
  final Map<String, dynamic>? profile;
  final String token;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.profile,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:       json['user']['id'],
      username: json['user']['username'],
      email:    json['user']['email'],
      role:     json['user']['role'],
      profile:  json['user']['profile'],
      token:    json['token'] ?? '',
    );
  }

  /// Khusus untuk parse response GET /api/user (tidak ada field token)
  factory UserModel.fromMeJson(Map<String, dynamic> json) {
    return UserModel(
      id:       json['user']['id'],
      username: json['user']['username'],
      email:    json['user']['email'],
      role:     json['user']['role'],
      profile:  json['user']['profile'],
      token:    '',
    );
  }
}