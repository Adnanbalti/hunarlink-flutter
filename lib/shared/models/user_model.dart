class UserModel {
  final String id;
  final String phone;
  final String name;
  final String role;
  final bool isActive;

  UserModel({
    required this.id,
    required this.phone,
    required this.name,
    required this.role,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    phone: json['phone'],
    name: json['name'],
    role: json['role'],
    isActive: json['isActive'] ?? true,
  );
}