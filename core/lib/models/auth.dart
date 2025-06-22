import 'package:flutter/foundation.dart';
import 'user.dart';

/// Modello di richiesta login ultra moderno con validazione e sicurezza
@immutable
class LoginRequest {
  final String email;
  final String password;
  final String? deviceId;
  final String? deviceName;
  final bool rememberMe;
  final String? clientVersion;
  final DateTime timestamp;

  LoginRequest({
    required this.email,
    required this.password,
    this.deviceId,
    this.deviceName,
    this.rememberMe = false,
    this.clientVersion,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Crea LoginRequest da JSON
  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      deviceId: json['deviceId'] as String?,
      deviceName: json['deviceName'] as String?,
      rememberMe: json['rememberMe'] as bool? ?? false,
      clientVersion: json['clientVersion'] as String?,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  /// Converte LoginRequest in JSON (senza password per sicurezza)
  Map<String, dynamic> toJson({bool includePassword = false}) {
    final json = {
      'email': email,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'rememberMe': rememberMe,
      'clientVersion': clientVersion,
      'timestamp': timestamp.toIso8601String(),
    };
    
    if (includePassword) {
      json['password'] = password;
    }
    
    return json;
  }

  /// Validazione email
  bool get isEmailValid {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  /// Validazione password (minimo 6 caratteri)
  bool get isPasswordValid => password.length >= 6;

  /// Validazione completa
  bool get isValid => isEmailValid && isPasswordValid;

  /// Lista errori di validazione
  List<String> get validationErrors {
    final errors = <String>[];
    if (!isEmailValid) errors.add('Email non valida');
    if (!isPasswordValid) errors.add('Password deve avere almeno 6 caratteri');
    return errors;
  }

  LoginRequest copyWith({
    String? email,
    String? password,
    String? deviceId,
    String? deviceName,
    bool? rememberMe,
    String? clientVersion,
    DateTime? timestamp,
  }) {
    return LoginRequest(
      email: email ?? this.email,
      password: password ?? this.password,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      rememberMe: rememberMe ?? this.rememberMe,
      clientVersion: clientVersion ?? this.clientVersion,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginRequest &&
        other.email == email &&
        other.password == password &&
        other.deviceId == deviceId &&
        other.deviceName == deviceName &&
        other.rememberMe == rememberMe &&
        other.clientVersion == clientVersion &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(
      email,
      password,
      deviceId,
      deviceName,
      rememberMe,
      clientVersion,
      timestamp,
    );
  }

  @override
  String toString() {
    return 'LoginRequest(email: $email, deviceId: $deviceId, rememberMe: $rememberMe)';
  }
}

/// Modello di risposta login ultra moderno con token management
@immutable
class LoginResponse {
  final User user;
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;
  final String tokenType;
  final List<String> permissions;
  final SessionInfo sessionInfo;

  const LoginResponse({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    required this.expiresAt,
    this.tokenType = 'Bearer',
    this.permissions = const [],
    required this.sessionInfo,
  });

  /// Crea LoginResponse da JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      permissions: List<String>.from(json['permissions'] as List? ?? []),
      sessionInfo: SessionInfo.fromJson(json['sessionInfo'] as Map<String, dynamic>),
    );
  }

  /// Converte LoginResponse in JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
      'tokenType': tokenType,
      'permissions': permissions,
      'sessionInfo': sessionInfo.toJson(),
    };
  }

  /// Verifica se il token è scaduto
  bool get isTokenExpired => DateTime.now().isAfter(expiresAt);

  /// Tempo rimanente prima della scadenza
  Duration get timeUntilExpiry => expiresAt.difference(DateTime.now());

  /// Verifica se il token è vicino alla scadenza (meno di 5 minuti)
  bool get isTokenExpiringSoon => timeUntilExpiry.inMinutes < 5;

  /// Header Authorization formattato
  String get authorizationHeader => '$tokenType $accessToken';

  LoginResponse copyWith({
    User? user,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? tokenType,
    List<String>? permissions,
    SessionInfo? sessionInfo,
  }) {
    return LoginResponse(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      tokenType: tokenType ?? this.tokenType,
      permissions: permissions ?? this.permissions,
      sessionInfo: sessionInfo ?? this.sessionInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginResponse &&
        other.user == user &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        other.expiresAt == expiresAt &&
        other.tokenType == tokenType &&
        listEquals(other.permissions, permissions) &&
        other.sessionInfo == sessionInfo;
  }

  @override
  int get hashCode {
    return Object.hash(
      user,
      accessToken,
      refreshToken,
      expiresAt,
      tokenType,
      permissions,
      sessionInfo,
    );
  }

  @override
  String toString() {
    return 'LoginResponse(user: ${user.email}, tokenType: $tokenType, expiresAt: $expiresAt)';
  }
}

/// Informazioni sulla sessione utente
@immutable
class SessionInfo {
  final String sessionId;
  final DateTime createdAt;
  final String? ipAddress;
  final String? userAgent;
  final String? location;
  final bool isActive;

  const SessionInfo({
    required this.sessionId,
    required this.createdAt,
    this.ipAddress,
    this.userAgent,
    this.location,
    this.isActive = true,
  });

