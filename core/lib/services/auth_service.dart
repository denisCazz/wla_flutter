import '../models/user.dart';
import '../models/auth.dart';

/// Servizio di autenticazione ultra moderno con funzionalità complete
class AuthService {
  // Dati fittizi per il login
  static const Map<String, String> _mockUsers = {
    'admin@example.com': 'password123',
    'user@demo.com': 'demo2024',
    'test@app.com': 'test123',
  };

  static final Map<String, User> _mockUserData = {
    'admin@example.com': User(
      id: '1',
      email: 'admin@example.com',
      name: 'Admin User',
      role: UserRole.admin,
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      lastLoginAt: DateTime.now().subtract(const Duration(days: 2)),
      preferences: {
        'theme': 'dark',
        'notifications': true,
        'language': 'it',
      },
      favoriteItems: ['pizza_1', 'pizza_5'],
    ),
    'user@demo.com': User(
      id: '2',
      email: 'user@demo.com',
      name: 'Demo User',
      role: UserRole.customer,
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      lastLoginAt: DateTime.now().subtract(const Duration(hours: 6)),
      preferences: {
        'theme': 'light',
        'notifications': false,
        'language': 'it',
      },
      favoriteItems: ['pizza_3', 'pizza_7', 'pizza_9'],
    ),
    'test@app.com': User(
      id: '3',
      email: 'test@app.com',
      name: 'Test User',
      role: UserRole.customer,
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLoginAt: DateTime.now().subtract(const Duration(hours: 1)),
      preferences: {
        'theme': 'auto',
        'notifications': true,
        'language': 'it',
      },
      favoriteItems: [],
    ),
  };

  /// Login con sistema ultra moderno
  Future<LoginResponse> login(LoginRequest request) async {
    // Simula un delay di rete realistico
    await Future.delayed(const Duration(milliseconds: 1500));

    // Validazione della richiesta
    if (!request.isValid) {
      throw AuthException('Dati di login non validi: ${request.validationErrors.join(', ')}');
    }

    final email = request.email.toLowerCase().trim();
    final password = request.password;

    // Verifica le credenziali
    if (_mockUsers.containsKey(email) && _mockUsers[email] == password) {
      final user = _mockUserData[email]!;
      
      // Aggiorna l'ultimo login
      _mockUserData[email] = user.copyWith(lastLoginAt: DateTime.now());
      
      // Genera token con scadenza
      final accessToken = _generateMockToken();
      final refreshToken = _generateMockRefreshToken();
      final expiresAt = DateTime.now().add(const Duration(hours: 8));
      
      // Crea informazioni di sessione
      final sessionInfo = SessionInfo(
        sessionId: _generateSessionId(),
        createdAt: DateTime.now(),
        ipAddress: '192.168.1.100', // Mock IP
        userAgent: 'Flutter/${request.clientVersion ?? 'Unknown'}',
        location: 'Italy, Torino',
        isActive: true,
      );

      // Determina permessi in base al ruolo
      final permissions = _getPermissionsForRole(user.role);
      
      return LoginResponse(
        user: user,
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt: expiresAt,
        tokenType: 'Bearer',
        permissions: permissions,
        sessionInfo: sessionInfo,
      );
    } else {
      throw AuthException('Credenziali non valide. Controlla email e password.');
    }
  }

  /// Registrazione nuovo utente
  Future<LoginResponse> register(RegisterRequest request) async {
    await Future.delayed(const Duration(milliseconds: 2000));

    // Validazione della richiesta
    if (!request.isValid) {
      throw AuthException('Dati di registrazione non validi: ${request.validationErrors.join(', ')}');
    }

    // Controlla se l'utente esiste già
    if (_mockUsers.containsKey(request.email.toLowerCase())) {
      throw AuthException('Un account con questa email esiste già');
    }

    // Crea nuovo utente
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: request.email.toLowerCase(),
      name: request.name,
      role: UserRole.customer,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
      preferences: {
        'theme': 'auto',
        'notifications': request.subscribeToNewsletter,
        'language': 'it',
      },
      favoriteItems: [],
    );

    // Aggiungi ai dati mock (normalmente salvato in database)
    _mockUsers[request.email.toLowerCase()] = request.password;
    _mockUserData[request.email.toLowerCase()] = newUser;

    // Crea login response
    final sessionInfo = SessionInfo(
      sessionId: _generateSessionId(),
      createdAt: DateTime.now(),
      isActive: true,
    );

    return LoginResponse(
      user: newUser,
      accessToken: _generateMockToken(),
      refreshToken: _generateMockRefreshToken(),
      expiresAt: DateTime.now().add(const Duration(hours: 8)),
      permissions: _getPermissionsForRole(newUser.role),
      sessionInfo: sessionInfo,
    );
  }

  /// Reset password
  Future<void> resetPassword(PasswordResetRequest request) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!request.isEmailValid) {
      throw AuthException('Email non valida');
    }

    if (!_mockUsers.containsKey(request.email.toLowerCase())) {
      throw AuthException('Nessun account trovato con questa email');
    }

    // In un'app reale, invieresti un'email di reset
    // Per ora simula solo l'operazione
  }

  /// Logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In un'app reale, invalidaresti il token sul server
  }

  /// Verifica utente corrente
  Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    // In un'app reale, verificheresti il token salvato
    return null;
  }

  /// Refresh token
  Future<LoginResponse> refreshToken(String refreshToken) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // In un'app reale, verificheresti il refresh token
    throw AuthException('Refresh token non valido o scaduto');
  }

  // Metodi di utilità privati

  String _generateMockToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjokdGltZXN0YW1wfQ.mock_signature_$timestamp';
  }

  String _generateMockRefreshToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'refresh_token_mock_$timestamp';
  }

  String _generateSessionId() {
    return 'session_${DateTime.now().millisecondsSinceEpoch}';
  }

  List<String> _getPermissionsForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return ['read', 'write', 'delete', 'admin'];
      case UserRole.moderator:
        return ['read', 'write'];
      case UserRole.customer:
        return ['read'];
    }
  }
}

/// Eccezione personalizzata per errori di autenticazione
class AuthException implements Exception {
  final String message;
  final String? code;
  final DateTime timestamp;
  
  AuthException(this.message, {this.code}) : timestamp = DateTime.now();
  
  @override
  String toString() => 'AuthException: $message';
  
  /// Converte in JSON per logging
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
