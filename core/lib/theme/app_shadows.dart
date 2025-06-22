import 'package:flutter/material.dart';

/// Sistema di ombre ultra moderno per depth e gerarchia visiva
@immutable
class AppShadows extends ThemeExtension<AppShadows> {
  const AppShadows({
    this.small = _defaultSmall,
    this.medium = _defaultMedium,
    this.large = _defaultLarge,
    this.extraLarge = _defaultExtraLarge,
    this.glass = _defaultGlass,
    this.elevation = _defaultElevation,
    this.colored = _defaultColored,
  });

  // Ombre standard
  final List<BoxShadow> small;
  final List<BoxShadow> medium;
  final List<BoxShadow> large;
  final List<BoxShadow> extraLarge;
  
  // Ombre specializzate
  final List<BoxShadow> glass;
  final List<BoxShadow> elevation;
  final List<BoxShadow> colored;

  // Ombre predefinite con colori moderni
  static const List<BoxShadow> _defaultSmall = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x19000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> _defaultMedium = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x19000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  static const List<BoxShadow> _defaultLarge = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x19000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -2,
    ),
  ];

  static const List<BoxShadow> _defaultExtraLarge = [
    BoxShadow(
      color: Color(0x19000000),
      offset: Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 10),
      blurRadius: 10,
      spreadRadius: -5,
    ),
  ];

  // Ombra per effetto glass/frosted
  static const List<BoxShadow> _defaultGlass = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 8),
      blurRadius: 32,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 1),
      blurRadius: 1,
      spreadRadius: 0,
    ),
  ];

  // Ombra per elevazione Material Design
  static const List<BoxShadow> _defaultElevation = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  // Ombra colorata per elementi speciali
  static const List<BoxShadow> _defaultColored = [
    BoxShadow(
      color: Color(0x336366F1), // Primary color con opacità
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1A6366F1),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  @override
  ThemeExtension<AppShadows> copyWith({
    List<BoxShadow>? small,
    List<BoxShadow>? medium,
    List<BoxShadow>? large,
    List<BoxShadow>? extraLarge,
    List<BoxShadow>? glass,
    List<BoxShadow>? elevation,
    List<BoxShadow>? colored,
  }) {
    return AppShadows(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      extraLarge: extraLarge ?? this.extraLarge,
      glass: glass ?? this.glass,
      elevation: elevation ?? this.elevation,
      colored: colored ?? this.colored,
    );
  }

  @override
  ThemeExtension<AppShadows> lerp(
    ThemeExtension<AppShadows>? other,
    double t,
  ) {
    if (other is! AppShadows) return this;
    
    return AppShadows(
      small: _lerpShadowList(small, other.small, t),
      medium: _lerpShadowList(medium, other.medium, t),
      large: _lerpShadowList(large, other.large, t),
      extraLarge: _lerpShadowList(extraLarge, other.extraLarge, t),
      glass: _lerpShadowList(glass, other.glass, t),
      elevation: _lerpShadowList(elevation, other.elevation, t),
      colored: _lerpShadowList(colored, other.colored, t),
    );
  }

  // Helper per interpolare liste di BoxShadow
  List<BoxShadow> _lerpShadowList(
    List<BoxShadow> a,
    List<BoxShadow> b,
    double t,
  ) {
    if (a.length != b.length) return t < 0.5 ? a : b;
    
    return List.generate(a.length, (index) {
      return BoxShadow.lerp(a[index], b[index], t) ?? a[index];
    });
  }

  // Metodi di convenienza per creare ombre customizzate
  static List<BoxShadow> custom({
    required Color color,
    required Offset offset,
    required double blurRadius,
    double spreadRadius = 0,
  }) {
    return [
      BoxShadow(
        color: color,
        offset: offset,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      ),
    ];
  }

  static List<BoxShadow> coloredShadow(Color color, {double intensity = 1.0}) {
    return [
      BoxShadow(
        color: color.withOpacity(0.2 * intensity),
        offset: const Offset(0, 4),
        blurRadius: 12 * intensity,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: color.withOpacity(0.1 * intensity),
        offset: const Offset(0, 2),
        blurRadius: 4 * intensity,
        spreadRadius: 0,
      ),
    ];
  }

  // Getter per accesso rapido dal tema
  static AppShadows of(BuildContext context) {
    return Theme.of(context).extension<AppShadows>() ?? const AppShadows();
  }
}