  /// Crea SessionInfo da JSON
  factory SessionInfo.fromJson(Map<String, dynamic> json) {
    return SessionInfo(
      sessionId: json['sessionId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      ipAddress: json['ipAddress'] as String?,
      userAgent: json['userAgent'] as String?,
      location: json['location'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Converte SessionInfo in JSON
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'createdAt': createdAt.toIso8601String(),
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'location': location,
      'isActive': isActive,
    };
  }

  /// Durata della sessione
  Duration get sessionDuration => DateTime.now().difference(createdAt);

  /// Descrizione formattata della sessione
  String get formattedInfo {
    final parts = <String>[];
    if (location != null) parts.add(location!);
    if (ipAddress != null) parts.add(ipAddress!);
    return parts.join(' • ');
  }

  SessionInfo copyWith({
    String? sessionId,
    DateTime? createdAt,
    String? ipAddress,
    String? userAgent,
    String? location,
    bool? isActive,
  }) {
    return SessionInfo(
      sessionId: sessionId ?? this.sessionId,
      createdAt: createdAt ?? this.createdAt,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SessionInfo &&
        other.sessionId == sessionId &&
        other.createdAt == createdAt &&
        other.ipAddress == ipAddress &&
        other.userAgent == userAgent &&
        other.location == location &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return Object.hash(
      sessionId,
      createdAt,
      ipAddress,
      userAgent,
      location,
      isActive,
    );
  }

  @override
  String toString() {
    return 'SessionInfo(sessionId: $sessionId, location: $location, isActive: $isActive)';
  }
}

/// Richiesta di registrazione per nuovi utenti
@immutable
class RegisterRequest {
  final String email;
  final String password;
  final String confirmPassword;
  final String name;
  final String? phone;
  final bool acceptTerms;
  final bool subscribeToNewsletter;
  final String? referralCode;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.name,
    this.phone,
    required this.acceptTerms,
    this.subscribeToNewsletter = false,
    this.referralCode,
  });

  /// Crea RegisterRequest da JSON
  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      acceptTerms: json['acceptTerms'] as bool,
      subscribeToNewsletter: json['subscribeToNewsletter'] as bool? ?? false,
      referralCode: json['referralCode'] as String?,
    );
  }

  /// Converte RegisterRequest in JSON (senza password per sicurezza)
  Map<String, dynamic> toJson({bool includePasswords = false}) {
    final json = {
      'email': email,
      'name': name,
      'phone': phone,
      'acceptTerms': acceptTerms,
      'subscribeToNewsletter': subscribeToNewsletter,
      'referralCode': referralCode,
    };
    
    if (includePasswords) {
      json['password'] = password;
      json['confirmPassword'] = confirmPassword;
    }
    
    return json;
  }

  /// Validazione completa
  bool get isValid {
    return isEmailValid && 
           isPasswordValid && 
           passwordsMatch && 
           isNameValid && 
           acceptTerms;
  }

  /// Validazione email
  bool get isEmailValid {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  /// Validazione password
  bool get isPasswordValid => password.length >= 8;

  /// Controllo che le password corrispondano
  bool get passwordsMatch => password == confirmPassword;

  /// Validazione nome
  bool get isNameValid => name.trim().length >= 2;

  /// Lista errori di validazione
  List<String> get validationErrors {
    final errors = <String>[];
    if (!isEmailValid) errors.add('Email non valida');
    if (!isPasswordValid) errors.add('Password deve avere almeno 8 caratteri');
    if (!passwordsMatch) errors.add('Le password non corrispondono');
    if (!isNameValid) errors.add('Nome deve avere almeno 2 caratteri');
    if (!acceptTerms) errors.add('Devi accettare i termini e condizioni');
    return errors;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegisterRequest &&
        other.email == email &&
        other.password == password &&
        other.confirmPassword == confirmPassword &&
        other.name == name &&
        other.phone == phone &&
        other.acceptTerms == acceptTerms &&
        other.subscribeToNewsletter == subscribeToNewsletter &&
        other.referralCode == referralCode;
  }

  @override
  int get hashCode {
    return Object.hash(
      email,
      password,
      confirmPassword,
      name,
      phone,
      acceptTerms,
      subscribeToNewsletter,
      referralCode,
    );
  }

  @override
  String toString() {
    return 'RegisterRequest(email: $email, name: $name, acceptTerms: $acceptTerms)';
  }
}

/// Richiesta di reset password
@immutable
class PasswordResetRequest {
  final String email;
  final DateTime timestamp;

  PasswordResetRequest({
    required this.email,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Crea PasswordResetRequest da JSON
  factory PasswordResetRequest.fromJson(Map<String, dynamic> json) {
    return PasswordResetRequest(
      email: json['email'] as String,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  /// Converte PasswordResetRequest in JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Validazione email
  bool get isEmailValid {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PasswordResetRequest &&
        other.email == email &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode => Object.hash(email, timestamp);

  @override
  String toString() {
    return 'PasswordResetRequest(email: $email, timestamp: $timestamp)';
  }
}
