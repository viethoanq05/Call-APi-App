class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String company;
  final String website;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
    required this.website,
  });

  /// Convert Firestore Map -> User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      company: map['company'] ?? '',
      website: map['website'] ?? '',
    );
  }

  /// Convert User -> Map (nếu cần upload)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'company': company,
      'website': website,
    };
  }
}