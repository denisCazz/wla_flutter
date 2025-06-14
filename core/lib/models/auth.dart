import 'user.dart';

// Login request model
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginRequest &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}

// Login response model
class LoginResponse {
  final User user;
  final String token;

  const LoginResponse({
    required this.user,
    required this.token,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginResponse &&
        other.user == user &&
        other.token == token;
  }

  @override
  int get hashCode => user.hashCode ^ token.hashCode;
}
