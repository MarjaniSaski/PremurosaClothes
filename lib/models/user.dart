class User {
  final int id;
  final String firstName;
  final String lastName;
  final String gender;
  final String username;
  final String email;
  final String phone;
  final String role;
  final String foto;
  final String? createdAt;
  final String? updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    required this.foto,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      gender: json['gender'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'user',
      foto: json['foto'] ?? 'Default_Picture.jpg',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  String get fullName => '$firstName $lastName';
  bool get isAdmin => role == 'admin';
  bool get isUser => role == 'user';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'username': username,
      'email': email,
      'phone': phone,
      'role': role,
      'foto': foto,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}