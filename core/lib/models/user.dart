// User model
class User {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ name.hashCode ^ avatarUrl.hashCode;
  }
}
