import '../models/user.dart';
import '../models/auth.dart';

// Mock authentication service
class AuthService {
  // Dati fittizi per il login
  static const Map<String, String> _mockUsers = {
    'admin@example.com': 'password123',
    'user@demo.com': 'demo2024',
    'test@app.com': 'test123',
  };

  static const Map<String, User> _mockUserData = {
    'admin@example.com': User(
      id: '1',
      email: 'admin@example.com',
      name: 'Admin User',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
    ),
    'user@demo.com': User(
      id: '2',
      email: 'user@demo.com',
      name: 'Demo User',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
    ),
    'test@app.com': User(
      id: '3',
      email: 'test@app.com',
      name: 'Test User',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
    ),
  };

  Future<LoginResponse> login(LoginRequest request) async {
    // Simula un delay di rete
    await Future.delayed(const Duration(seconds: 2));

    final email = request.email.toLowerCase().trim();
    final password = request.password;

    // Verifica le credenziali
    if (_mockUsers.containsKey(email) && _mockUsers[email] == password) {
      final user = _mockUserData[email]!;
      const token = 'mock_jwt_token_123456789';
      
      return LoginResponse(user: user, token: token);
    } else {
      throw AuthException('Credenziali non valide');
    }
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    // In un'app reale, qui verificheresti il token salvato
    return null;
  }
}

class AuthException implements Exception {
  final String message;
  
  const AuthException(this.message);
  
  @override
  String toString() => 'AuthException: $message';
}
