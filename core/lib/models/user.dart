import 'package:flutter/foundation.dart';

/// Modello utente ultra moderno con supporto JSON e validazione
@immutable
class User {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final UserRole role;
  final UserStatus status;
  final Map<String, dynamic> preferences;
  final List<String> favoriteItems;
  final UserAddress? defaultAddress;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.createdAt,
    this.lastLoginAt,
    this.role = UserRole.customer,
    this.status = UserStatus.active,
    this.preferences = const {},
    this.favoriteItems = const [],
    this.defaultAddress,
  });

  // Factory constructor from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] != null 
        ? DateTime.parse(json['lastLoginAt'] as String)
        : null,
      role: UserRole.values.firstWhere(
        (role) => role.name == json['role'],
        orElse: () => UserRole.customer,
      ),
      status: UserStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => UserStatus.active,
      ),
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
      favoriteItems: List<String>.from(json['favoriteItems'] ?? []),
      defaultAddress: json['defaultAddress'] != null
        ? UserAddress.fromJson(json['defaultAddress'] as Map<String, dynamic>)
        : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'role': role.name,
      'status': status.name,
      'preferences': preferences,
      'favoriteItems': favoriteItems,
      'defaultAddress': defaultAddress?.toJson(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    UserRole? role,
    UserStatus? status,
    Map<String, dynamic>? preferences,
    List<String>? favoriteItems,
    UserAddress? defaultAddress,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      role: role ?? this.role,
      status: status ?? this.status,
      preferences: preferences ?? this.preferences,
      favoriteItems: favoriteItems ?? this.favoriteItems,
      defaultAddress: defaultAddress ?? this.defaultAddress,
    );
  }

  // Getter di convenienza
  String get displayName => name.isNotEmpty ? name : email.split('@').first;
  bool get isActive => status == UserStatus.active;
  bool get isAdmin => role == UserRole.admin;
  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;
  
  // Metodi di utilità
  bool isFavorite(String itemId) => favoriteItems.contains(itemId);
  
  User addFavorite(String itemId) {
    if (favoriteItems.contains(itemId)) return this;
    return copyWith(favoriteItems: [...favoriteItems, itemId]);
  }
  
  User removeFavorite(String itemId) {
    if (!favoriteItems.contains(itemId)) return this;
    return copyWith(
      favoriteItems: favoriteItems.where((id) => id != itemId).toList(),
    );
  }
  
  User updatePreference(String key, dynamic value) {
    final newPreferences = Map<String, dynamic>.from(preferences);
    newPreferences[key] = value;
    return copyWith(preferences: newPreferences);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.avatarUrl == avatarUrl &&
        other.createdAt == createdAt &&
        other.lastLoginAt == lastLoginAt &&
        other.role == role &&
        other.status == status &&
        mapEquals(other.preferences, preferences) &&
        listEquals(other.favoriteItems, favoriteItems) &&
        other.defaultAddress == defaultAddress;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      name,
      avatarUrl,
      createdAt,
      lastLoginAt,
      role,
      status,
      preferences,
      favoriteItems,
      defaultAddress,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, role: $role, status: $status)';
  }
}

enum UserRole {
  customer,
  admin,
  moderator,
}

enum UserStatus {
  active,
  inactive,
  suspended,
  pending,
}

/// Modello per l'indirizzo utente
@immutable
class UserAddress {
  final String street;
  final String city;
  final String postalCode;
  final String country;
  final String? state;
  final double? latitude;
  final double? longitude;

  const UserAddress({
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
    this.state,
    this.latitude,
    this.longitude,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      street: json['street'] as String,
      city: json['city'] as String,
      postalCode: json['postalCode'] as String,
      country: json['country'] as String,
      state: json['state'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'postalCode': postalCode,
      'country': country,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String get fullAddress {
    final parts = [street, city];
    if (state != null) parts.add(state!);
    parts.addAll([postalCode, country]);
    return parts.join(', ');
  }

  bool get hasCoordinates => latitude != null && longitude != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserAddress &&
        other.street == street &&
        other.city == city &&
        other.postalCode == postalCode &&
        other.country == country &&
        other.state == state &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return Object.hash(
      street,
      city,
      postalCode,
      country,
      state,
      latitude,
      longitude,
    );
  }
}
